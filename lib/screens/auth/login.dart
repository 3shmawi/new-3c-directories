import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/screens/auth/register.dart';

import '../../controller/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthAuthenticated) {}
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: authCubit.formKey,
            child: ListView(
              children: [
                // Email Field
                TextFormField(
                  controller: authCubit.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter email'
                      : null,
                ),
                const SizedBox(height: 12),
                // Password Field with toggle for visibility
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return TextFormField(
                      controller: authCubit.passwordController,
                      obscureText: authCubit.isPasswordHidden,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(authCubit.isPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => authCubit.togglePasswordVisibility(),
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter password'
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (authCubit.formKey.currentState!.validate()) {
                          authCubit.login();
                        }
                      },
                      child: const Text('Login'),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    context.pushReplacementCurrent(const RegisterPage());
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
