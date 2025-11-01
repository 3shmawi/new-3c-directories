import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: AuthIntro(),
    ),
  );
}

class AuthIntro extends StatefulWidget {
  const AuthIntro({super.key});

  @override
  State<AuthIntro> createState() => _AuthIntroState();
}

class _AuthIntroState extends State<AuthIntro> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(hintText: "Email address"),
            ),
            TextField(
              controller: passCtrl,
              decoration: InputDecoration(hintText: "Password"),
            ),
            ElevatedButton(
              onPressed: () async {
                log("clicked");
                final auth = FirebaseAuth.instance;
                try {
                  final response = await auth.signInWithEmailAndPassword(
                    email: emailCtrl.text,
                    password: passCtrl.text,
                  );

                  log(response.user?.uid ?? "NOt found");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ("Sign in successfully.."),
                      ),
                    ),
                  );
                } catch (error) {
                  try {
                    final response = await auth.createUserWithEmailAndPassword(
                      email: emailCtrl.text,
                      password: passCtrl.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ("Sign up successfully.."),
                        ),
                      ),
                    );
                    log(response.user?.uid ?? "NOt found");
                  } catch (error2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ("$error"),
                        ),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ("$error2"),
                        ),
                      ),
                    );
                    log(error.toString());
                    log(error2.toString());
                  }
                }
              },
              child: Text(
                "Press",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
