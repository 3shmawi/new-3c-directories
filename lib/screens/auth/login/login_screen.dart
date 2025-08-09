import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/screens/auth/widgets/header.dart';

import '../forget_password/fogot_password_screen.dart';
import '../widgets/auth_button.dart';
import '../widgets/input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget("Welcome\nBack!"),
              SizedBox(height: 36),
              InputFieldWidget(
                hintText: "Username or Email",
                prefixIcon: CupertinoIcons.profile_circled,
              ),
              SizedBox(height: 30),
              InputFieldWidget(
                isPassword: true,
                hintText: "Password",
                prefixIcon: CupertinoIcons.lock,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.red),
                      ),
                    )),
              ),
              SizedBox(height: 52),
              AuthButtonWidget(
                label: "Login",
                onPressed: () {
                  // Handle login action
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
