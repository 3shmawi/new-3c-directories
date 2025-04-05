import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/screens/auth/login.dart';

class LogoutCubit {
  final _auth = FirebaseAuth.instance;

  void logout(BuildContext context) async {
    try {
      await _auth.signOut();
      context.showSuccess('Logout successful');
      context.pushAndRemoveUntil(LoginScreen());
    } catch (error) {
      context.showError('Logout failed: ${error.toString()}');
    }
  }
}
