import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/auth_ctrl/login_cubit.dart';
import 'package:new_3c/controller/user_ctrl/user_cubit.dart';
import 'package:new_3c/screens/auth/sign_up.dart';
import 'package:new_3c/screens/layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            context.showSuccess("You have logged in successfully");
            userCubit(context).getMyUserData();
            userCubit(context).updateUserStatus(true);
            context.pushAndRemoveUntil(const LayoutScreen());
          } else if (state is LoginErrorState) {
            context.showError(state.error);
          }
        },
        builder: (context, state) {
          final cubit = LoginCubit.get(context);
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
                        child: const Text(
                          'Login Screen',
                          style: TextStyle(
                            fontFamily: "Merienda",
                            fontSize: 50,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Welcome back',
                          style: TextStyle(
                            fontFamily: "Merienda",
                            fontSize: 25,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: cubit.emailCtrl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: 'Email Address',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: cubit.passwordCtrl,
                        obscureText: cubit.isPassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelText: 'Password',
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
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 45),
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            state is LoginLoadingState ? null : cubit.login,
                        child: const Text("LOGIN"),
                      ),
                      if (state is LoginLoadingState) LinearProgressIndicator(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              context.pushReplacement(const SignUpScreen());
                            },
                            child: Text("Create one!"),
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
