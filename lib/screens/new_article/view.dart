import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/colors.dart';
import 'package:new_3c/app/toast.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/controller/layout_ctrl.dart';
import 'package:new_3c/controller/new_article_ctrl.dart';

class NewArticleView extends StatefulWidget {
  const NewArticleView({super.key});

  @override
  State<NewArticleView> createState() => _NewArticleViewState();
}

class _NewArticleViewState extends State<NewArticleView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewArticleCtrl(),
      child: BlocConsumer<NewArticleCtrl, NewArticleStates>(
        listener: (context, state) {
          switch (state) {
            case NewArticleSuccessState():
              AppToast.showSuccess(state.message);
              context.read<LayoutCtrl>().changeIndex(0);
            case NewArticleErrorState():
              AppToast.showError(state.error);
          }
        },
        builder: (context, state) {
          final ctrl = context.read<NewArticleCtrl>();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    "Create new article",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  TextFormField(
                    controller: ctrl.titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter the title of the article',
                    ),
                  ),
                  TextFormField(
                    controller: ctrl.imgUrlCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Image url',
                      hintText: 'https://example.....',
                    ),
                  ),
                  TextFormField(
                    controller: ctrl.authorNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Author name',
                    ),
                  ),
                  TextFormField(
                    controller: ctrl.desCtrl,
                    minLines: 4,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter the description of the article',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is NewArticleLoadingState
                        ? null
                        : () {
                            final authorId =
                                context.read<AuthCtrl>().authorModel?.id;
                            if (authorId == null) {
                              AppToast.showError("You must login first!");
                              return;
                            }
                            ctrl.createNewArticle(authorId);
                          },
                    child: Text("Submit"),
                  ),
                  if (state is NewArticleLoadingState)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const LinearProgressIndicator(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
