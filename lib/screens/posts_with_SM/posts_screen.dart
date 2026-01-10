import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/posts_ctrl.dart';
import 'package:new_3c/models/post_model.dart';
import 'package:new_3c/screens/counter/counter_screen.dart';

import 'package:new_3c/services/dio_helper.dart';

import '../home/widgets/news_item.dart';

class PostsHomeScreen extends StatelessWidget {
  const PostsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostsCtrl()..getPosts(),
      child: Scaffold(
        body: BlocBuilder<PostsCtrl, PostsStates>(
          builder: (context, state) {
            //loading
            if (state is PostsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            // if (asyncData.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            //error
            if (state is PostsErrorState) {
              return Center(
                child: Text("Something went wrong\n${state.errorMessage}"),
              );
            }
            // if (asyncData.hasError) {
            //   return Center(
            //       child: Text(
            //           "Something went wrong\n${asyncData.error}"));
            // }
            if (state is PostsEmptyState) {
              return const Center(child: Text("No Data"));
            }

            //
            // final posts = asyncData.data;
            //
            // if (posts == null || posts.isEmpty) {
            //   return const Center(child: Text("No Data"));
            // }

            if (state is PostsSuccessState) {
              return ListView.builder(
                itemBuilder: (context, index) => NewsItem(
                  postModel: state.posts[index],
                ),
                itemCount: state.posts.length,
              );
            }


            return SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CounterScreen(),
              ),
            );
          },
          child: Icon(Icons.calculate_outlined),
        ),
      ),
    );
  }
}
