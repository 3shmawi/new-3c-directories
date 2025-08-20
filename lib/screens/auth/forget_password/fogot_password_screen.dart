import 'package:flutter/material.dart';
import 'package:new_3c/screens/auth/widgets/auth_button.dart';
import 'package:new_3c/screens/auth/widgets/header.dart';
import 'package:new_3c/screens/auth/widgets/input_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32,
            children: [
              HeaderWidget("Forgot\npassword?"),
              InputFieldWidget(
                prefixIcon: Icons.email,
                hintText: "Enter your email address",
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "* We will send you a message to set or reset your new password",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              AuthButtonWidget(
                label: "Submit",
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
