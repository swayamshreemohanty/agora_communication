import 'package:agora_example_test/communication/model/agora_creds_model.dart';
import 'package:flutter/material.dart';

class EnterCredentialDialogWidget extends StatefulWidget {
  const EnterCredentialDialogWidget({super.key});

  @override
  State<EnterCredentialDialogWidget> createState() =>
      _EnterCredentialDialogWidgetState();
}

class _EnterCredentialDialogWidgetState
    extends State<EnterCredentialDialogWidget> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final appIdTextController = TextEditingController();
  final tokenTextController = TextEditingController();
  final channelIdTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (formkey.currentState!.validate()) {
                final agoraCreds = AgoraCredentialsModel(
                  appId: appIdTextController.text.trim(),
                  channelName: channelIdTextController.text.trim(),
                  token: tokenTextController.text.trim(),
                );
                Navigator.pop(context, agoraCreds);
              }
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}
