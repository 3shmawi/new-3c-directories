import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/models/article.dart';

import '../services/dio_helper.dart';

class ArticlesCtrl extends Cubit<ArticlesStates> {
  ArticlesCtrl() : super(ArticlesInitialState());

  final _http = HttpUtil();

  void getArticles() {
    emit(ArticlesLoadingState());
    _http.get("posts").then((value) {
      final articles = (value as List).map((e) => Article.fromJson(e)).toList();
      emit(ArticlesSuccessState(articles));
    }).catchError((error) {
      emit(ArticlesErrorState(error.toString()));
    });
  }
}

abstract class ArticlesStates {}

class ArticlesInitialState extends ArticlesStates {}

class ArticlesLoadingState extends ArticlesStates {}

class ArticlesSuccessState extends ArticlesStates {
  final List<Article> articles;

  ArticlesSuccessState(this.articles);
}

class ArticlesErrorState extends ArticlesStates {
  final String error;

  ArticlesErrorState(this.error);
}
