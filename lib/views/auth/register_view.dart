import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/core/extensions.dart';
import 'package:new_3c/views/auth/login_view.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCtrl, AuthStates>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          context.showSnackBar(state.message, backgroundColor: Colors.red);
        } else if (state is AuthSuccessState) {
          context.showSnackBar('Registration successful');
          context.pushReplacement(LoginView());
        }
      },
      builder: (context, state) {
        final ctrl = AuthCtrl.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
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
                      labelText: 'username',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: ctrl.emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: ctrl.phoneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    obscureText: ctrl.isPassword,
                    controller: ctrl.passwordCtrl,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: ctrl.togglePasswordVisibility,
                        icon: Icon(ctrl.isPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: state is AuthLoadingState ? null : ctrl.register,
                    child: const Text('Register'),
                  ),
                  if (state is AuthLoadingState)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const LinearProgressIndicator(),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      TextButton(
                        onPressed: () => context.pushReplacement(LoginView()),
                        child: const Text('Login'),
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
