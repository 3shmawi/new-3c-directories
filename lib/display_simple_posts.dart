import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/theme_ctrl.dart';

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
        actions: [
          BlocBuilder<ThemeCubit, ThemeStates>(
            builder: (context, isDark) {
              final cubit = context.read<ThemeCubit>();
              return IconButton(
                onPressed: cubit.toggleTheme,
                icon: Icon(
                  cubit.isDark
                      ? CupertinoIcons.sun_dust
                      : Icons.dark_mode_outlined,
                ),
              );
            },
          )
        ],
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
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog.adaptive(
                              title: Text("Delete post?"),
                              content: Text(
                                  "Are you sure you need to delete this post?"),
                              actions: [
                                TextButton(
                                  onPressed: Navigator.of(context).pop,
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await Dio().delete(
                                        "https://680ce6282ea307e081d55f2a.mockapi.io/posts/${post["id"]}",
                                      );
                                    } finally {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text("Confirm"),
                                ),
                              ],
                            );
                          });

                      setState(() {});
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              spacing: 13,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(post["picture"]),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Title: ${post['title']}",
                                      ),
                                      Text(
                                          "Author Name: ${post["authorName"]}"),
                                      Text(
                                          "Description: ${post["description"]}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                              onPressed: () {
                                titleCtrl.text = post['title'];
                                descCtrl.text = post['description'];
                                imgUrlCtrl.text = post['picture'];
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return createOrUpdatePost(
                                        context,
                                        postId: post['id'],
                                      );
                                    });
                                setState(() {});
                              },
                              icon: Icon(Icons.edit)),
                        ),
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
                return createOrUpdatePost(context);
              });
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Container createOrUpdatePost(BuildContext context, {String? postId}) {
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

                    if (title.isEmpty || desc.isEmpty || imgUrl.isEmpty) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill all fields"),
                        ),
                      );
                      return;
                    }

                    final data = {
                      "title": title,
                      "description": desc,
                      "picture": imgUrl,
                      "publishedAt": DateTime.now().toIso8601String(),
                      "authorName": "MoRe H",
                    };

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      if (postId == null) {
                        await Dio().post(
                          "https://680ce6282ea307e081d55f2a.mockapi.io/posts",
                          data: data,
                        );
                      } else {
                        await Dio().put(
                          "https://680ce6282ea307e081d55f2a.mockapi.io/posts/$postId",
                          data: data,
                        );
                      }

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
                            content: Text("Error, ${error.toString()}"),
                          ),
                        );
                      });
                    } finally {
                      titleCtrl.clear();
                      descCtrl.clear();
                      imgUrlCtrl.clear();
                    }
                  },
                  child: Text(postId == null ? "Publish" : "Edit"),
                )
        ],
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
