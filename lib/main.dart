// ignore_for_file: use_build_context_synchronously

import 'package:agora_communication/communication/logic/agora_av_manager/agora_av_manager_cubit.dart';
import 'package:agora_communication/communication/logic/av_controller/av_controller_cubit.dart';
import 'package:agora_communication/communication/model/agora_creds_model.dart';
import 'package:agora_communication/communication/screens/video_communication_screen.dart';
import 'package:agora_communication/communication/screens/voice_communication_screen.dart';
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
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final appIdTextController = TextEditingController();
  final tokenTextController = TextEditingController();
  final channelIdTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication'),
      ),
      body: Center(
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: appIdTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter App Id",
                        labelText: "Enter App Id",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can't be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: channelIdTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter Channel Name",
                        labelText: "Enter Channel Name",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can't be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: tokenTextController,
                      decoration: const InputDecoration(
                        hintText: "Enter Token",
                        labelText: "Enter Token",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can't be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          final agoraCreds = AgoraCredentialsModel(
                            appId: appIdTextController.text.trim(),
                            channelName: channelIdTextController.text.trim(),
                            token: tokenTextController.text.trim(),
                          );

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
                                  agoraCredentialsModel: agoraCreds,
                                ),
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
                      child: const Text("Start Video call"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();

                          final agoraCreds = AgoraCredentialsModel(
                            appId: appIdTextController.text.trim(),
                            channelName: channelIdTextController.text.trim(),
                            token: tokenTextController.text.trim(),
                          );

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
                      child: const Text("Start Voice call"),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
