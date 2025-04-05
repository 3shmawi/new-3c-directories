import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:new_3c/controller/auth.dart';
import 'package:new_3c/controller/chat.dart';
import 'package:new_3c/models/user.dart';

import '../../models/message.dart';

class ChatsDetails extends StatelessWidget {
  const ChatsDetails(this.receiver, this.isNewChat, {super.key});

  final UserModel receiver;
  final bool isNewChat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(receiver.avatar),
          ),
          SizedBox(width: 10),
          Text(receiver.name),
        ],
      )),
      body: BlocBuilder<ChatCubit, ChatStates>(
        builder: (context, state) {
          final cubit = context.read<ChatCubit>();
          return Column(
            children: [
              Expanded(
                child: StreamBuilder<List<MessageModel>>(
                  stream: cubit.getMessages(receiver.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No messages yet"));
                    }

                    final messages = snapshot.data!;

                    return ListView.builder(
                      reverse: false,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderRef.id ==
                            AuthCubit
                                .myId; // Check if the message is sent by the user

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  daysBetween(message.sendTime),
                                  // Display HH:MM time format
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: cubit.messageCtrl,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        cubit.sendMessage(receiver.id, isNewChat);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String daysBetween(String time) {
    final date = DateTime.parse(time);
    if (DateTime.now().difference(date).inDays <= 5) {
      if ((DateTime.now().difference(date).inHours / 24).round() == 0) {
        if (DateTime.now().difference(date).inHours == 0) {
          if (DateTime.now().difference(date).inMinutes == 0) {
            return 'now';
          } else {
            return '${DateTime.now().difference(date).inMinutes.toString()}m';
          }
        } else {
          return '${DateTime.now().difference(date).inHours.toString()}h';
        }
      } else {
        return (' ${(DateTime.now().difference(date).inHours / 24).round().toString()}d');
      }
    } else {
      return _formatDate(date);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }
}
