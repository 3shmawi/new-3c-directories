import 'package:flutter/material.dart';
import 'package:new_3c/controller/users_ctrl.dart';
import 'package:new_3c/core/extension.dart';
import 'package:new_3c/models/user.dart';
import 'package:new_3c/screens/layout/messages/message_details_page.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: UsersCtrl().fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: SelectableText("Error: ${snapshot.error}"));
          }
          final users = snapshot.data;
          if (users == null || users.isEmpty) {
            return Center(child: Text("No users found"));
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            itemBuilder: (context, index) {
              return Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.cyan,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(users[index].photoURL),
                  ),
                  title: Text(users[index].displayName),
                  subtitle: Text(
                    users[index].email,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    context.navigateTo(MessageDetailsPage(
                      receiver: users[index],
                    ));
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            itemCount: users.length,
          );
        },
      ),
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
            radius: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                user.email,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
