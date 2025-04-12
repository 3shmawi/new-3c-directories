import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AppConstants {
  static final collectionPath =
      FirebaseFirestore.instance.collection("ISLAM").doc("#");
}
