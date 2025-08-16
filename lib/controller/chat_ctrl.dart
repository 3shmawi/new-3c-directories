import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/models/chat.dart';
import 'package:new_3c/models/user.dart';

class ChatCtrl {
  final _database = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<ChatModel>> getMyChats() {
    return _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('chats')
        .where("participants", arrayContains: _auth.currentUser?.uid)
        .orderBy("last_message_time", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList();
    });
  }

  DocumentReference userRef(String userId) => _database
      .collection("YASSIN&ASER")
      .doc("#")
      .collection("users")
      .doc(userId);

  void deleteChat(String chatId) {
    _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('chats')
        .doc(chatId)
        .delete()
        .catchError((error) {
      print('Error deleting chat: $error');
    });
  }

  String getMessagePageId({required String receiverId, String? senderId}) {
    final idsList = [senderId ?? _auth.currentUser?.uid ?? '', receiverId];
    idsList.sort();
    return idsList.join('_');
  }

  void createChat(UserModel receiver) async {
    final chatId = getMessagePageId(
      receiverId: receiver.uid,
    );
    final existingChat = await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('chats')
        .doc(chatId)
        .get();
    if (existingChat.exists) {
      print('Chat already exists with ID: $chatId');
      return;
    }

    final newChat = ChatModel(
      uid: chatId,
      lastMessage: "Started a chat",
      lastMessageTime: DateTime.now().toUtc(),
      senderId: _auth.currentUser?.uid ?? '',
      receiverId: receiver.uid,
      participants: [_auth.currentUser?.uid ?? '', receiver.uid],
    );
    await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('chats')
        .doc(chatId)
        .set(newChat.toMap())
        .catchError((error) {
      throw 'Error creating chat: $error';
    });
  }

  Future<UserModel> getUserById(String userId) async {
    final doc = await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('users')
        .doc(userId)
        .get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    } else {
      throw 'User not found';
    }
  }

  final messageCtrl = TextEditingController();

  void sendMessage(String chatId, UserModel receiver) async {
    if (messageCtrl.text.isEmpty) {
      throw 'Message cannot be empty';
    }
    //todo if user has not messages then create a chat
    final chatExists = await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('chats')
        .doc(chatId)
        .get();
    if (!chatExists.exists) {
      createChat(receiver);
    }

    final message = {
      "sender_id": _auth.currentUser?.uid,
      "receiver_id": receiver.uid,
      "message": messageCtrl.text,
      "timestamp": DateTime.now().toUtc(),
    };

    await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message)
        .then((_) {
      messageCtrl.clear();
    }).catchError((error) {
      throw 'Error sending message: $error';
    });
  }

  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
