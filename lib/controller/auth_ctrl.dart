import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  static AuthCtrl get(context) => BlocProvider.of<AuthCtrl>(context);

  final userNameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void login() {
    final username = userNameCtrl.text;
    final password = passwordCtrl.text;
    if (username.isEmpty || password.isEmpty) {
      emit(AuthErrorState("Username and password cannot be empty"));
      return;
    }

    emit(AuthLoadingState());
    //todo call data form api (dio)
    // Implement login logic here
    emit(AuthSuccessState());
  }

  void register(String username, String password) {
    // Implement registration logic here
    emit(AuthSuccessState());
  }

  void logout() {
    // Implement logout logic here
    emit(AuthLogoutSuccessState());
  }
}

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String message;

  AuthErrorState(this.message);
}

class AuthLogoutSuccessState extends AuthStates {}
