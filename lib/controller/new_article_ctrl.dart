import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/article.dart';
import 'package:new_3c/services/dio_helper.dart';

class NewArticleCtrl extends Cubit<NewArticleStates> {
  NewArticleCtrl() : super(NewArticleInitialState());
  final titleCtrl = TextEditingController();
  final desCtrl = TextEditingController();
  final imgUrlCtrl = TextEditingController();
  final authorNameCtrl = TextEditingController();

  final _http = HttpUtil();

  void createNewArticle() {
    if (isFormsEmpty()) {
      emit(NewArticleErrorState("The fields are empty"));
      return;
    }
    emit(NewArticleLoadingState());
    final newArticle = Article(
      id: DateTime.now().hashCode,
      title: titleCtrl.text,
      description: desCtrl.text,
      picture: imgUrlCtrl.text,
      publishedAt: DateTime.now().toIso8601String(),
      authorName: authorNameCtrl.text,
      authorId: "2",
    );

    _http.post("posts", data: newArticle.toJson()).then((value) {
      emit(NewArticleSuccessState("Article created successfully"));
      clearFields();
    }).catchError((error) {
      emit(NewArticleErrorState(error.toString()));
    });
  }

  bool isFormsEmpty() =>
      titleCtrl.text.isEmpty ||
      desCtrl.text.isEmpty ||
      imgUrlCtrl.text.isEmpty ||
      authorNameCtrl.text.isEmpty;

  void clearFields() {
    titleCtrl.clear();
    desCtrl.clear();
    imgUrlCtrl.clear();
    authorNameCtrl.clear();
  }
}

abstract class NewArticleStates {}

class NewArticleInitialState extends NewArticleStates {}

class NewArticleLoadingState extends NewArticleStates {}

class NewArticleSuccessState extends NewArticleStates {
  final String message;

  NewArticleSuccessState(this.message);
}

class NewArticleErrorState extends NewArticleStates {
  final String error;

  NewArticleErrorState(this.error);
}
