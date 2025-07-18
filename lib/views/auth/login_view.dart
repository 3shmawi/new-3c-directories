import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/core/extensions.dart';
import 'package:new_3c/views/auth/register_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCtrl, AuthStates>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          context.showSnackBar(state.message, backgroundColor: Colors.red);
        } else if (state is AuthSuccessState) {
          context.showSnackBar('Login successful');
          //todo Navigate to home page or dashboard
        }
      },
      builder: (context, state) {
        final ctrl = AuthCtrl.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: ctrl.userNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Userid',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: ctrl.passwordCtrl,
                    obscureText: ctrl.isPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: ctrl.togglePasswordVisibility,
                        icon: Icon(
                          ctrl.isPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: state is AuthLoadingState ? null : ctrl.login,
                    child: const Text('Login'),
                  ),
                  if (state is AuthLoadingState)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const LinearProgressIndicator(),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => context.push(RegisterView()),
                        child: const Text('Register'),
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
