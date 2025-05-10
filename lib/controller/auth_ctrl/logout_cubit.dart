import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/screens/auth/login.dart';

import '../user_ctrl/user_cubit.dart';

class LogoutCubit {
  final _auth = FirebaseAuth.instance;

  void logout(BuildContext context) async {
    try {
      userCubit(context).updateUserStatus(false);

      await _auth.signOut();
      context.showSuccess('Logout successful');
      context.pushAndRemoveUntil(LoginScreen());
    } catch (error) {
      userCubit(context).updateUserStatus(true);

      context.showError('Logout failed: ${error.toString()}');
    }
  }
}
