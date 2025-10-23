import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  const Display({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Display"),
      ),
      body: FutureBuilder(
          future:
              Dio().get("https://680ce6282ea307e081d55f2a.mockapi.io/posts"),
          builder: (context, snapshot) {
            // fist i will check if state is loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // second i will check if there is error
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            // third i will check if data is null
            final response = snapshot.data;
            if (response == null) {
              return Center(
                child: Text("No data"),
              );
            }

            final posts = response.data;

            if (posts is List && posts.isEmpty) {
              return Center(
                child: Text("No posts available"),
              );
            }

            return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Column(
                    children: [
                      Text(
                        post['title'],
                      ),
                      Text(post["authorName"]),
                      Divider(),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  );
                });
          }),
    );
  }
}

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
