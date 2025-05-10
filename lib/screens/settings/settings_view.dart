import 'package:flutter/material.dart';
import 'package:new_3c/screens/settings/settings_data/settings_data_view.dart';
import 'package:new_3c/screens/settings/user_data/user_data_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            UserDataView(),
            SettingsDataView(),
          ],
        ),
      ),
    );
  }
}
