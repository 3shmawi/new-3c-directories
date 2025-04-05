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

  void sendMessage(String receiverId, bool isNewChat) async {
    if (isNewChat) {
      await _sendFirstMessage(receiverId);
    } else {
      await _sendMessage(receiverId);
    }
  }

  // Send first message (also creates chat doc)
  Future<void> _sendFirstMessage(String receiverId) async {
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

    final chatRef = database
        .collection("AMRO")
        .doc("#")
        .collection("chats")
        .doc(receiverId);
    final newMessageId = DateTime.now().toIso8601String();

    final senderRef =
        database.collection("AMRO").doc("#").collection("users").doc(myId);
    final receiverRef = database
        .collection("AMRO")
        .doc("#")
        .collection("users")
        .doc(receiverId);

    final messageModel = MessageModel(
      id: newMessageId,
      text: message,
      sendTime: newMessageId,
      updatedTime: newMessageId,
      senderRef: senderRef,
      receiverRef: receiverRef,
    );

    final newChat = ChatModel(
      id: receiverId,
      senderRef: senderRef,
      receiverRef: receiverRef,
      lastMessage: messageModel.text,
      messageDate: messageModel.sendTime,
      isMessageRead: false,
    );

    await chatRef
        .collection("messages")
        .doc(messageModel.id)
        .set(messageModel.toJson());

    messageCtrl.clear();
    await chatRef.set(newChat.toJson(), SetOptions(merge: true));
  }

  // Send message (chat already exists)
  Future<void> _sendMessage(String receiverId) async {
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

    final newMessageId = DateTime.now().toIso8601String();
    final timestamp = FieldValue.serverTimestamp();

    final senderRef =
        database.collection("AMRO").doc("#").collection("users").doc(myId);
    final receiverRef = database
        .collection("AMRO")
        .doc("#")
        .collection("users")
        .doc(receiverId);

    final messageModel = MessageModel(
      id: newMessageId,
      text: message,
      sendTime: newMessageId,
      updatedTime: newMessageId,
      senderRef: senderRef,
      receiverRef: receiverRef,
    );

    final chatRef = database
        .collection("AMRO")
        .doc("#")
        .collection("chats")
        .doc(receiverId);

    await chatRef
        .collection("messages")
        .doc(messageModel.id)
        .set(messageModel.toJson());

    messageCtrl.clear();

    await chatRef.update({
      "last_message": messageModel.text,
      "message_date": timestamp,
    });
  }

  // Stream messages
  Stream<List<MessageModel>> getMessages(String receiverId) {
    return database
        .collection("AMRO")
        .doc("#")
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("send_time", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

  // Stream chats
  Stream<List<ChatModel>> getChats() {
    final senderRef =
        database.collection("AMRO").doc("#").collection("users").doc(myId);
    return database
        .collection("AMRO")
        .doc("#")
        .collection("chats")
        .where("sender_ref", isEqualTo: senderRef)
        .orderBy("message_date", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromJson(doc.data()))
            .toList());
  }

  // Users
  List<UserModel> users = [];

  void refreshGetUsers() {
    users.clear();
    getAllUsers();
  }

  void getAllUsers() async {
    if (users.isNotEmpty) return;

    final response =
        await database.collection("AMRO").doc("#").collection("users").get();

    for (final doc in response.docs) {
      if (doc.id == myId) continue;
      users.add(UserModel.fromJson(doc.data()));
    }

    emit(GetUsersState());
  }

  Future<UserModel> getUser(String id) async {
    final userData = (await database
            .collection("AMRO")
            .doc("#")
            .collection("users")
            .doc(id)
            .get())
        .data();

    return UserModel.fromJson(userData!);
  }
}
