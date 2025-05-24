import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/auth_ctrl/logout_cubit.dart';
import 'package:new_3c/controller/layout_ctrl/layout_cubit.dart';

import '../../../controller/settings_ctrl/settings_cubit.dart';

class SettingsDataView extends StatelessWidget {
  const SettingsDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider()),
            const SizedBox(width: 3),
            Icon(
              CupertinoIcons.settings_solid,
              color: Colors.cyan,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              "Settings",
              style: TextStyle(
                fontFamily: "Merienda",
                fontSize: 20,
                color: Colors.cyan,
              ),
            ),
            Expanded(flex: 10, child: Divider()),
          ],
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
        Card(
          child: ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          LayoutCubit().changeLayout(0);
                          LogoutCubit().logout(context);
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
            title: Text("Logout"),
            subtitle: Text("Logout from your account"),
            leading: Icon(
              Icons.logout_outlined,
              color: Colors.cyan,
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: Colors.cyan,
            ),
          ),
        )
      ],
    );
  }
}
