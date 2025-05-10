import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/screens/auth/login_view.dart';

import '../layout/view.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCtrl, AuthStates>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          context.navigateAndReplace(LayoutView());
        }
      },
      builder: (context, state) {
        final cubit = AuthCtrl.get(context);
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
                          state is AuthLoadingState ? null : cubit.createUser,
                      child: const Text("REGISTER"),
                    ),
                    if (state is AuthLoadingState) LinearProgressIndicator(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            cubit.clearFields();
                            context.navigateAndReplace(const LoginView());
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
    );
  }
}
