import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DisplaySimplePosts extends StatelessWidget {
  const DisplaySimplePosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Simple Posts"),
      ),
      body: FutureBuilder(
        future: Dio().get("https://680ce6282ea307e081d55f2a.mockapi.io/posts"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          final response = snapshot.data;
          if (response == null) {
            return const Center(
              child: Text("No data"),
            );
          }

          final posts = response.data;
          if (posts is List && posts.isEmpty) {
            return const Center(
              child: Text("No posts available"),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post['title'] ?? 'No Title'),
                subtitle: Text(post['description'] ?? 'No Description'),
              );
            },
          );
        },
      ),
    );
  }
}
