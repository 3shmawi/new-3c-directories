import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Profile screen"),
          SizedBox(height: 20),
          Text(
            user?.email ?? "No Email",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          LogoutButton(),
        ],
      ),
    );
  }
}
