import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/screens/auth/register_view.dart';
import 'package:new_3c/screens/layout/view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                      controller: cubit.userIdCtrl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'User id',
                        prefixIcon: Icon(
                          Icons.person,
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
                      onPressed: state is AuthLoadingState ? null : cubit.login,
                      child: const Text("LOGIN"),
                    ),
                    if (state is AuthLoadingState) LinearProgressIndicator(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            cubit.clearFields();
                            context.navigateAndReplace(SignUpView());
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
    );
  }
}
