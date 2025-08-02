import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void createChat(UserModel receiver) async {
    final newId = _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection('chats')
        .doc()
        .id;

    final newChat = ChatModel(
      uid: newId,
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
        .doc(newId)
        .set(newChat.toMap())
        .catchError((error) {
      throw 'Error creating chat: $error';
    });
  }
}
