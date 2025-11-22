import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/group_model.dart';
import 'storage_service.dart';
import 'dart:io';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  // Get or create personal chat
  Future<String> getOrCreatePersonalChat(String otherUserId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw Exception('User not authenticated');

    // Check if chat already exists
    final existingChats = await _firestore
        .collection('chats')
        .where('type', isEqualTo: 'personal')
        .where('participants', arrayContains: currentUserId)
        .get();

    for (var doc in existingChats.docs) {
      final chat = ChatModel.fromMap(doc.data(), doc.id);
      if (chat.participants.contains(otherUserId) &&
          chat.participants.length == 2) {
        return doc.id;
      }
    }

    // Create new chat
    final chatId = _uuid.v4();
    await _firestore.collection('chats').doc(chatId).set({
      'type': 'personal',
      'participants': [currentUserId, otherUserId],
      'lastMessage': null,
      'lastMessageTime': null,
    });

    return chatId;
  }

  // Send text message
  Future<void> sendTextMessage(String chatId, String text) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw Exception('User not authenticated');

    final messageId = _uuid.v4();
    final message = {
      'chatId': chatId,
      'senderId': currentUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    };

    await _firestore.collection('messages').doc(messageId).set(message);

    // Update chat last message
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Send image message
  Future<void> sendImageMessage(String chatId, File imageFile) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw Exception('User not authenticated');

    // Upload image
    final imageUrl = await _storageService.uploadImage(imageFile, 'messages');

    final messageId = _uuid.v4();
    final message = {
      'chatId': chatId,
      'senderId': currentUserId,
      'text': '📷 Image',
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'image',
      'imageUrl': imageUrl,
    };

    await _firestore.collection('messages').doc(messageId).set(message);

    // Update chat last message
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': '📷 Image',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get messages stream
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get chats stream
  Stream<List<ChatModel>> getChats() {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Create group
  Future<String> createGroup({
    required String name,
    File? imageFile,
    required List<String> memberIds,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw Exception('User not authenticated');

    final groupId = _uuid.v4();
    String? imageUrl;

    if (imageFile != null) {
      imageUrl = await _storageService.uploadImage(imageFile, 'groups');
    }

    // Create group document
    final group = GroupModel(
      id: groupId,
      name: name,
      imageUrl: imageUrl,
      adminId: currentUserId,
      members: [currentUserId, ...memberIds],
      createdAt: DateTime.now(),
    );

    await _firestore.collection('groups').doc(groupId).set(group.toMap());

    // Create chat for group
    await _firestore.collection('chats').doc(groupId).set({
      'type': 'group',
      'participants': group.members,
      'lastMessage': null,
      'lastMessageTime': null,
      'groupInfo': {
        'groupId': groupId,
        'name': name,
        'imageUrl': imageUrl,
      },
    });

    return groupId;
  }

  // Get group
  Future<GroupModel?> getGroup(String groupId) async {
    final doc = await _firestore.collection('groups').doc(groupId).get();
    if (!doc.exists) return null;
    return GroupModel.fromMap(doc.data()!, doc.id);
  }

  // Add member to group
  Future<void> addMemberToGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });

    await _firestore.collection('chats').doc(groupId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  // Remove member from group
  Future<void> removeMemberFromGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });

    await _firestore.collection('chats').doc(groupId).update({
      'participants': FieldValue.arrayRemove([userId]),
    });
  }

  // Leave group
  Future<void> leaveGroup(String groupId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    await removeMemberFromGroup(groupId, currentUserId);
  }

  // Get all users for creating groups
  Stream<List<Map<String, dynamic>>> getAllUsers() {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }
}

