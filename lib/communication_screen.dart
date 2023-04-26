import 'package:agora_sdk_engine/communication/model/agora_creds_model.dart';
import 'package:agora_sdk_engine/communication/screens/video_communication_screen.dart';
import 'package:agora_sdk_engine/communication/screens/voice_communication_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
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
                              builder: (context) => VideoCommunicationScreen(
                                  agoraCredentialsModel: agoraCreds),
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
                              builder: (context) => VoiceCommunicationScreen(
                                  agoraCredentialsModel: agoraCreds),
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
