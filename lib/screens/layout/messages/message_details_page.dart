import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:new_3c/controller/chat_ctrl.dart';
import 'package:new_3c/models/user.dart';

class MessageDetailsPage extends StatefulWidget {
  const MessageDetailsPage({required this.receiver, super.key});

  final UserModel receiver;

  @override
  MessageDetailsPageState createState() => MessageDetailsPageState();
}

class MessageDetailsPageState extends State<MessageDetailsPage> {
  late final types.User _currentUser;
  List<types.Message> _messages = [];
  final ChatCtrl _chatCtrl = ChatCtrl();
  late String _chatId;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    // Initialize current user from Firebase Auth
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _currentUser = types.User(
        id: currentUser.uid,
        firstName: currentUser.displayName ?? 'User',
        lastName: '',
      );
    } else {
      // Fallback if no user is logged in
      _currentUser = types.User(
        id: 'anonymous',
        firstName: 'Anonymous',
        lastName: '',
      );
    }

    // Generate chat ID
    _chatId = _chatCtrl.getMessagePageId(receiverId: widget.receiver.uid);

    // Load messages from Firebase
    _loadMessages();
  }

  void _loadMessages() {
    _chatCtrl.getMessages(_chatId).listen((firebaseMessages) {
      setState(() {
        _messages = _convertFirebaseMessagesToChatTypes(firebaseMessages);
      });
    });
  }

  List<types.Message> _convertFirebaseMessagesToChatTypes(
      List<Map<String, dynamic>> firebaseMessages) {
    return firebaseMessages.map((messageData) {
      final senderId = messageData['sender_id'] as String;
      final isCurrentUser = senderId == _auth.currentUser?.uid;

      return types.TextMessage(
        author: isCurrentUser
            ? _currentUser
            : types.User(
                id: senderId,
                firstName: widget.receiver.displayName,
                lastName: '',
              ),
        createdAt: (messageData['timestamp'] as Timestamp?)
                ?.toDate()
                .millisecondsSinceEpoch ??
            DateTime.now().millisecondsSinceEpoch,
        id: '${(messageData['timestamp'] as Timestamp?)?.toDate().millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch}_$senderId', // Create unique ID
        text: messageData['message'] as String,
      );
    }).toList();
  }

  void _handleSendPressed(types.PartialText message) async {
    try {
      // Set the message in the controller
      _chatCtrl.messageCtrl.text = message.text;

      // Send the message through Firebase
      _chatCtrl.sendMessage(_chatId, widget.receiver);

      // Message will be automatically added to the list through the stream listener
      // No need to manually add it to _messages as _loadMessages() handles it
    } catch (e) {
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) {
    // Handle message tap events
    if (message is types.TextMessage) {
      // You can show message details, copy text, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message: ${message.text}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.displayName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        onMessageTap: _handleMessageTap,
        user: _currentUser,
        theme: DefaultChatTheme(
          primaryColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey[50]!,
          inputBackgroundColor: Colors.white,
          inputTextColor: Colors.black87,
          inputTextCursorColor: Theme.of(context).primaryColor,
          sentMessageBodyTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          receivedMessageBodyTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
