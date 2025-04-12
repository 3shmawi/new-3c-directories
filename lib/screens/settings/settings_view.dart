import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/settings_ctrl/settings_cubit.dart';
import 'package:new_3c/screens/auth/login.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Settings View',
              style: TextStyle(fontSize: 50),
            ),
            Card(
              child: BlocBuilder<SettingsCubit, SettingsStates>(
                buildWhen: (_, current) => current is ChangeThemeState,
                builder: (context, state) {
                  final cubit = SettingsCubit.get(context);
                  return SwitchListTile(
                    value: cubit.isDark,
                    onChanged: (_) => cubit.changeTheme(),
                    title: Text('Dark Mode'),
                    subtitle: Text('Manage your theme here'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final isLoggedOut = await logout();
                if (isLoggedOut) {
                  context.pushAndRemoveUntil(LoginScreen());
                }
              },
              child: Text("LOGOUT"),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
