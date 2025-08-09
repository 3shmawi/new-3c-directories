import 'package:flutter/material.dart';
import 'package:new_3c/controller/chat_ctrl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = ChatCtrl();
    return SafeArea(
      child: StreamBuilder(
        stream: chatCtrl.getMyChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: SelectableText("Error: ${snapshot.error}"));
          }
          final chats = snapshot.data;
          if (chats == null || chats.isEmpty) {
            return Center(child: Text("No chats found"));
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            itemBuilder: (context, index) {
              final isGroup = chats[index].participants.length > 2;
              if (isGroup) {
                return chatItem(
                  photUrl: chats[index].photoURL!,
                  title: chats[index].displayName!,
                  subtitle: chats[index].lastMessage,
                );
              }
              return FutureBuilder(
                  future: chatCtrl.getUserById(chats[index].receiverId!),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final user = snapshot.data!;
                    return chatItem(
                      photUrl: user.photoURL,
                      title: user.displayName,
                      subtitle: chats[index].lastMessage,
                    );
                  });
            },
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            itemCount: chats.length,
          );
        },
      ),
    );
  }

  Widget chatItem(
          {required String photUrl,
          required String title,
          required String subtitle}) =>
      Container(
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
            backgroundImage: NetworkImage(photUrl),
          ),
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          onTap: () {
// Handle user tap if needed
          },
        ),
      );
}
