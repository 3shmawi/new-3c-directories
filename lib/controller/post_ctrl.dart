import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/services/dio_helper.dart';

import '../models/post.dart';
import '../services/local_storage.dart';

class PostCtrl extends Cubit<PostStates> {
  PostCtrl() : super(PostInitialState());

  static PostCtrl get(context) => BlocProvider.of<PostCtrl>(context);

  PostModel? selectedPost;
  String? myId;

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final authorNameCtrl = TextEditingController();
  final pictureCtrl = TextEditingController();

  void onImageUrlChanged(String url) {
    pictureCtrl.text = url;
    emit(PreviewPictureState());
  }

  final _http = HttpUtil();

  void createPost() async {
    emit(PostLoadingState());
    final box = await HiveService().openBox("myUserData");
    myId = box.get("myId", defaultValue: null);
    if (myId == null) {
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

    if (selectedPost != null) {
      editPost();
      return;
    }
    final newPost = PostModel(
      authorName: authorNameCtrl.text,
      picture: pictureCtrl.text,
      title: titleCtrl.text,
      publishedAt: DateTime.now().toIso8601String(),
      description: descriptionCtrl.text,
      authorId: myId!,
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
      loadPosts();
    }).catchError((error) {
      emit(PostErrorState(error.toString()));
    });
  }

  List<PostModel> posts = [];

  void loadPosts() async {
    emit(PostLoadingState());
    if (myId == null) {
      final box = await HiveService().openBox("myUserData");
      myId = box.get("myId", defaultValue: null);
    }
    try {
      final response = await _http.get("posts");
      posts = (response as List).map((e) => PostModel.fromJson(e)).toList();
      posts.sort(
        (a, b) => DateTime.parse(b.publishedAt)
            .compareTo(DateTime.parse(a.publishedAt)),
      );
      emit(PostSuccessState());
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  void selectPost(PostModel post) {
    selectedPost = post;
    titleCtrl.text = post.title;
    descriptionCtrl.text = post.description;
    authorNameCtrl.text = post.authorName;
    pictureCtrl.text = post.picture;
    emit(SelectedPostState(post));
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

class PreviewPictureState extends PostStates {}

class SelectedPostState extends PostStates {
  final PostModel post;

  SelectedPostState(this.post);
}
