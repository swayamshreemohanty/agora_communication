import 'package:agora_example_test/communication/logic/agora_av_manager/agora_av_manager_cubit.dart';
import 'package:agora_example_test/communication/logic/av_controller/av_controller_cubit.dart';
import 'package:agora_example_test/communication/model/agora_engine_type_enum.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoCommunicationScreen extends StatefulWidget {
  const VideoCommunicationScreen({super.key});

  @override
  State<VideoCommunicationScreen> createState() =>
      _VideoCommunicationScreenState();
}

class _VideoCommunicationScreenState extends State<VideoCommunicationScreen> {
  final engine = createAgoraRtcEngine();
  @override
  void initState() {
    super.initState();
    context
        .read<AgoraAvManagerCubit>()
        .initializeRTCEngine(engine, agoraEngineType: AgoraEngineType.video);
  }

  @override
  void dispose() {
    engine.leaveChannel();
    super.dispose();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: BlocBuilder<AgoraAvManagerCubit, AgoraAvManagerState>(
        builder: (context, agoraAVstate) {
          if (agoraAVstate is AgoraAVEngineConencted) {
            return Stack(
              children: [
                agoraAVstate.remoteUserMuteVideo
                    ? const Center(
                        child: Icon(
                          Icons.person,
                          size: 250,
                        ),
                      )
                    : Center(
                        child: _remoteVideo(
                        rtcEngine: agoraAVstate.rtcEngine,
                        channel: agoraAVstate.channelId,
                        remoteUid: agoraAVstate.remoteUserUID,
                      )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: BlocBuilder<AvControllerCubit, AvControllerState>(
                      builder: (context, avControllerState) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width:
                                  avControllerState.isVideoMuted ? 0.05 : 0.001,
                            ),
                          ),
                          width: 100,
                          height: 150,
                          child: Center(
                            child: agoraAVstate.localUserConencted
                                ? avControllerState.isVideoMuted
                                    ? const Icon(
                                        Icons.person,
                                        size: 80,
                                      )
                                    : AgoraVideoView(
                                        controller: VideoViewController(
                                          rtcEngine: agoraAVstate.rtcEngine,
                                          canvas: const VideoCanvas(uid: 0),
                                        ),
                                      )
                                : const CircularProgressIndicator(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (agoraAVstate.remoteUserMuteAudio)
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.mic_off,
                          size: 25,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                BlocBuilder<AvControllerCubit, AvControllerState>(
                  builder: (context, avControllerState) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    context
                                        .read<AvControllerCubit>()
                                        .videoToggle();
                                  },
                                  shape: const CircleBorder(),
                                  fillColor: avControllerState.isVideoMuted
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  child: Icon(
                                    avControllerState.isVideoMuted
                                        ? Icons.videocam_off
                                        : Icons.videocam_off,
                                    color: avControllerState.isVideoMuted
                                        ? Colors.white
                                        : Colors.blueAccent,
                                    size: 25,
                                  ),
                                ),
                                RawMaterialButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    context
                                        .read<AvControllerCubit>()
                                        .audioMuteUnmute();
                                  },
                                  shape: const CircleBorder(),
                                  fillColor: avControllerState.isAudioMuted
                                      ? Colors.blueAccent
                                      : Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  child: Icon(
                                    avControllerState.isAudioMuted
                                        ? Icons.mic_off
                                        : Icons.mic,
                                    color: avControllerState.isAudioMuted
                                        ? Colors.white
                                        : Colors.blueAccent,
                                    size: 25,
                                  ),
                                ),
                                RawMaterialButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    engine.switchCamera();
                                  },
                                  shape: const CircleBorder(),
                                  fillColor: Colors.white,
                                  padding: const EdgeInsets.all(15),
                                  child: const Icon(
                                    Icons.switch_camera,
                                    color: Colors.blueAccent,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            RawMaterialButton(
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                Navigator.pop(context);
                              },
                              shape: const CircleBorder(),
                              fillColor: Colors.redAccent,
                              padding: const EdgeInsets.all(15),
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }
        },
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo(
      {required RtcEngine rtcEngine, int? remoteUid, required String channel}) {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: rtcEngine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }
}