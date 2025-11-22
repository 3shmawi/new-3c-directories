import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Object>(
            future: FirebaseFirestore.instance
                .collection("Omar/#/counter")
                .doc("count2")
                .get(),
            builder: (context, snapshot) {
              // waiting state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              // error state
              if (snapshot.hasError) {
                log(snapshot.error.toString());

                return Text("Error: ${snapshot.error}");
              }

              // success with no data
              final doc = snapshot.data as DocumentSnapshot?;
              final data = doc?.data() as Map<String, dynamic>?;
              if (data == null) {
                return Text("No data");
              }

              // success with data
              return Text(
                "Count: ${data['value']}",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("Omar/#/counter")
                  .doc("count2")
                  .update({"value": FieldValue.increment(1)});
              setState(() {});
            },
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("Omar/#/counter")
                  .doc("count2")
                  .update({"value": FieldValue.increment(-1)});
              setState(() {});
              //todo implement decrement
            },
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
