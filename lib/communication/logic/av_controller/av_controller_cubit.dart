// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora_example_test/communication/logic/agora_av_manager/agora_av_manager_cubit.dart';

part 'av_controller_state.dart';

class AvControllerCubit extends Cubit<AvControllerState> {
  final AgoraAvManagerCubit agoraAvManagerCubit;
  AvControllerCubit({
    required this.agoraAvManagerCubit,
  }) : super(const AvControllerState());

  Future<void> audioMuteUnmute() async {
    await agoraAvManagerCubit.audioMuteUnmute(!state.isAudioMuted);
    emit(state.copyWith(isAudioMuted: !state.isAudioMuted));
  }

  Future<void> videoToggle() async {
    await agoraAvManagerCubit.videoMuteUnmute(!state.isVideoMuted);
    emit(state.copyWith(isVideoMuted: !state.isVideoMuted));
  }
}
