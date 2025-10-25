import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posts API Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PostsPage(),
    );
  }
}

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final String apiUrl = "https://680ce6282ea307e081d55f2a.mockapi.io/posts";
  List posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  final dio = Dio();

  /// Fetch all posts
  Future<void> fetchPosts() async {
    final response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      setState(() {
        posts = response.data;
      });
    }
  }

  /// Add a new post
  Future<void> addPost(String title, String body) async {
    final response = await dio.post(
      apiUrl,
      data: {"title": title, "description": body},
    );
    if (response.statusCode == 201) {
      fetchPosts(); // Refresh list after adding
    }
  }

  ///delete a post
  Future<void> deletePost(String postId) async {
    final response = await dio.delete(
      "$apiUrl/$postId",
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Post Deleted successfully"),
        backgroundColor: Colors.green,
      ));
      fetchPosts(); // Refresh list after adding
    }
  }

  ///todo enable edit post

  /// UI
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Posts API Demo")),
      body: RefreshIndicator(
        onRefresh: fetchPosts,
        child: ListView.builder(
          itemCount: posts.length,
          reverse: true,
          itemBuilder: (context, index) {
            final post = posts[index];
            return InkWell(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {},
                            title: Text("Edit post"),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog.adaptive(
                                      title: Text(
                                          "Are you sure to delete thsi post?"),
                                      content: Text(
                                          "By deleting this post, u cant undo deletion"),
                                      actions: [
                                        TextButton(
                                          onPressed: Navigator.of(context).pop,
                                          child: Text(
                                            "cancel",
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              deletePost(post["id"]);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Confirm"))
                                      ],
                                    );
                                  });
                            },
                            title: Text("Delete post"),
                            trailing: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
                // Optionally handle post tap
              },
              child: Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(post["title"] ?? "No Title"),
                  subtitle: Text(post["description"] ?? "No Body"),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Add New Post"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  TextField(
                    controller: bodyController,
                    decoration: InputDecoration(labelText: "Body"),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text("Add"),
                  onPressed: () {
                    addPost(titleController.text, bodyController.text);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
