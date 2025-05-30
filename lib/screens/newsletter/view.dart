import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/article_ctrl.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/screens/newsletter/components/article_options.dart';
import 'package:new_3c/screens/newsletter/components/newsletter_item.dart';

class NewsletterView extends StatelessWidget {
  const NewsletterView({super.key});

  @override
  Widget build(BuildContext context) {
    final myId = AuthCtrl.get(context).myId;
    return SafeArea(
      top: true,
      child: BlocBuilder<ArticleCtrl, ArticleStates>(
        builder: (context, state) {
          if (state is ArticleLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ArticleErrorState) {
            return Center(
              child: Text(
                state.message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.red),
              ),
            );
          }
          final articles = ArticleCtrl.get(context).articles;
          if (articles.isEmpty) {
            return Center(
              child: Text(
                "No articles available",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey),
              ),
            );
          }

          final sortedArticles = List.of(articles)
            ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
          return ListView.separated(
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) => InkWell(
              onLongPress: myId == sortedArticles[index].authorId
                  ? () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              ArticleOptions(sortedArticles[index]));
                    }
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: ArticleItemWidget(
                article: sortedArticles[index],
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemCount: articles.length,
          );
        },
      ),
    );
  }
}
