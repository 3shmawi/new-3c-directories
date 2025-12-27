import 'package:flutter/material.dart';
import 'package:new_3c/models/post_model.dart';
import 'package:new_3c/screens/widgets/app_bar_part.dart';
import 'package:new_3c/screens/widgets/news_item.dart';
import 'package:new_3c/services/dio_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPart(),
      body: FutureBuilder<List<PostModel>>(
          future: getPosts(),
          builder: (context, asyncData) {
            //loading
            if (asyncData.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            //error
            if (asyncData.hasError) {
              return Center(
                  child: Text("Something went wrong\n${asyncData.error}"));
            }

            final posts = asyncData.data;

            if (posts == null || posts.isEmpty) {
              return const Center(child: Text("No Data"));
            }

            return ListView.builder(
              itemBuilder: (context, index) => NewsItem(
                postModel: posts[index],
              ),
              itemCount: posts.length,
            );
          }),
    );
  }

  Future<List<PostModel>> getPosts() async {
    final response = await APIRequestsHelper().get("posts");
    if (response is List) {
      return response.map((e) => PostModel.fromJson(e)).toList();
    }

    return [];
  }
}
