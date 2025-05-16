import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/screens/layout/view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = AuthCtrl.get(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Welcome back",
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 30),
        TextFormField(
          controller: ctrl.userIdCtrl,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.profile_circled),
            hintText: "User Id",
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
          onPressed: () {
            context.pushAndFinish(LayoutView());
          },
          child: Text("Login"),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?"),
            TextButton(
              onPressed: ctrl.changeAuthPage,
              child: Text("create one!"),
            )
          ],
        )
      ],
    );
  }
}
