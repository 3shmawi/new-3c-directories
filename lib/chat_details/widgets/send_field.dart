import 'package:flutter/material.dart';

import 'messages_provider.dart';

class SendFieldWidget extends StatefulWidget {
  const SendFieldWidget({super.key});

  @override
  State<SendFieldWidget> createState() => _SendFieldWidgetState();
}

class _SendFieldWidgetState extends State<SendFieldWidget> {
  final messageCtrl = TextEditingController();
  late final ctrl = StringListProvider.of(context);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: messageCtrl,
              decoration: InputDecoration(
                hintText: "Message...",
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.sticky_note_2_outlined,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.attach_file),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.camera_alt_outlined),
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              ),
            ),
          ),
        ),
        FloatingActionButton.small(
          shape: CircleBorder(),
          onPressed: () {
            if (messageCtrl.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please write anything")));
            } else {
              ctrl.addString(messageCtrl.text);
              messageCtrl.clear();
            }
          },
          child: Icon(
            Icons.send,
            size: 20,
          ),
        ),
      ],
    );
  }
}
