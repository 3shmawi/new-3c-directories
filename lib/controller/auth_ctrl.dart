import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isPassword = true;

  void togglePasswordVisibility() {
    isPassword = !isPassword;
    emit(TogglePasswordVisibilityState());
  }

  void login() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      emit(AuthErrorState('Please fill in all fields'));
      return;
    }
    emit(AuthLoadingState());

    _auth
        .signInWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    )
        .then((value) {
      clearControllers();
      emit(AuthSuccessState());
    }).catchError((error) {
      print('Login error: $error');
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'user-not-found':
            emit(AuthErrorState('No user found for that email.'));
          case 'wrong-password':
            emit(AuthErrorState('Wrong password provided for that user.'));
          case 'invalid-email':
            emit(AuthErrorState('The email address is not valid.'));
          case 'user-disabled':
            emit(AuthErrorState('The user has been disabled.'));
          case 'too-many-requests':
            emit(AuthErrorState('Too many requests. Please try again later.'));
          case 'operation-not-allowed':
            emit(AuthErrorState('Email/password accounts are not enabled.'));
          case 'network-request-failed':
            emit(AuthErrorState(
                'Network request failed. Please check your connection.'));
          case 'weak-password':
            emit(AuthErrorState('The password is too weak.'));
          case 'email-already-in-use':
            emit(AuthErrorState(
                'The email address is already in use by another account.'));
          case 'invalid-credential':
            emit(AuthErrorState('The credential is invalid or has expired.'));
          case 'requires-recent-login':
            emit(AuthErrorState(
                'This operation requires recent authentication. Please log in again.'));

          default:
            emit(AuthErrorState('An unknown error occurred.'));
        }
      } else {
        emit(AuthErrorState('An error occurred: ${error.toString()}'));
      }
    });
  }

  void register() {
    if (usernameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty) {
      print('Please fill in all fields');
      emit(AuthErrorState('Please fill in all fields'));
      return;
    }
    emit(AuthLoadingState());

    _auth
        .createUserWithEmailAndPassword(
      email: emailCtrl.text,
      password: passwordCtrl.text,
    )
        .then((value) async {
      await _createUserData(value.user!.uid);
      clearControllers();
      emit(AuthSuccessState());
    }).catchError((error) {
      print('Registration error: $error');
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'email-already-in-use':
            emit(AuthErrorState('The email address is already in use.'));
          case 'invalid-email':
            emit(AuthErrorState('The email address is not valid.'));
          case 'operation-not-allowed':
            emit(AuthErrorState('Email/password accounts are not enabled.'));
          case 'weak-password':
            emit(AuthErrorState('The password is too weak.'));
          default:
            emit(AuthErrorState('An unknown error occurred.'));
        }
      } else {
        emit(AuthErrorState('An error occurred: ${error.toString()}'));
      }
    });
  }

  Future<void> _createUserData(String uid) async {
    await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection("users")
        .doc(uid)
        .set({
      "display_name": usernameCtrl.text,
      "email": emailCtrl.text,
      "created_at": DateTime.now().toUtc(),
      "photo_url":
          "https://images.unsplash.com/photo-1744039046459-411801eef170?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxN3x8fGVufDB8fHx8fA%3D%3D",
      "uid": uid,
    });
  }

  void logout() async {
    try {
      emit(LogoutLoadingState());
      await _auth.signOut();
      emit(LogoutSuccessState());
    } catch (error) {
      if (error is FirebaseAuthException) {
        emit(LogoutErrorState(
            error.message ?? 'An error occurred during logout.'));
      } else {
        emit(LogoutErrorState('An error occurred: ${error.toString()}'));
      }
    }
  }

  void clearControllers() {
    emailCtrl.clear();
    passwordCtrl.clear();
    usernameCtrl.clear();
  }
}

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String error;

  AuthErrorState(this.error);
}

class TogglePasswordVisibilityState extends AuthStates {}

class LogoutLoadingState extends AuthStates {}

class LogoutSuccessState extends AuthStates {}

class LogoutErrorState extends AuthStates {
  final String error;

  LogoutErrorState(this.error);
}
