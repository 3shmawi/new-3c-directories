import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/config.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/app/toast.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/screens/auth/login/login_view.dart';
import 'package:new_3c/screens/auth/register/register_view.dart';
import 'package:new_3c/screens/layout/view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCtrl(),
      child: BlocConsumer<AuthCtrl, AuthStates>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            AppToast.showError(state.error);
          } else if (state is AuthSuccessState) {
            AppToast.showSuccess("You have logged in successfully");
            context.pushReplacement(LayoutView());
          }
        },
        builder: (context, state) {
          final ctrl = AuthCtrl.get(context);
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 20,
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage(AppConfig.logo),
                        ),
                        AnimatedCrossFade(
                          firstChild: LoginView(),
                          secondChild: RegisterView(),
                          crossFadeState: ctrl.isLoginPage
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: Duration(
                            milliseconds: 500,
                          ),
                        ),
                        if (state is AuthLoadingState)
                          const Center(
                            child: LinearProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
