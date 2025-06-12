import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DisplayDogImageFromApi extends StatefulWidget {
  const DisplayDogImageFromApi({super.key});

  @override
  State<DisplayDogImageFromApi> createState() => _DisplayDogImageFromApiState();
}

class _DisplayDogImageFromApiState extends State<DisplayDogImageFromApi> {
  final _dio = Dio();
  Future<String> fetchDogImage() async {
    final response = await _dio.get("https://dog.ceo/api/breeds/image/random");
    return response.data['message'] as String;
//
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Image from API'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Refresh the image when pressed
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchDogImage(), // Replace with your API call
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Image.network(snapshot.data!);
            }
          },
        ),
      ),
    );
  }
}
