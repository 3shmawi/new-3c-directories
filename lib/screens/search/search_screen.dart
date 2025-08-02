import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../widgets/post_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({required this.posts, super.key});

  final List<PostModel> posts;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<PostModel> filteredPosts = widget.posts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.cyan),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Text(
          "Search Screen",
          style: TextStyle(
            color: Colors.cyan,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.cyan, width: 1.5),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  filteredPosts = widget.posts
                      .where((post) =>
                          post.title!
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          post.description!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              if (filteredPosts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 150,
                        color: Colors.cyan,
                      ),
                      const Text(
                        "No Data Found",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Please try again with different words",
                        style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                      )
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) => PostItem(
                  post: filteredPosts[index],
                ),
                separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
                itemCount: filteredPosts.length,
              );
            }),
          ),
        ],
      ),
    );
  }
}
