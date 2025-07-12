import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final _database = FirebaseFirestore.instance;

  void _incrementCounter() async {
    await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection("counter")
        .doc("data")
        .update(
      {"count": FieldValue.increment(1)},
    );
  }

  void _decrementCounter() async {
    await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection("counter")
        .doc("data")
        .update(
      {"count": FieldValue.increment(-1)},
    );
  }

  void _getCounter() async {
    final response = await _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection("counter")
        .doc("data")
        .get();

    if (response.exists) {
      // setState(() {
      //   _counter = response.data()?['count'] ?? 0;
      // });
    }
  }

  Stream<int> _counterStream() {
    return _database
        .collection("YASSIN&ASER")
        .doc("#")
        .collection("counter")
        .doc("data")
        .snapshots()
        .map((snapshot) => snapshot.data()?['count'] ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter with firebase"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<int>(
              stream: _counterStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return Text("${snapshot.data ?? 0}",
                    style: TextStyle(fontSize: 50));
              }),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: _incrementCounter,
                label: Text("Increment"),
                icon: Icon(Icons.add),
              ),
              ElevatedButton.icon(
                onPressed: _decrementCounter,
                label: Text("Decrement"),
                icon: Icon(Icons.remove),
              ),
            ],
          )
        ],
      ),
    );
  }
}
