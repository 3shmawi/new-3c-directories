import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_3c/models/user.dart';

class UsersCtrl {
  final _database = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<UserModel>> fetchUsers() async {
    try {
      final snapshot = await _database
          .collection("YASSIN&ASER")
          .doc("#")
          .collection('users')
          .where("uid", isNotEqualTo: _auth.currentUser?.uid)
          .orderBy("created_at", descending: true)
          .get();
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e) {
      rethrow;
    }
  }
}
