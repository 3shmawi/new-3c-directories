import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/auth_ctrl/sign_up_cubit.dart';
import 'package:new_3c/screens/auth/login.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (context, state) {
          if (state is SignUpSuccessState) {
            context.showSuccess("Create account successfully");
            context.pushReplacement(LoginScreen());
          } else if (state is SignUpErrorState) {
            context.showError(state.error);
          }
        },
        builder: (context, state) {
          final cubit = SignUpCubit.get(context);
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Register Screen",
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Create an account",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SegmentedButton(
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.transparent,
                          selectedBackgroundColor: Colors.cyan,
                        ),
                        onSelectionChanged: cubit.setGender,
                        segments: [
                          ButtonSegment(
                            value: "Male",
                            label: Text("Male"),
                            icon: Icon(Icons.male),
                          ),
                          ButtonSegment(
                            value: "Female",
                            label: Text("Female"),
                            icon: Icon(Icons.female),
                          ),
                        ],
                        selected: {cubit.gender},
                      ),
                      TextFormField(
                        controller: cubit.nameCtrl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          labelText: "Full Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: cubit.emailCtrl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          labelText: "Email Address",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: cubit.phoneCtrl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          labelText: "Phone number",
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: cubit.passwordCtrl,
                        obscureText: cubit.isPassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.cyan,
                          ),
                          suffixIcon: IconButton(
                            onPressed: cubit.changePasswordVisibility,
                            icon: Icon(
                              cubit.isPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 45),
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed:
                            state is SignUpLoadingState ? null : cubit.signUp,
                        child: const Text("REGISTER"),
                      ),
                      if (state is SignUpLoadingState)
                        LinearProgressIndicator(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              context.pushReplacement(const LoginScreen());
                            },
                            child: const Text("Login"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
