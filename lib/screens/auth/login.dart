import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/core/extension.dart';
import 'package:new_3c/screens/auth/register.dart';
import 'package:new_3c/screens/layout/layout_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCtrl, AuthStates>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          context.showSnackBar(state.error, backgroundColor: Colors.red);
        } else if (state is AuthSuccessState) {
          context.showSnackBar("Login Successful",
              backgroundColor: Colors.green);
          context.replaceWith(const LayoutScreen());
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
                            icon: Icon(ctrl.isPassword
                                ? Icons.visibility
                                : Icons.visibility_off))),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: state is AuthLoadingState ? null : ctrl.login,
                    child: Text("Login"),
                  ),
                  if (state is AuthLoadingState)
                    LinearProgressIndicator(
                      color: Colors.cyan,
                      backgroundColor: Colors.cyan.withOpacity(0.2),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () =>
                            context.replaceWith(const RegisterScreen()),
                        child: Text("Register"),
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
