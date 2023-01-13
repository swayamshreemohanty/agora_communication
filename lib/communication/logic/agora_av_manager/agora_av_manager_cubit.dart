import 'package:agora_example_test/communication/model/agora_engine_type_enum.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

part 'agora_av_manager_state.dart';

class AgoraAvManagerCubit extends Cubit<AgoraAvManagerState> {
  AgoraAvManagerCubit() : super(LoadingAgoraAVManager());

  //config file
  final appId = "c515c8ebf3314ff891288bad02137740";
  final videoToken =
      "007eJxTYJjFzzTPo/W8ULP985yrM0U9s14WbbSWsJkjf06MdY2IQagCQ7KpoWmyRWpSmrGxoUlamoWloZGFRVJiioGRobG5uYmB+tH9yQ2BjAzsfpYMjFAI4nMzJKbnFyXGl2WmpOYzMAAAIF8eNg==";
  final videoChannel = "agora_video";

  final audioToken =
      "007eJxTYOitfDmhS6960ZnvnxOnvWJy9roY3r3xp6ddQZA2o1aHnpYCQ7KpoWmyRWpSmrGxoUlamoWloZGFRVJiioGRobG5uYlB4tH9yQ2BjAzxO4xYGRkgEMTnZkhMzy9KjC/Lz0xOZWAAAD6rIb8=";
  final audioChannel = "agora_voice";
  //

  RtcEngine? _engine;

  void engineConnected({
    required bool localUserConencted,
    int? remoteUserUID,
    required String channelId,
    required RtcEngine rtcEngine,
    bool remoteUserMuteAudio = false,
    bool remoteUserMuteVideo = false,
  }) {
    if (isClosed) {
      return;
    }
    emit(LoadingAgoraAVManager());
    emit(AgoraAVEngineConencted(
      localUserConencted: localUserConencted,
      remoteUserUID: remoteUserUID,
      channelId: channelId,
      rtcEngine: rtcEngine,
      remoteUserMuteAudio: remoteUserMuteAudio,
      remoteUserMuteVideo: remoteUserMuteVideo,
    ));
  }

  Future<void> initializeRTCEngine(
    RtcEngine engine, {
    required AgoraEngineType agoraEngineType,
  }) async {
    try {
      _engine = engine;
      // retrieve permissions
      await [Permission.microphone, Permission.camera].request();

      await _engine!.initialize(RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
      final channelId = agoraEngineType == AgoraEngineType.video
          ? videoChannel
          : audioChannel;
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            engineConnected(
              localUserConencted: true,
              channelId: channelId,
              rtcEngine: _engine!,
            );
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            engineConnected(
              localUserConencted: true,
              remoteUserUID: remoteUid,
              channelId: channelId,
              rtcEngine: _engine!,
            );
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            engineConnected(
              localUserConencted: true,
              remoteUserUID: null, //set remote id to null
              channelId: channelId,
              rtcEngine: _engine!,
            );
          },
          onLeaveChannel: (connection, stats) {
            // _remoteUid = null;
            engineConnected(
              localUserConencted: true,
              remoteUserUID: null, //set remote id to null
              channelId: channelId,
              rtcEngine: _engine!,
            );
          },
          onUserMuteAudio: (connection, remoteUid, muted) {
            engineConnected(
              localUserConencted: true,
              remoteUserUID: remoteUid,
              channelId: channelId,
              rtcEngine: _engine!,
              remoteUserMuteAudio: muted,
            );
          },
          onUserMuteVideo: (connection, remoteUid, muted) {
            engineConnected(
              localUserConencted: true,
              remoteUserUID: remoteUid,
              channelId: channelId,
              rtcEngine: _engine!,
              remoteUserMuteVideo: muted,
            );
          },

          //TODO:Need to check
          // onRejoinChannelSuccess: (connection, elapsed) {
          //   Fluttertoast.showToast(msg: "Remote user $elapsed re joined");
          //   engineConnected(
          //     localUserConencted: true,
          //     remoteUserUID: elapsed,
          //     channelId: channel,
          //     rtcEngine: _engine!,
          //   );
          // },
          onTokenPrivilegeWillExpire:
              (RtcConnection connection, String token) {},
        ),
      );

      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      if (agoraEngineType == AgoraEngineType.video) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
      }
      await _engine!.joinChannel(
        token:
            agoraEngineType == AgoraEngineType.video ? videoToken : audioToken,
        channelId: channelId,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      emit(AgoraAVManagerError(error: e.toString()));
    }
  }

  Future<void> audioMuteUnmute(bool mute) async {
    await _engine!.muteLocalAudioStream(mute);
  }

  Future<void> videoMuteUnmute(bool mute) async {
    await _engine!.muteLocalVideoStream(mute);
  }
}
