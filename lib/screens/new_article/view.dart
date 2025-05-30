import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/toast.dart';
import 'package:new_3c/controller/article_ctrl.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/controller/layout_ctrl.dart';
import 'package:new_3c/models/article.dart';
import 'package:new_3c/screens/newsletter/components/newsletter_item.dart';

class NewArticleView extends StatefulWidget {
  const NewArticleView({super.key});

  @override
  State<NewArticleView> createState() => _NewArticleViewState();
}

class _NewArticleViewState extends State<NewArticleView> {
  final authorId = TextEditingController();
  final authorName = TextEditingController();

  void initAuthorData() {
    if (mounted) {
      final user = context.read<AuthCtrl>().user;
      if (user != null) {
        authorId.text = user.id;
        authorName.text = user.name;
      } else {
        authorId.text = "Unknown";
        authorName.text = "Unknown";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<ArticleCtrl, ArticleStates>(
      listener: (context, state) {
        if (state is ArticleSuccessState) {
          AppToast.showSuccess("Article created successfully");

          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
          context.read<LayoutCtrl>().changeBottomNavBar(0);
        } else if (state is ArticleErrorState) {
          AppToast.showError(state.message);
        }
      },
      builder: (context, state) {
        final articleCtrl = ArticleCtrl.get(context);
        initAuthorData();

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              automaticallyImplyLeading: false,
              title: Text(
                'Create New Post',
                style: theme.textTheme.titleLarge,
              ),
              elevation: 0,
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0x1A000000),
                                offset: Offset(
                                  0,
                                  2,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              spacing: 10,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Post Information',
                                  style: theme.textTheme.titleMedium,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: articleCtrl.titleCtrl,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: 'Enter post title',
                                      filled: true,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: articleCtrl.descriptionCtrl,
                                    textInputAction: TextInputAction.next,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Enter post description',
                                    ),
                                    maxLines: 5,
                                    minLines: 4,
                                    keyboardType: TextInputType.multiline,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: articleCtrl.pictureCtrl,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: 'Enter image URL',
                                      filled: true,
                                    ),
                                    keyboardType: TextInputType.url,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: articleCtrl.dateCtrl,
                                    // focusNode: _model.textFieldFocusNode3,

                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        firstDate: DateTime(1800),
                                        lastDate: DateTime.now(),
                                      ).then((value) {
                                        if (value != null) {
                                          articleCtrl.dateCtrl.text =
                                              value.toIso8601String();
                                        }
                                      });
                                    },
                                    readOnly: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      hintText: 'Select Post Date',
                                      filled: true,
                                    ),

                                    keyboardType: TextInputType.url,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0x1A000000),
                                offset: Offset(
                                  0,
                                  2,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: BlocBuilder<AuthCtrl, AuthStates>(
                              builder: (context, state) {
                                if (state is AuthLoadingState) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is AuthErrorState) {
                                  return Center(
                                    child: Text(
                                      state.error,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.red),
                                    ),
                                  );
                                }
                                initAuthorData();
                                return Column(
                                  spacing: 10,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Author Information',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: authorId,
                                        textInputAction: TextInputAction.next,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          labelText: 'Author ID',
                                          hintText: 'Enter author ID',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: authorName,
                                        readOnly: true,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: 'Author Name',
                                          hintText: 'Enter author name',
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Color(0x1A000000),
                                offset: Offset(
                                  0,
                                  2,
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Preview',
                                  style: theme.textTheme.titleMedium,
                                ),
                                ArticleItemWidget(
                                  article: ArticleModel(
                                    title: articleCtrl.titleCtrl.text,
                                    authorName: authorName.text,
                                    description:
                                        articleCtrl.descriptionCtrl.text,
                                    picture: articleCtrl.pictureCtrl.text,
                                    authorId: authorId.text,
                                    publishedAt: articleCtrl.dateCtrl.text,
                                    id: "",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: state is ArticleLoadingState
                                  ? null
                                  : () {
                                      if (articleCtrl.editedArticle != null) {
                                        articleCtrl.updateArticle();
                                        return;
                                      }
                                      articleCtrl.createArticle(
                                        authorId: authorId.text,
                                        authorName: authorName.text,
                                      );
                                    },
                              child: Text(
                                articleCtrl.editedArticle != null
                                    ? "EDIT ARTICLE"
                                    : "CREATE ARTICLE",
                              ),
                            ),
                            if (state is ArticleLoadingState)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LinearProgressIndicator(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
