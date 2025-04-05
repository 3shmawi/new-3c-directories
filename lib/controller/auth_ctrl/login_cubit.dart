import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  final _auth = FirebaseAuth.instance;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }

  void login() async {
    final email = emailCtrl.text;
    final password = passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      emit(LoginErrorState('Please fill all fields'));
      return;
    }
    emit(LoginLoadingState());

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (error) {
      emit(LoginErrorState("Failed to login\n${error.message ?? error}"));
    }
  }

  @override
  Future<void> close() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    return super.close();
  }
}

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ChangePasswordVisibilityState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}
