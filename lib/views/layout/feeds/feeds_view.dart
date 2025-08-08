import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl.dart';

import '../../../controller/post_ctrl.dart';

class FeedsView extends StatefulWidget {
  const FeedsView({super.key});

  @override
  State<FeedsView> createState() => _FeedsViewState();
}

class _FeedsViewState extends State<FeedsView> {
  @override
  void initState() {
    super.initState();
    PostCtrl.get(context).loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feeds"),
      ),
      body: BlocBuilder<PostCtrl, PostStates>(
        builder: (context, state) {
          final ctrl = PostCtrl.get(context);

          if (state is PostLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostErrorState) {
            return Center(child: Text("Error: ${state.error}"));
          }

          if (ctrl.posts.isEmpty) {
            return const Center(child: Text("No posts found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: ctrl.posts.length,
            itemBuilder: (context, index) {
              final post = ctrl.posts[index];
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8)),
                            child: Image.network(
                              post.picture,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 180,
                                color: Colors.grey[300],
                                child: const Center(
                                    child: Icon(Icons.image_not_supported)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(
                                  "By ${post.authorName} • ${DateTime.tryParse(post.publishedAt)?.toLocal().toString().split(".").first ?? post.publishedAt}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Text(post.description),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (post.authorId == ctrl.myId)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            ctrl.selectPost(post);
                            LayoutCtrl.get(context).changeBottomNav(1);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            final confirm = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Post"),
                                    content: const Text(
                                        "Are you sure you want to delete this post?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                });
                            if (confirm == true) {
                              ctrl.selectPost(post);
                              ctrl.deletePost();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      const Text("Post deleted successfully"),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
