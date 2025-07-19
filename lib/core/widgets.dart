import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/core/extension.dart';

import '../screens/auth/login.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCtrl(),
      child: Builder(builder: (context) {
        return BlocConsumer<AuthCtrl, AuthStates>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              context.showSnackBar("Logout Successful",
                  backgroundColor: Colors.green);
              context.replaceWith(const LoginScreen());
            } else if (state is LogoutErrorState) {
              context.showSnackBar(state.error, backgroundColor: Colors.red);
            }
          },
          builder: (context, state) {
            return OutlinedButton.icon(
              onPressed: state is LogoutLoadingState
                  ? null
                  : context.read<AuthCtrl>().logout,
              icon: state is LogoutLoadingState
                  ? SizedBox(
                      width: 20, height: 20, child: CircularProgressIndicator())
                  : Icon(Icons.logout),
              label: Text("LOGOUT"),
            );
          },
        );
      }),
    );
  }
}
