import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/screens/articales/components/item.dart';
import 'package:new_3c/screens/profile/user_data/edit_user_data.dart';

import 'components/user_item_view.dart';

class UserDataView extends StatelessWidget {
  const UserDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCtrl, AuthStates>(
      builder: (context, state) {
        final user = context.read<AuthCtrl>().authorModel;
        if (user == null) {
          return EmptyData();
        }
        return Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.cyan,
              backgroundImage: NetworkImage(user.avatar),
            ),
            const SizedBox(height: 10),
            Text(
              "«${user.bio}»",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Merienda",
              ),
            ),
            const SizedBox(height: 10),
            UserDataItem(
              onTap: () => context.navigateTo(EditUserDataView(user)),
              title: user.name,
              icon: CupertinoIcons.profile_circled,
            ),
            const SizedBox(height: 10),
            UserDataItem(
              onTap: () => context.navigateTo(EditUserDataView(user)),
              title: user.email,
              icon: CupertinoIcons.mail,
            ),
            const SizedBox(height: 10),
            UserDataItem(
              onTap: () => context.navigateTo(EditUserDataView(user)),
              title: user.phone,
              icon: CupertinoIcons.phone,
            ),
          ],
        );
      },
    );
  }
}
