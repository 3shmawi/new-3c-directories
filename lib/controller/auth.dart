import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/toast.dart';
import 'package:new_3c/models/user.dart';

// Define Authentication States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  // TextEditingControllers for the forms
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Toggle for password visibility
  bool isPasswordHidden = true;

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    // Emit a state to trigger UI rebuild.
    emit(AuthInitial());
  }

  String selectedGender = "Male";

  void setGender(String gender) {
    selectedGender = gender;
    // Emit a state to trigger UI rebuild.
    emit(AuthInitial());
  }

  void login() {
    final email = emailController.text;
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ToastHandler.showInfo("Email and password cannot be empty");
      emit(AuthError("Email and password cannot be empty"));
      return;
    }
    emit(AuthLoading());
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((response) {
      ToastHandler.showSuccess("You logged in successfully");
      emit(AuthAuthenticated());
    }).catchError((error) {
      ToastHandler.showError("Invalid credentials, $error");
      emit(AuthError("Invalid credentials"));
    });
  }

  void register() {
    final username = usernameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ToastHandler.showInfo("All fields are required");
      emit(AuthError("All fields are required"));
      return;
    }
    if (password != confirmPassword) {
      ToastHandler.showError("Passwords do not match");
      emit(AuthError("Passwords do not match"));
      return;
    }
    emit(AuthLoading());

    if (email.contains("@")) {
      _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((response) async {
        await _createUser(response.user?.uid ?? "guest");
        ToastHandler.showSuccess("You registered successfully");
        emit(AuthAuthenticated());
      }).catchError((error) {
        ToastHandler.showError("Invalid credentials, $error");
        emit(AuthError("credentials do not match"));
      });
    } else {
      ToastHandler.showError("Invalid email address");
      emit(AuthError("Invalid email address"));
    }
  }

  Future<void> _createUser(String id) async {
    final newUser = UserModel(
      id: id,
      name: usernameController.text,
      email: emailController.text,
      avatar: selectedGender == "Male"
          ? "https://i.pinimg.com/474x/6e/59/95/6e599501252c23bcf02658617b29c894.jpg"
          : "https://i.pinimg.com/474x/8c/6d/db/8c6ddb5fe6600fcc4b183cb2ee228eb7.jpg",
      isActive: true,
      isMale: selectedGender == "Male",
    );

    await _database
        .collection("AMRO")
        .doc("#")
        .collection("users")
        .doc(id)
        .set(newUser.toJson());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
