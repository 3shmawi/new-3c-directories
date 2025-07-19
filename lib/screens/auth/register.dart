import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/core/extension.dart';
import 'package:new_3c/screens/auth/login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCtrl, AuthStates>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          context.showSnackBar(state.error, backgroundColor: Colors.red);
        } else if (state is AuthSuccessState) {
          context.showSnackBar("Registration Successful",
              backgroundColor: Colors.green);
          context.replaceWith(const LoginScreen());
        }
      },
      builder: (context, state) {
        final ctrl = context.read<AuthCtrl>();
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: ctrl.usernameCtrl,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: ctrl.emailCtrl,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: "Email Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: ctrl.isPassword,
                    controller: ctrl.passwordCtrl,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: IconButton(
                            onPressed: ctrl.togglePasswordVisibility,
                            icon: Icon(Icons.visibility))),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: state is AuthLoadingState ? null : ctrl.register,
                    child: Text("Register"),
                  ),
                  if (state is AuthLoadingState)
                    LinearProgressIndicator(
                      color: Colors.cyan,
                      backgroundColor: Colors.cyan.withValues(alpha: 0.2),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () =>
                            context.replaceWith(const LoginScreen()),
                        child: Text("Login"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
