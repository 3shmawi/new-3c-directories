import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/user.dart';
import 'package:new_3c/services/dio_helper.dart';
import 'package:new_3c/services/local_storage_helper.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  static AuthCtrl get(context) => BlocProvider.of(context);

  final _http = HttpUtil();

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

  UserModel? user;

  void login() {
    final userId = userIdCtrl.text;
    final password = passwordCtrl.text;
    if (userId.isEmpty || password.isEmpty) {
      emit(AuthErrorState("Please fill in all fields"));
      return;
    }
    emit(AuthLoadingState());
    _http.get("users/$userId").then((response) {
      final user = UserModel.fromJson(response);
      if (user.password == password) {
        CacheHelper.saveData(key: "myId", value: user.id);
        this.user = user;
        emit(AuthSuccessState());
      } else {
        emit(AuthErrorState("Invalid credentials"));
      }
    }).catchError((error) {
      emit(AuthErrorState("An error occurred: $error"));
    });
  }

  void register() {
    final name = nameCtrl.text;
    final email = emailCtrl.text;
    final phone = phoneCtrl.text;
    final password = passwordCtrl.text;
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      emit(AuthErrorState("Please fill in all fields"));
      return;
    }
    emit(AuthLoadingState());
    final user = UserModel(
      id: "",
      name: name,
      email: email,
      phone: phone,
      password: password,
      bio: "New Account",
      avatar:
          "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740",
    );
    _http.post("users", data: user.toJson()).then((response) {
      final newUser = UserModel.fromJson(response);
      CacheHelper.saveData(key: "myId", value: newUser.id);
      this.user = newUser;
      emit(AuthSuccessState());
    }).catchError((error) {
      emit(AuthErrorState("An error occurred: $error"));
    });
  }

  void logout() {
    CacheHelper.removeData(key: "myId");
    user = null;
  }

  void getMyData() {
    final myId = CacheHelper.getData(key: "myId");
    if (myId == null) {
      return;
    }
    emit(AuthLoadingState());
    _http.get("users/$myId").then((response) {
      final user = UserModel.fromJson(response);
      this.user = user;
      emit(AuthSuccessState());
    }).catchError((error) {
      emit(AuthErrorState("An error occurred: $error"));
    });
  }
}

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class TogglePasswordVisibilityState extends AuthStates {}

class ChangeAuthPageState extends AuthStates {}

//
class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String error;

  AuthErrorState(this.error);
}
