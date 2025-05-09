import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  static AuthCtrl get(context) => BlocProvider.of(context);

  final userIdCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  bool isLoginPage = true;

  void changeAuthPage() {
    isLoginPage = !isLoginPage;
    clearControllers();
    emit(ChangeAuthPageState());
  }

  bool showPassword = false;

  void togglePasswordVisibility() {
    showPassword = !showPassword;
    emit(TogglePasswordVisibilityState());
  }

  void clearControllers() {
    userIdCtrl.clear();
    passwordCtrl.clear();
    nameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
  }
}

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class TogglePasswordVisibilityState extends AuthStates {}

class ChangeAuthPageState extends AuthStates {}
