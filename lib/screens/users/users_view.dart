import 'package:flutter/material.dart';
import 'package:new_3c/controller/user_ctrl/user_cubit.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = userCubit(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: cubit.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  fontFamily: "Merienda",
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.imgUrl),
                    ),
                    //todo is online steam
                    trailing: StreamBuilder<bool>(
                        stream: cubit.isOnline(user.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.grey[300],
                            );
                          }
                          final isOnline = snapshot.data;
                          if (isOnline == null) {
                            return CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.grey[300],
                            );
                          }
                          return CircleAvatar(
                            radius: 5,
                            backgroundColor:
                                isOnline ? Colors.green[500] : Colors.grey[300],
                          );
                        }),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No users found"));
        },
      ),
    );
  }
}
