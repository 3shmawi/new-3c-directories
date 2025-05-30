import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/article.dart';

import '../services/dio_helper.dart';

class ArticleCtrl extends Cubit<ArticleStates> {
  ArticleCtrl() : super(ArticleInitialState());

  static ArticleCtrl get(context) => BlocProvider.of(context);

  final _http = HttpUtil();
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final pictureCtrl = TextEditingController();
  final dateCtrl = TextEditingController();

  ArticleModel? editedArticle;

  void initializeControllers(ArticleModel article) {
    editedArticle = article;
    titleCtrl.text = article.title;
    descriptionCtrl.text = article.description;
    pictureCtrl.text = article.picture;
    dateCtrl.text = article.publishedAt;
  }

  void createArticle({String? authorId, String? authorName}) {
    if (titleCtrl.text.isEmpty ||
        descriptionCtrl.text.isEmpty ||
        pictureCtrl.text.isEmpty ||
        dateCtrl.text.isEmpty ||
        authorId == null ||
        authorName == null ||
        authorId.isEmpty ||
        authorName.isEmpty) {
      emit(ArticleErrorState("Please fill in all fields"));
      return;
    }
    final newArticle = ArticleModel(
      id: "",
      title: titleCtrl.text,
      authorName: authorName,
      description: descriptionCtrl.text,
      picture: pictureCtrl.text,
      authorId: authorId,
      publishedAt: dateCtrl.text,
    );
    emit(ArticleLoadingState());
    _http.post("posts", data: newArticle.toJson()).then((response) {
      final article = ArticleModel.fromJson(response);
      articles.add(article);
      emit(ArticleSuccessState());
    }).catchError((error) {
      emit(ArticleErrorState(error.toString()));
    });
  }

  void updateArticle() {
    if (editedArticle == null) {
      emit(ArticleErrorState("No article selected for editing"));
      return;
    }
    if (titleCtrl.text.isEmpty ||
        descriptionCtrl.text.isEmpty ||
        pictureCtrl.text.isEmpty ||
        dateCtrl.text.isEmpty) {
      emit(ArticleErrorState("Please fill in all fields"));
      return;
    }
    final updatedArticle = ArticleModel(
      id: editedArticle!.id,
      title: titleCtrl.text,
      authorName: editedArticle!.authorName,
      description: descriptionCtrl.text,
      picture: pictureCtrl.text,
      authorId: editedArticle!.authorId,
      publishedAt: dateCtrl.text,
    );
    emit(ArticleLoadingState());
    _http
        .put("posts/${editedArticle!.id}", data: updatedArticle.toJson())
        .then((response) {
      final index = articles.indexWhere((a) => a.id == editedArticle!.id);
      if (index != -1) {
        articles[index] = ArticleModel.fromJson(response);
      }
      emit(ArticleSuccessState());
    }).catchError((error) {
      emit(ArticleErrorState(error.toString()));
    });
  }

  void deleteArticle(String articleId) {
    emit(ArticleLoadingState());
    _http.delete("posts/$articleId").then((_) {
      articles.removeWhere((a) => a.id == articleId);
      emit(ArticleSuccessState());
    }).catchError((error) {
      emit(ArticleErrorState(error.toString()));
    });
  }

  List<ArticleModel> articles = [];

  void getArticles() async {
    emit(ArticleLoadingState());
    try {
      final response = await _http.get("posts");
      articles = (response as List)
          .map((article) => ArticleModel.fromJson(article))
          .toList();
      emit(ArticleSuccessState());
    } catch (error) {
      emit(ArticleErrorState(error.toString()));
    }
  }
}

abstract class ArticleStates {}

class ArticleInitialState extends ArticleStates {}

class ArticleLoadingState extends ArticleStates {}

class ArticleSuccessState extends ArticleStates {}

class ArticleErrorState extends ArticleStates {
  final String message;

  ArticleErrorState(this.message);
}
