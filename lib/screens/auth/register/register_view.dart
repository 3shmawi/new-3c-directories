import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/controller/auth_ctrl.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = AuthCtrl.get(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Create new account",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: ctrl.nameCtrl,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.profile_circled),
            hintText: "Name",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: ctrl.emailCtrl,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.mail),
            hintText: "Email",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: ctrl.phoneCtrl,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.phone),
            hintText: "Phone",
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: ctrl.passwordCtrl,
          obscureText: ctrl.showPassword,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Icon(CupertinoIcons.padlock),
            suffixIcon: IconButton(
              onPressed: ctrl.togglePasswordVisibility,
              icon: Icon(
                ctrl.showPassword
                    ? CupertinoIcons.eye
                    : CupertinoIcons.eye_slash,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: ctrl.register,
          child: Text("Register"),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have an account?"),
            TextButton(onPressed: ctrl.changeAuthPage, child: Text("login!"))
          ],
        )
      ],
    );
  }
}
