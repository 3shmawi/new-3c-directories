import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/article_ctrl.dart';
import 'package:new_3c/controller/layout_ctrl.dart';
import 'package:new_3c/models/article.dart';

class ArticleOptions extends StatelessWidget {
  const ArticleOptions(this.articleModel, {super.key});

  final ArticleModel articleModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Title(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Choose an action',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.edit, color: Theme.of(context).primaryColor),
          title: Text('Edit Article',
              style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {
            context.read<ArticleCtrl>().initializeControllers(articleModel);
            context.read<LayoutCtrl>().changeBottomNavBar(1);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text('Delete Article',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red)),
          onTap: () {
            context.read<ArticleCtrl>().deleteArticle(articleModel.id);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
