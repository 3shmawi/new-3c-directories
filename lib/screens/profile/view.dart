import 'package:flutter/material.dart';

import 'settings/settings_view.dart';
import 'user_data/user_data_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              UserDataView(),
              SettingsDataView(),
            ],
          ),
        ),
      ),
    );
  }
}
