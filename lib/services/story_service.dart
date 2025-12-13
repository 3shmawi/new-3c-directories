import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/story_model.dart';
import 'storage_service.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageService _storageService = StorageService();
  final Uuid _uuid = const Uuid();

  // Create story
  Future<void> createStory({
    required File mediaFile,
    required String mediaType, // 'image' or 'video'
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) throw Exception('User not authenticated');

    // Upload media
    String mediaUrl;
    if (mediaType == 'video') {
      mediaUrl = await _storageService.uploadVideo(mediaFile, 'Omar/#/stories');
    } else {
      mediaUrl = await _storageService.uploadImage(mediaFile, 'Omar/#/stories');
    }

    // Create story
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: 24));

    final storyId = _uuid.v4();
    await _firestore.collection('Omar/#/stories').doc(storyId).set({
      'userId': currentUserId,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'createdAt': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'seenBy': [],
    });
  }

  // Get active stories (not expired)
  Stream<List<StoryModel>> getActiveStories() {
    final now = Timestamp.now();
    return _firestore
        .collection('Omar/#/stories')
        .where('expiresAt', isGreaterThan: now)
        .orderBy('expiresAt', descending: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StoryModel.fromMap(doc.data(), doc.id))
            .where((story) => !story.isExpired)
            .toList());
  }

  // Get stories by user
  Stream<List<StoryModel>> getStoriesByUser(String userId) {
    final now = Timestamp.now();
    return _firestore
        .collection('Omar/#/stories')
        .where('userId', isEqualTo: userId)
        .where('expiresAt', isGreaterThan: now)
        .orderBy('expiresAt', descending: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StoryModel.fromMap(doc.data(), doc.id))
            .where((story) => !story.isExpired)
            .toList());
  }

  // Mark story as seen
  Future<void> markStoryAsSeen(String storyId) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    await _firestore.collection('Omar/#/stories').doc(storyId).update({
      'seenBy': FieldValue.arrayUnion([currentUserId]),
    });
  }

  // Delete expired stories (should be called periodically)
  Future<void> deleteExpiredStories() async {
    final now = Timestamp.now();
    final expiredStories = await _firestore
        .collection('Omar/#/stories')
        .where('expiresAt', isLessThan: now)
        .get();

    for (var doc in expiredStories.docs) {
      final story = StoryModel.fromMap(doc.data(), doc.id);
      // Delete media file from storage
      await _storageService.deleteFile(story.mediaUrl);
      // Delete story document
      await doc.reference.delete();
    }
  }

  // Get users with active stories
  Stream<List<String>> getUsersWithStories() {
    final now = Timestamp.now();
    return _firestore
        .collection('Omar/#/stories')
        .where('expiresAt', isGreaterThan: now)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StoryModel.fromMap(doc.data(), doc.id).userId)
            .toSet()
            .toList());
  }
}
