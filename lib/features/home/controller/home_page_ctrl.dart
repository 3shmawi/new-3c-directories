import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_3c/model/user_model.dart';

class HomePageCtrl {
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Stream<List<UserModel>> getAllUsers() {
    return fireStore
        .collection("k_k_h")
        .doc("#")
        .collection("users")
        .where('id', isNotEqualTo: auth.currentUser?.uid)
        .snapshots()
        .map((docs) {
      return docs.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }
}
