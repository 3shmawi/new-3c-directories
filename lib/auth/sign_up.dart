import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/auth/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  final nameCtrl = TextEditingController();
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
                  controller: nameCtrl,
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
                  controller: emailCtrl,
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
                  controller: passwordCtrl,
                  obscureText: isPassword,
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
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onPressed: isLoading ? null : signUp,
                  child: const Text("REGISTER"),
                ),
                if (isLoading) LinearProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        context.pushReplacement(const LoginScreen());
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
  }

  void signUp() async {
    final name = nameCtrl.text;
    final email = emailCtrl.text;
    final password = passwordCtrl.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      context.showError("Please fill all fields");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _database
          .collection("ISLAM")
          .doc("#")
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "id": userCredential.user!.uid,
        "name": name,
        "email": email,
      });
      context.pushReplacement(const LoginScreen());
    } on FirebaseAuthException catch (error) {
      context.showError("Failed to register\n${error.message ?? error}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}
