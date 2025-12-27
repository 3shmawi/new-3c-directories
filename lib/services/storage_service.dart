import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final progressNotifier = ValueNotifier<double?>(null);

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  Future<String> uploadImage(File imageFile, String folder) async {
    return _uploadFile(
      file: imageFile,
      folder: folder,
      extension: 'jpg',
    );
  }

  Future<String> uploadVideo(File videoFile, String folder) async {
    return _uploadFile(
      file: videoFile,
      folder: folder,
      extension: 'mp4',
    );
  }

  Future<String> _uploadFile({
    required File file,
    required String folder,
    required String extension,
  }) async {
    try {
      progressNotifier.value = 0.0;

      final String fileName = '${_uuid.v4()}.$extension';
      final Reference ref = _storage.ref().child('$folder/$fileName');

      final UploadTask uploadTask = ref.putFile(file);

      // 🔥 Listen to progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (snapshot.totalBytes > 0) {
          progressNotifier.value =
              snapshot.bytesTransferred / snapshot.totalBytes;
        }
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      progressNotifier.value = null; // done
      return downloadUrl;
    } catch (e) {
      progressNotifier.value = null; // reset on error
      rethrow;
    }
  }

  Future<void> deleteFile(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // ignore
    }
  }
}