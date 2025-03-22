import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/auth/sign_up.dart';

import '../home/view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isPassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 25,
                      color: Colors.cyan,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailCtrl,
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
                  controller: passwordCtrl,
                  obscureText: isPassword,
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
                      onPressed: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      },
                      icon: Icon(
                        isPassword ? Icons.visibility : Icons.visibility_off,
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
                      )),
                  onPressed: isLoading ? null : login,
                  child: const Text("LOGIN"),
                ),
                if (isLoading) LinearProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        context.pushReplacement(const SignUpScreen());
                      },
                      child: Text("SIGNUP"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    final email = emailCtrl.text;
    final password = passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      context.showError('Please fill all fields');
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      context.pushReplacement(const HomeScreen());
    } on FirebaseAuthException catch (error) {
      context.showError("Failed to login\n${error.message ?? error}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
