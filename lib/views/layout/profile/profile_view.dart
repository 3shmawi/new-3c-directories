import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/theme_ctrl.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Profile"),
          ElevatedButton(
              onPressed: context.read<ThemeCtrl>().toggleTheme,
              child: Text("toggleTheme"))
        ],
      ),
    );
  }
}
