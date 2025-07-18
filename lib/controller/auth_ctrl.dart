import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/user.dart';
import 'package:new_3c/services/dio_helper.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  static AuthCtrl get(context) => BlocProvider.of<AuthCtrl>(context);

  final userNameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  bool isPassword = true;

  void togglePasswordVisibility() {
    isPassword = !isPassword;
    emit(PasswordVisibilityState());
  }

  final _http = HttpUtil();
  UserModel? user;

  void login() async {
    final username = userNameCtrl.text;
    final password = passwordCtrl.text;
    if (username.isEmpty || password.isEmpty) {
      emit(AuthErrorState("Username and password cannot be empty"));
      return;
    }

    emit(AuthLoadingState());
    try {
      final users = await _http.get("users");
      if (users == null || users.isEmpty) {
        emit(AuthErrorState("Failed to fetch user data"));
        return;
      }
      for (final user in users) {
        if ((user['email'] == username || user['phone'] == username) &&
            user['password'] == password) {
          this.user = UserModel.fromJson(user);
          clearControllers();

          emit(AuthSuccessState());
          return;
        }
      }
      emit(AuthErrorState("Invalid username or password"));
    } catch (error) {
      emit(AuthErrorState("Login failed: $error"));
    }
  }

  void register() async {
    //todo validate that users does not already exist by email or phone
    final username = userNameCtrl.text;
    final password = passwordCtrl.text;
    final email = emailCtrl.text;
    final phone = phoneCtrl.text;

    if (username.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        phone.isEmpty) {
      emit(AuthErrorState("All fields are required"));
      return;
    }
    emit(AuthLoadingState());

    try {
      final newUser = UserModel(
        name: username,
        password: password,
        email: email,
        phone: phone,
      );
      final response = await _http.post(
        "users",
        data: newUser.toJson(),
      );
      user = UserModel.fromJson(response);
      clearControllers();
      emit(AuthSuccessState());
    } catch (error) {
      emit(AuthErrorState("Registration failed: $error"));
    }
  }

  void logout() {
    // Implement logout logic here
    emit(AuthLogoutSuccessState());
  }

  void clearControllers() {
    userNameCtrl.clear();
    passwordCtrl.clear();
    phoneCtrl.clear();
    emailCtrl.clear();
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

class PasswordVisibilityState extends AuthStates {}
