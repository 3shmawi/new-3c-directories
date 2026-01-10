import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/post_model.dart';

import '../services/dio_helper.dart';

class PostsCtrl extends Cubit<PostsStates> {
  PostsCtrl() : super(PostsInitialState2());

  void getPosts() async {
    emit(PostsLoadingState());
    try {
      List<PostModel> posts = [];
      final response = await APIRequestsHelper().get("posts");
      if (response is List) {
        posts = response.map((e) => PostModel.fromJson(e)).toList();
      }
      if (posts.isEmpty) {
        emit(PostsEmptyState());
      } else {
        emit(PostsSuccessState(posts));
      }
    } catch (error) {
      emit(PostsErrorState(error.toString()));
    }
  }
}


























class PostsStates {}




class PostsInitialState2 extends PostsStates {}




class PostsLoadingState extends PostsStates {}





class PostsEmptyState extends PostsStates {}





class PostsSuccessState extends PostsStates {
  List<PostModel> posts;

  PostsSuccessState(this.posts);
}




class PostsErrorState extends PostsStates {
  String errorMessage;

  PostsErrorState(this.errorMessage);
}
