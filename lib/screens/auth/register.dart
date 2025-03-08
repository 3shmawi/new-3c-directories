import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/screens/auth/login.dart';

import '../../controller/auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
                  controller: authCubit.usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  keyboardType: TextInputType.name,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter username'
                      : null,
                ),
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
                // Confirm Password Field
                TextFormField(
                  controller: authCubit.confirmPasswordController,
                  obscureText: authCubit.isPasswordHidden,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != authCubit.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                const GenderToggle(),
                const SizedBox(height: 20),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (authCubit.formKey.currentState!.validate()) {
                          authCubit.register();
                        }
                      },
                      child: const Text('Register'),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    context.pushReplacementCurrent(const LoginPage());
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GenderToggle extends StatelessWidget {
  const GenderToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final selectedGender = authCubit.selectedGender;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => authCubit.setGender("Male"),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedGender == "Male"
                        ? Colors.blue
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      "Male",
                      style: TextStyle(
                        color: selectedGender == "Male"
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => authCubit.setGender("Female"),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedGender == "Female"
                        ? Colors.pink
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      "Female",
                      style: TextStyle(
                        color: selectedGender == "Female"
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
