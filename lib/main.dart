import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firestore = FirebaseFirestore.instance;

  void getCounterValue() async {
    final doc = await firestore
        .collection("k_k_h")
        .doc("#")
        .collection("counter")
        .doc("count")
        .get();

    final data = doc.data()?["amount"];
  }

  void updateCounterValue() async {
    await firestore
        .collection("k_k_h")
        .doc("#")
        .collection("counter")
        .doc("count")
        .set({"amount": FieldValue.increment(1)}, SetOptions(merge: true));
  }

  void deleteCounterValue() async {
    await firestore
        .collection("k_k_h")
        .doc("#")
        .collection("counter")
        .doc("count")
        .delete();
  }

  Stream<int> counterStream() {
    return firestore
        .collection("k_k_h")
        .doc("#")
        .collection("counter")
        .doc("count")
        .snapshots()
        .map((snapshot) => snapshot.data()?["amount"] ?? 0);
  }

  @override
  void initState() {
    getCounterValue();
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      updateCounterValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<int>(
                stream: counterStream(),
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data ?? 0}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ),
          IconButton(
            onPressed: deleteCounterValue,
            tooltip: 'Increment',
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
