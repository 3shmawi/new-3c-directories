import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/screens/search/search_screen.dart';
import 'package:new_3c/screens/widgets/post_item.dart';
import 'package:new_3c/services/dio_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../models/post.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

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
          "News Feed",
          style: TextStyle(
            color: Colors.cyan,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final posts = (await HttpUtil().get("posts")) as List?;
                if (posts == null || posts.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No posts available"),
                    ),
                  );
                  return;
                }
                final List<PostModel> postsModel = posts
                    .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
                    .toList();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(posts: postsModel),
                  ),
                );
              },
              icon: Icon(CupertinoIcons.search))
        ],
      ),
      body: FutureBuilder(
        future: HttpUtil().get("posts"),
        builder: (context, snapshot) {
          final isLoading =
              snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == null;
          if (isLoading) {
            return Skeletonizer(
              enabled: true,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) => PostItem(),
                separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
                itemCount: 2,
              ),
            );
          }

          final posts = snapshot.data as List?;

          if (posts?.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.data_object_sharp,
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
                    "Create new post to show it at newsfeed",
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  )
                ],
              ),
            );
          }

          final postsModel = posts!
              .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
              .toList();

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemBuilder: (context, index) => PostItem(
              post: postsModel[index],
            ),
            separatorBuilder: (context, index) => SizedBox(
              height: 16,
            ),
            itemCount: postsModel.length,
          );
        },
      ),
    );
  }
}
