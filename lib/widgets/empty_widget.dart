import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.network_wifi_3_bar_outlined,
          size: 150,
          color: Colors.grey,
        ),
        const Text(
          "No data available",
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ],
    );
  }
}
