import 'package:flutter/material.dart';

class SendFieldWidget extends StatelessWidget {
  const SendFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
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
          onPressed: () {},
          child: Icon(
            Icons.send,
            size: 20,
          ),
        ),
      ],
    );
  }
}
