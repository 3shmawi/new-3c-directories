import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/features/chat/model/message.dart';
import 'package:new_3c/model/user_model.dart';

class MessageCtrl extends Cubit<MessageStates> {
  MessageCtrl() : super(MessageInitialState());

  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  UserModel? userModel;

  void fetchProfileData() async {
    final myId = auth.currentUser?.uid;
    if (myId == null) {
      emit(MessageErrorState("unauthenticated, please sign in first"));
      return;
    }
    try {
      final userDoc =
          await fireStore.collection("k_k_h/#/users").doc(myId).get();
      userModel = UserModel.fromJson(userDoc.data()!);
      emit(MessageInitialState());
    } catch (error) {
      emit(MessageErrorState(error.toString()));
    }
  }

  ///send message
  void sendMessage(String message, {String? receiverId}) async {
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
      profileAvatar: userModel?.profilePictureUrl,
      displayName: userModel?.name,
    );

    try {
      if (receiverId == null) {
        await fireStore
            .collection("k_k_h")
            .doc("#")
            .collection("messages")
            .doc(newId)
            .set(newMessage.toJson());
      } else {
        await fireStore
            .collection("k_k_h")
            .doc("#")
            .collection("messages")
            .doc(auth.currentUser!.uid)
            .collection("private_chat")
            .doc(receiverId)
            .collection("messages")
            .add(newMessage.toJson());
        await fireStore
            .collection("k_k_h")
            .doc("#")
            .collection("messages")
            .doc(receiverId)
            .collection("private_chat")
            .doc(auth.currentUser!.uid)
            .collection("messages")
            .add(newMessage.toJson());
      }
      changeTypingValue(false);

      emit(MessageSuccessState());
    } catch (error) {
      emit(MessageErrorState(error.toString()));
    }
  }

  ///get message
  Stream<List<Message>> getMessages({String? receiverId}) {
    if (receiverId == null) {
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
    } else {
      return fireStore
          .collection("k_k_h")
          .doc("#")
          .collection("messages")
          .doc(receiverId)
          .collection("private_chat")
          .doc(auth.currentUser!.uid)
          .collection("messages")
          .orderBy('time', descending: true)
          .snapshots()
          .map((docs) {
        return docs.docs.map((doc) {
          final message = Message.fromJson(doc.data());
          if (message.senderId != auth.currentUser!.uid) {
            fireStore
                .collection("k_k_h")
                .doc("#")
                .collection("messages")
                .doc(receiverId)
                .collection("private_chat")
                .doc(auth.currentUser!.uid)
                .collection("messages")
                .doc(doc.id)
                .update({
              "seen": true,
            });
          }
          return message;
        }).toList();
      });
    }
  }

  void changeTypingValue(bool isTyping) {
    final myId = auth.currentUser?.uid;
    if (myId == null) throw "unauthenticated";
    if (isTyping) {
      fireStore
          .collection("k_k_h")
          .doc("#")
          .collection("public_chat")
          .doc("#")
          .update({
        "users_typing_ids": FieldValue.arrayUnion([myId]),
      });
    } else {
      fireStore
          .collection("k_k_h")
          .doc("#")
          .collection("public_chat")
          .doc("#")
          .update({
        "users_typing_ids": FieldValue.arrayRemove([myId]),
      });
    }
  }

  Stream<bool> isTypingStream() {
    return fireStore
        .collection("k_k_h")
        .doc("#")
        .collection("public_chat")
        .doc("#")
        .snapshots()
        .map((doc) {
      final data = doc.data();
      final usersIds = data?['users_typing_ids'] as List?;
      usersIds?.remove(auth.currentUser?.uid);
      return usersIds?.isNotEmpty == true;
    });
  }}

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
