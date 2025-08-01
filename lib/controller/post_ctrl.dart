import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/services/dio_helper.dart';

import '../models/post.dart';
import '../services/local_storage.dart';

class PostCtrl extends Cubit<PostStates> {
  PostCtrl() : super(PostInitialState());

  static PostCtrl get(context) => BlocProvider.of<PostCtrl>(context);

  PostModel? selectedPost;

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final authorNameCtrl = TextEditingController();
  final pictureCtrl = TextEditingController();

  final _http = HttpUtil();

  void createPost() async {
    final box = await HiveService().openBox("myUserData");
    final authorId = box.get("myId", defaultValue: null);
    if (authorId == null) {
      emit(PostErrorState("Unauthenticated user"));
      return;
    }
    if (titleCtrl.text.isEmpty || descriptionCtrl.text.isEmpty) {
      emit(PostErrorState("Title and description cannot be empty"));
      return;
    }
    if (authorNameCtrl.text.isEmpty || pictureCtrl.text.isEmpty) {
      emit(PostErrorState("Author name and picture cannot be empty"));
      return;
    }

    final newPost = PostModel(
      authorName: authorNameCtrl.text,
      picture: pictureCtrl.text,
      title: titleCtrl.text,
      publishedAt: DateTime.now().toIso8601String(),
      description: descriptionCtrl.text,
      authorId: authorId,
    );

    await _http.post("posts", data: newPost.toJson());

    titleCtrl.clear();
    descriptionCtrl.clear();
    authorNameCtrl.clear();
    pictureCtrl.clear();
    selectedPost = null;
    emit(PostSuccessState());
  }

  void editPost() {
    if (selectedPost == null) {
      emit(PostErrorState("No post selected for editing"));
      return;
    }
    if (titleCtrl.text.isEmpty || descriptionCtrl.text.isEmpty) {
      emit(PostErrorState("Title and description cannot be empty"));
      return;
    }
    if (authorNameCtrl.text.isEmpty || pictureCtrl.text.isEmpty) {
      emit(PostErrorState("Author name and picture cannot be empty"));
      return;
    }
    final updatedPost = selectedPost!.copyWith(
      title: titleCtrl.text,
      description: descriptionCtrl.text,
      authorName: authorNameCtrl.text,
      picture: pictureCtrl.text,
    );
    _http
        .put("posts/${selectedPost!.id}", data: updatedPost.toJson())
        .then((_) {
      titleCtrl.clear();
      descriptionCtrl.clear();
      authorNameCtrl.clear();
      pictureCtrl.clear();
      selectedPost = null;
      emit(PostSuccessState());
    }).catchError((error) {
      emit(PostErrorState(error.toString()));
    });
  }

  void deletePost() {
    if (selectedPost == null) {
      emit(PostErrorState("No post selected for deleting"));
      return;
    }
    _http.delete("posts/${selectedPost!.id}").then((_) {
      titleCtrl.clear();
      descriptionCtrl.clear();
      authorNameCtrl.clear();
      pictureCtrl.clear();
      selectedPost = null;
      emit(PostSuccessState());
    }).catchError((error) {
      emit(PostErrorState(error.toString()));
    });
  }

  void loadPosts() {
    emit(PostLoadingState());
    // Simulate a network call
    Future.delayed(Duration(seconds: 2), () {
      // Here you would typically fetch posts from an API
      emit(PostSuccessState());
    }).catchError((error) {
      emit(PostErrorState(error.toString()));
    });
  }
}

abstract class PostStates {}

class PostInitialState extends PostStates {}

class PostLoadingState extends PostStates {}

class PostSuccessState extends PostStates {}

class PostErrorState extends PostStates {
  final String error;

  PostErrorState(this.error);
}
