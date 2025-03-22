import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/remote.dart';
import '../model/news.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());

  List<Articles> articles = [];

  final searchCtrl = TextEditingController();
  bool isSearchEnabled = true;

  void toggleSearchEnabled() {
    isSearchEnabled = !isSearchEnabled;
    emit(ToggleSearchState());
    // setState(() {
    //   isSearchEnabled = !isSearchEnabled;
    // });
  }

  void getNewsData() async {
    if (searchCtrl.text.isEmpty) {
      emit(NewsErrorState("please enter a search word"));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("please enter a search word"),
      //   ),
      // );
      return;
    }
    emit(NewsLoadingState());
    // setState(() {
    //   isLoading = true;
    // });

    try {
      final response = await APIHandler.getEverythingNews(
        word: searchCtrl.text,
        day: 10,
      );

      emit(NewsSuccessState(response.articles ?? []));
      // articles = response.articles ?? [];
    } catch (e) {
      emit(NewsErrorState(e.toString()));
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(e.toString()),
      //   ),
      // );
    }
    // finally {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }
}

abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsLoadingState extends NewsStates {}

class NewsSuccessState extends NewsStates {
  final List<Articles> articles;

  NewsSuccessState(this.articles);
}

class NewsErrorState extends NewsStates {
  final String error;

  NewsErrorState(this.error);
}

class ToggleSearchState extends NewsStates {}
