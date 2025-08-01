import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/core/app_regex.dart';
import 'package:new_3c/models/user.dart';
import 'package:new_3c/services/dio_helper.dart';
import 'package:new_3c/services/local_storage.dart';

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
          final box = await HiveService().openBox("myUserData");
          box.put("myData", username);
          box.put("myId", this.user?.id);

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
      if (!AppRegex.validateEmail(email)) {
        emit(AuthErrorState("Invalid email format"));
        return;
      }
      if (!AppRegex.validatePhone(phone)) {
        emit(AuthErrorState("Invalid phone number format"));
        return;
      }
      final usersResponse = await _http.get("users");
      for (final user in usersResponse) {
        if (user['email'] == email || user['phone'] == phone) {
          emit(AuthErrorState("User with this email or phone already exists"));
          return;
        }
      }
      final newUser = UserModel(
        name: username,
        password: password,
        email: email,
        phone: phone,
      );
      await _http.post(
        "users",
        data: newUser.toJson(),
      );
      clearControllers();
      emit(AuthSuccessState());
    } catch (error) {
      emit(AuthErrorState("Registration failed: $error"));
    }
  }

  void logout() async {
    final box = await HiveService().openBox("myUserData");
    box.delete("myData");

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
