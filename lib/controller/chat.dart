import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/toast.dart';
import 'package:new_3c/controller/auth.dart';
import 'package:new_3c/models/chat.dart';
import 'package:new_3c/models/message.dart';
import 'package:new_3c/models/user.dart';

abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class GetUsersState extends ChatStates {}

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  final database = FirebaseFirestore.instance;
  final myId = AuthCubit.myId;
  final messageCtrl = TextEditingController();

//send message
  void sendMessage(String receiverId) async {
    final message = messageCtrl.text.trim();
    if (message.isEmpty) {
      ToastHandler.showInfo("Please enter a message");
      return;
    }

    if (myId == 'unauthorized') {
      ToastHandler.showError(
          "You are not authorized to send messages\nPlease login first");
      return;
    }
    final newId = DateTime.now().toIso8601String();
    final messageModel = MessageModel(
      id: newId,
      text: message,
      sendTime: newId,
      updatedTime: newId,
      senderRef:
          database.collection("AMRO").doc("#").collection("users").doc(myId),
      receiverRef: database
          .collection("AMRO")
          .doc("#")
          .collection("users")
          .doc(receiverId),
    );

    await database
        .collection("AMRO")
        .doc("#")
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .doc(messageModel.id)
        .set(messageModel.toJson());

    messageCtrl.clear();
    await database
        .collection("AMRO")
        .doc("#")
        .collection("chats")
        .doc(receiverId)
        .update({
      "last_message": messageModel.text,
      "message_date": messageModel.sendTime,
    });
  }

  void sendFirstMessage(String receiverId) {
    sendMessage(receiverId);
    //todo implemnent send first message
  }

//get messages
  Stream<List<MessageModel>> getMessages(String receiverId) {
    return database
        .collection("AMRO")
        .doc("#")
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("send_time", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

//get chats
  Stream<List<ChatModel>> getChats() {
    final senderRef =
        database.collection("AMRO").doc("#").collection("users").doc(myId);
    return database
        .collection("AMRO")
        .doc("#")
        .collection("chats")
        .where("sender_ref", isEqualTo: senderRef)
        .orderBy("send_time", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList());
  }

  //all users
  List<UserModel> users = [];

  void refreshGetUsers() {
    users.clear();
    getAllUsers();
  }

  void getAllUsers() async {
    if (users.isNotEmpty) {
      return;
    }
    final response =
        await database.collection("AMRO").doc("#").collection("users").get();

    for (final doc in response.docs) {
      if (doc.id == myId) {
        continue;
      }
      users.add(UserModel.fromJson(doc.data()));
    }

    emit(GetUsersState());
  }
}
