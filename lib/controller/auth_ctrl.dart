import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/toast.dart';
import 'package:new_3c/models/author.dart';
import 'package:new_3c/services/dio_helper.dart';
import 'package:new_3c/services/local_storage.dart';

class AuthCtrl extends Cubit<AuthStates> {
  AuthCtrl() : super(AuthInitialState());

  static AuthCtrl get(context) => BlocProvider.of(context);

  AuthorModel? authorModel;

  final userIdCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(AuthChangePasswordVisibilityState());
  }

  final _http = HttpUtil();

  void createUser() {
    if (isCreateFieldsEmpty()) {
      AppToast.showError("Please fill all fields");
      return;
    }
    emit(AuthLoadingState());
    final newAuthor = AuthorModel(
      id: "",
      name: nameCtrl.text,
      avatar:
          "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740",
      email: emailCtrl.text,
      bio: "New Account",
      phone: phoneCtrl.text,
      password: passwordCtrl.text,
    );
    _http.post("users", data: newAuthor.toJson()).then((value) {
      authorModel = AuthorModel.fromJson(value);
      AppToast.showSuccess("User Created Successfully");
      CacheHelper.saveData(key: "authorId", value: authorModel!.id);
      clearFields();
      emit(AuthSuccessState());
    }).catchError((error) {
      AppToast.showError("Error: ${error.toString()}");
      emit(AuthErrorState());
    });
  }

  void login() {
    if (isLoginFieldsEmpty()) {
      AppToast.showError("Please fill all fields");
      return;
    }
    emit(AuthLoadingState());
    _http.get("users/${userIdCtrl.text}").then((value) {
      if (passwordCtrl.text == value['password']) {
        authorModel = AuthorModel.fromJson(value);
        AppToast.showSuccess("Login Successfully");
        CacheHelper.saveData(key: "authorId", value: authorModel!.id);

        clearFields();
        emit(AuthSuccessState());
      } else {
        AppToast.showError("Wrong Password");
        emit(AuthErrorState());
      }
    }).catchError((error) {
      AppToast.showError("Error: ${error.toString()}");
      emit(AuthErrorState());
    });
  }

  void getMyData() {
    final authorId = CacheHelper.getData(key: "authorId");
    if (authorId == null) {
      return;
    }
    emit(AuthLoadingState());
    _http.get("users/$authorId").then((value) {
      authorModel = AuthorModel.fromJson(value);
      emit(AuthSuccessState());
    }).catchError((error) {
      AppToast.showError("Error: ${error.toString()}");
      emit(AuthErrorState());
    });
  }

  void editMyUserData(AuthorModel authorModel) {
    emit(EditMyUserDataLoadingState());
    _http
        .put('users/${authorModel.id}', data: authorModel.toJson())
        .then((value) {
      this.authorModel = AuthorModel.fromJson(value);
      AppToast.showSuccess("User data updated successfully");
      emit(EditMyUserDataSuccessState());
    }).catchError((error) {
      AppToast.showError("Error: ${error.toString()}");
      emit(EditMyUserDataErrorState(error.toString()));
    });
  }

  void clearFields() {
    userIdCtrl.clear();
    nameCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    passwordCtrl.clear();
  }

  bool isCreateFieldsEmpty() {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isLoginFieldsEmpty() {
    if (userIdCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    authorModel = null;
    CacheHelper.removeData(key: "authorId");

    emit(AuthLogoutState());
  }
}

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthChangePasswordVisibilityState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthSuccessState extends AuthStates {}

class AuthErrorState extends AuthStates {}

class AuthLogoutState extends AuthStates {}

class EditMyUserDataLoadingState extends AuthStates {}

class EditMyUserDataSuccessState extends AuthStates {}

class EditMyUserDataErrorState extends AuthStates {
  final String error;

  EditMyUserDataErrorState(this.error);
}
