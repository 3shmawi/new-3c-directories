import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  final _auth = FirebaseAuth.instance;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void login() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      print('Please fill in all fields');
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
      emit(AuthErrorState(error.toString()));
    });
  }

  void register() {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
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
        .then((value) {
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

  void logout() {}
}

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String error;

  AuthErrorState(this.error);
}
