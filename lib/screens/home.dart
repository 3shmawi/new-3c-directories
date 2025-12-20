import 'package:flutter/material.dart';
import 'package:new_3c/screens/widgets/app_bar_part.dart';
import 'package:new_3c/screens/widgets/news_item.dart';
import 'package:new_3c/services/dio_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarPart(),
      body: FutureBuilder(
          future: APIRequestsHelper().get("posts"),
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

            if(posts is List? && ( posts == null || posts.isEmpty)){
              return const Center(child: Text("No Data"));
            }

            final postsList = posts as List;
            return ListView.builder(
              itemBuilder: (context, index) => NewsItem(
                description: postsList[index]?['description'],
              ),
              itemCount: postsList.length,
            );
          }),
    );
  }
}
