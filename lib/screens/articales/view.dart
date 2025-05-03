import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/articles_ctrl.dart';
import 'package:new_3c/screens/articales/components/item.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticlesCtrl()..getArticles(),
      child: BlocBuilder<ArticlesCtrl, ArticlesStates>(
        builder: (context, state) {
          switch (state) {
            case ArticlesLoadingState():
              return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return NewsItem(
                    isLoading: true,
                  );
                },
              );
            case ArticlesErrorState():
              return Center(
                child: Text(state.error),
              );

            case ArticlesSuccessState():
              if (state.articles.isEmpty) {
                return EmptyData();
              }
              return ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return NewsItem(
                    article: article,
                    isLoading: false,
                  );
                },
              );
          }
          return SafeArea(
            child: Text(
              'Article View',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          );
        },
      ),
    );
  }
}
