import 'package:agora_example_test/communication/logic/agora_av_manager/agora_av_manager_cubit.dart';
import 'package:agora_example_test/communication/logic/av_controller/av_controller_cubit.dart';
import 'package:agora_example_test/communication/screens/chat_screen.dart';
import 'package:agora_example_test/communication/screens/video_communication_screen.dart';
import 'package:agora_example_test/communication/screens/voice_communication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              onPressed: () {
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
                      child: const VideoCommunicationScreen(),
                    ),
                  ),
                );
              },
              child: const Text("Video call"),
            ),
            ElevatedButton(
              onPressed: () {
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
                      child: const VoiceCommunicationScreen(),
                    ),
                  ),
                );
              },
              child: const Text("Voice call"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              child: const Text("Chat"),
            )
          ],
        ),
      ),
    );
  }
}
