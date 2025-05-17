import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/chat.dart';
import 'package:new_3c/models/message.dart';

import '../../app/constants.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  Stream<List<ChatModel>> getMyChats() {
    if (_currentUserId != null) {
      return AppConstants.collectionPath
          .collection('chats')
          .where(
            'participants',
            arrayContains: _currentUserId,
          )
          .orderBy("last_message_time", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))
              .toList());
    } else {
      return Stream.value([]);
    }
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return AppConstants.collectionPath
        .collection('chats')
        .doc(chatId)
        .collection("messages")
        .orderBy("time", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

  final messageCtrl = TextEditingController();

  Future<String> fetchOrCreateChat(String senderId, String receiverId) async {
    final col = AppConstants.collectionPath.collection('chats');

    // ❶ Try to find an existing 1-to-1 chat
    final snap = await col
        .where('participants', arrayContains: senderId)
        .where('participants', arrayContains: receiverId)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) return snap.docs.first.id;

    // ❷ None found → create a new chat doc
    final doc = await col.add({
      'participants': [senderId, receiverId],
    });
    return doc.id;
  }

  void sendMessage(String chatId) {
    if (_currentUserId == null) {
      emit(SendMessageErrorState("You should login first"));
      return;
    }

    if (messageCtrl.text.isEmpty) {
      emit(SendMessageErrorState("Please write an message first"));
    }
    final newId = DateTime.now().toIso8601String();
    final newMessage = MessageModel(
      id: newId,
      senderId: _currentUserId,
      receiverId: chatId,
      text: messageCtrl.text,
      time: newId,
      type: "text",
    );
    AppConstants.collectionPath
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(newId)
        .set(newMessage.toJson())
        .then((value) async {
      await AppConstants.collectionPath.collection("chats").doc(chatId).update({
        'last_message': newMessage.text,
        'last_message_time': newMessage.time,
      });
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(
          "Sending message getting an error, ${error.toString()}"));
    });
  }
}

abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class SendMessageLoadingState extends ChatStates {}

class SendMessageSuccessState extends ChatStates {}

class SendMessageErrorState extends ChatStates {
  final String errorMsg;

  SendMessageErrorState(this.errorMsg);
}
