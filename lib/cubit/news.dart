import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/remote.dart';
import '../model/news.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  final searchCtrl = TextEditingController();
  bool isSearchEnabled = true;

  void toggleSearchEnabled() {
    isSearchEnabled = !isSearchEnabled;
    emit(ToggleSearchState());
  }

  void getNewsData() async {
    if (searchCtrl.text.isEmpty) {
      emit(NewsErrorState("please enter a search word"));
      return;
    }
    emit(NewsLoadingState());

    try {
      final response = await APIHandler.getEverythingNews(
        word: searchCtrl.text,
      );

      final articles = response.articles ?? [];
      if (articles.isNotEmpty) {
        emit(NewsSuccessState(articles));
      } else {
        emit(NewsEmptyState());
      }
    } catch (e) {
      emit(NewsErrorState(e.toString()));
    }
  }
}

abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsLoadingState extends NewsStates {}

class NewsEmptyState extends NewsStates {}

class NewsSuccessState extends NewsStates {
  final List<Articles> articles;

  NewsSuccessState(this.articles);
}

class NewsErrorState extends NewsStates {
  final String error;

  NewsErrorState(this.error);
}

class ToggleSearchState extends NewsStates {}
