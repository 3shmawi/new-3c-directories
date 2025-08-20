import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/screens/auth/login/login_screen.dart';

import '../widgets/auth_button.dart';
import '../widgets/header.dart';
import '../widgets/input_field.dart';
import '../widgets/oauth2_button.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget("Create an\nAccount"),
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
              SizedBox(height: 30),
              InputFieldWidget(
                isPassword: true,
                hintText: "Confirm Password",
                prefixIcon: CupertinoIcons.lock,
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                      children: [
                        TextSpan(
                          text: "By clicking the ",
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // Handle Register click
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFF83758),
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: " button, you agree\nto the public offer",
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 38),
              AuthButtonWidget(
                label: "Create Account",
                onPressed: () {
                  // Handle login action
                },
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: Text(
                  " - Or Continue With - ",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Oauth2Button(
                    iconPath: "assets/icons/google.svg",
                    onPressed: () {
                      // Handle Twitter login
                    },
                  ),
                  Oauth2Button(
                    iconPath: "assets/icons/apple.svg",
                    onPressed: () {
                      // Handle Twitter login
                    },
                  ),
                  Oauth2Button(
                    iconPath: "assets/icons/facebook.svg",
                    onPressed: () {
                      // Handle Twitter login
                    },
                  ),
                ],
              ),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I Already Have an Account",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF575757),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      "login",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF83758),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
