import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/chat.dart';

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
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatModel.fromJson(doc.data()))
              .toList());
    } else {
      return Stream.value([]);
    }
  }
}

abstract class ChatStates {}

class ChatInitialState extends ChatStates {}
