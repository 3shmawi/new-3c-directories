import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/user_ctrl/user_cubit.dart';
import 'package:new_3c/screens/settings/user_data/widgets/data_item.dart';

class UserDataView extends StatelessWidget {
  const UserDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserStates>(
      buildWhen: (_, current) =>
          current is GetMyUserDataLoadingState ||
          current is GetMyUserDataSuccessState ||
          current is GetMyUserDataErrorState,
      builder: (context, state) {
        final cubit = userCubit(context);
        if (state is GetMyUserDataLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is GetMyUserDataSuccessState) {
          final user = cubit.myUserData!;
          return Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.cyan,
                backgroundImage: NetworkImage(user.imgUrl),
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
                title: user.name,
                icon: CupertinoIcons.profile_circled,
              ),
              const SizedBox(height: 10),
              UserDataItem(
                title: user.email,
                icon: CupertinoIcons.mail,
              ),
              const SizedBox(height: 10),
              UserDataItem(
                title: user.phone,
                icon: CupertinoIcons.phone,
              ),
            ],
          );
        }
        if (state is GetMyUserDataErrorState) {
          return Center(
            child: Text(
              state.error,
              style: const TextStyle(
                fontFamily: "Merienda",
                fontSize: 20,
                color: Colors.red,
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
