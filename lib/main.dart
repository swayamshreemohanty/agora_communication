// ignore_for_file: use_build_context_synchronously

import 'package:agora_example_test/communication/logic/agora_av_manager/agora_av_manager_cubit.dart';
import 'package:agora_example_test/communication/logic/av_controller/av_controller_cubit.dart';
import 'package:agora_example_test/communication/model/agora_creds_model.dart';
import 'package:agora_example_test/communication/screens/video_communication_screen.dart';
import 'package:agora_example_test/communication/screens/voice_communication_screen.dart';
import 'package:agora_example_test/communication/widget/chat/agora_credential_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final agoraCreds = await showDialog<AgoraCredentialsModel>(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: EnterCredentialDialogWidget(),
                    );
                  },
                );
                if (agoraCreds != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => AgoraAvManagerCubit(),
                          ),
                          BlocProvider(
                            create: (context) => AvControllerCubit(
                              agoraAvManagerCubit:
                                  context.read<AgoraAvManagerCubit>(),
                            ),
                          ),
                        ],
                        child: VideoCommunicationScreen(
                            agoraCredentialsModel: agoraCreds),
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "No Credentials Found",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
              child: const Text("Video call"),
            ),
            ElevatedButton(
              onPressed: () async {
                final agoraCreds = await showDialog<AgoraCredentialsModel>(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: EnterCredentialDialogWidget(),
                    );
                  },
                );
                if (agoraCreds != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => AgoraAvManagerCubit(),
                          ),
                          BlocProvider(
                            create: (context) => AvControllerCubit(
                              agoraAvManagerCubit:
                                  context.read<AgoraAvManagerCubit>(),
                            ),
                          ),
                        ],
                        child: VoiceCommunicationScreen(
                            agoraCredentialsModel: agoraCreds),
                      ),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "No Credentials Found",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
              child: const Text("Voice call"),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => BlocProvider(
            //           create: (context) => AgoraChatManagerCubit(),
            //           child: const ChatScreen(),
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text("Chat"),
            // )
          ],
        ),
      ),
    );
  }
}

