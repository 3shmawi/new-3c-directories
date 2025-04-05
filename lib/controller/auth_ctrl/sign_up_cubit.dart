import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/user.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitState());

  static SignUpCubit get(context) => BlocProvider.of(context);
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  String gender = "Male";

  void setGender(Set<String> genderList) {
    gender = genderList.first;
    emit(SetGenderState());
  }

  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(ChangePasswordVisibilityState());
  }

  void signUp() async {
    final name = nameCtrl.text;
    final email = emailCtrl.text;
    final phone = emailCtrl.text;
    final password = passwordCtrl.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      emit(SignUpErrorState("Please fill all fields"));
      return;
    }
    emit(SignUpLoadingState());

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        emit(SignUpErrorState("Con not create user\n$email, $name"));
        return;
      }
      final uid = userCredential.user!.uid;
      await _createUserAtDatabase(uid);
      emit(SignUpSuccessState());
    } on FirebaseAuthException catch (error) {
      emit(SignUpErrorState("Failed to register\n${error.message ?? error}"));
    }
  }

  Future<void> _createUserAtDatabase(String uid) async {
    try {
      final name = nameCtrl.text;
      final email = emailCtrl.text;
      final phone = phoneCtrl.text;

      final newUser = UserModel(
        id: uid,
        name: name,
        email: email,
        phone: phone,
        bio: "New account",
        imgUrl: gender == "Male"
            ? "https://i.pinimg.com/474x/6e/59/95/6e599501252c23bcf02658617b29c894.jpg"
            : "https://i.pinimg.com/474x/8c/6d/db/8c6ddb5fe6600fcc4b183cb2ee228eb7.jpg",
        isOnline: true,
        isMale: gender == "Male",
      );

      await _database
          .collection("ISLAM")
          .doc("#")
          .collection("users")
          .doc(uid)
          .set(newUser.toJson());
    } on FirebaseException catch (error) {
      emit(SignUpErrorState(
          "Can't create user document at database\n${error.toString()}"));
      return;
    }
  }

  @override
  Future<void> close() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    phoneCtrl.dispose();
    nameCtrl.dispose();
    return super.close();
  }
}

abstract class SignUpStates {}

class SignUpInitState extends SignUpStates {}

class SetGenderState extends SignUpStates {}

class ChangePasswordVisibilityState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {}

class SignUpSuccessState extends SignUpStates {}

class SignUpErrorState extends SignUpStates {
  final String error;

  SignUpErrorState(this.error);
}
