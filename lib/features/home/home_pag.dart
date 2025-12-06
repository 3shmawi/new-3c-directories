import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/features/chat/chat.dart';
import 'package:new_3c/features/home/controller/home_page_ctrl.dart';

import '../auth/auth.dart';

class HomePag extends StatelessWidget {
  const HomePag({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Users",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],

        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return const AuthPage();
                },
              ), (_) => false);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.profile_circled,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: HomePageCtrl().getAllUsers(),
        builder: (context, snapshot) {
          //first state, connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //second error state
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          }

          //success but empty
          final users = snapshot.data;
          if (users == null || users.isEmpty) {
            return const Center(child: Text("No users yet"));
          }

          return ListView.separated(
            itemBuilder: (context, index) {
              final user = users[index];
              final imgUrl = user.profilePictureUrl;
              final name = user.name;
              final email = user.email;

              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          receiver: user,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage:
                        imgUrl == null ? null : NetworkImage(imgUrl),
                    child: imgUrl == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(name ?? "No Name..."),
                  subtitle: Text(
                    email ?? "",
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
            ),
            itemCount: users.length,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
        icon: const Icon(CupertinoIcons.globe),
        label: const Text("World Chat"),
      ),
    );
  }
}
