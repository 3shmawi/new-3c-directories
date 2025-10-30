import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final imgUrlCtrl = TextEditingController();

  bool isLoading = false;

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
                  return InkWell(
                    onLongPress: () async {
                      await Dio().delete(
                          "https://680ce6282ea307e081d55f2a.mockapi.io/posts/${post["id"]}");

                      setState(() {});
                    },
                    child: Column(
                      children: [
                        Text(
                          post['title'],
                        ),
                        Text(post["authorName"]),
                        Text(post["description"]),
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(post["picture"]),
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: titleCtrl,
                        decoration: InputDecoration(hintText: "Title"),
                      ),
                      TextField(
                        controller: descCtrl,
                        decoration: InputDecoration(hintText: "Description"),
                      ),
                      TextField(
                        controller: imgUrlCtrl,
                        decoration: InputDecoration(hintText: "Img url..."),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                final title = titleCtrl.text;
                                final desc = descCtrl.text;
                                final imgUrl = imgUrlCtrl.text;

                                if (title.isEmpty ||
                                    desc.isEmpty ||
                                    imgUrl.isEmpty) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Please fill all fields"),
                                    ),
                                  );
                                }

                                final data = {
                                  "title": title,
                                  "description": desc,
                                  "picture": imgUrl,
                                  "publishedAt":
                                      DateTime.now().toIso8601String(),
                                  "authorName": "MoRe H",
                                };

                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  await Dio().post(
                                      "https://680ce6282ea307e081d55f2a.mockapi.io/posts",
                                      data: data);

                                  setState(() {
                                    isLoading = false;
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("successfully"),
                                      ),
                                    );
                                  });
                                } catch (error) {
                                  setState(() {
                                    isLoading = false;
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text("Error, ${error.toString()}"),
                                      ),
                                    );
                                  });
                                }
                              },
                              child: Text("Publish"),
                            )
                    ],
                  ),
                );
              });
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
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
