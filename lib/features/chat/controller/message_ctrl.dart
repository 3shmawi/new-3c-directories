import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/features/chat/model/message.dart';

class MessageCtrl extends Cubit<MessageStates> {
  MessageCtrl() : super(MessageInitialState());

  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  ///send message
  void sendMessage(String message) async {
    if (message.isEmpty) {
      emit(MessageErrorState("Enter a text"));
      return;
    }
    if (auth.currentUser?.uid == null) {
      emit(MessageErrorState("unauthenticated user"));
      return;
    }

    emit(MessageLoadingState());

    final newId = DateTime.now().toIso8601String();
    final newMessage = Message(
      id: newId,
      text: message,
      senderId: auth.currentUser!.uid,
      time: DateTime.now().toUtc(),
    );

    try {
      await fireStore
          .collection("k_k_h")
          .doc("#")
          .collection("messages")
          .doc(newId)
          .set(newMessage.toJson());
      changeTypingValue(false);

      emit(MessageSuccessState());
    } catch (error) {
      emit(MessageErrorState(error.toString()));
    }
  }

  ///get message
  Stream<List<Message>> getMessages() {
    return fireStore
        .collection("k_k_h")
        .doc("#")
        .collection("messages")
        .orderBy('time', descending: true)
        .snapshots()
        .map((docs) {
      return docs.docs.map((doc) {
        return Message.fromJson(doc.data());
      }).toList();
    });
  }

  void changeTypingValue(bool isTyping) {
    fireStore
        .collection("k_k_h")
        .doc("#")
        .collection("public_chat")
        .doc("#")
        .set({
      "is_typing": isTyping,
    }, SetOptions(merge: true));
  }

  Stream<bool> isTypingStream() {
    return fireStore
        .collection("k_k_h")
        .doc("#")
        .collection("public_chat")
        .doc("#")
        .snapshots()
        .map((doc) {
      return doc.data()?['is_typing'] ?? false;
    });
  }
}

abstract class MessageStates {}

class MessageInitialState extends MessageStates {}

class MessageLoadingState extends MessageStates {}

class MessageSuccessState extends MessageStates {}

class MessageErrorState extends MessageStates {
  final String error;

  MessageErrorState(this.error);
}

//implementation
//provider
//builder
