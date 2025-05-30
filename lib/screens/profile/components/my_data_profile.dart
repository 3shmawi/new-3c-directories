import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/auth_ctrl.dart';

class MyProfileData extends StatelessWidget {
  const MyProfileData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCtrl, AuthStates>(
      listener: (context, state) {},
      buildWhen: (_, current) =>
          current is AuthLoadingState ||
          current is AuthSuccessState ||
          current is AuthErrorState,
      listenWhen: (_, current) =>
          current is AuthLoadingState ||
          current is AuthSuccessState ||
          current is AuthErrorState,
      builder: (context, state) {
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;

        if (state is AuthLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AuthErrorState) {
          return Center(
            child: Text(
              state.error,
              style: textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }
        final user = AuthCtrl.get(context).user;
        if (user == null) {
          return Center(
            child: Text(
              'No user data available',
              style: textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }
        return Column(
          spacing: 10,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(user.avatar),
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor,
                      width: 3,
                    ),
                  ),
                ),
                Text(
                  user.name,
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x10000000),
                    offset: Offset(
                      0,
                      2,
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 12,
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: theme.primaryColor,
                            size: 24,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: textTheme.labelMedium,
                                ),
                                Text(user.email, style: textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 12,
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              color: theme.primaryColor,
                              size: 24,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Phone', style: textTheme.labelMedium),
                                  Text(user.phone, style: textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ]),
                    ]),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x10000000),
                    offset: Offset(
                      0,
                      2,
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text('About Me', style: textTheme.titleMedium),
                    Text(
                      user.bio,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
