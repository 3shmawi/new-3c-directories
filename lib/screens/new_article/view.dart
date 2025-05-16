import 'package:flutter/material.dart';
import 'package:new_3c/models/article.dart';
import 'package:new_3c/screens/newsletter/components/newsletter_item.dart';

class NewArticleView extends StatelessWidget {
  const NewArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                                // controller: _model.textController1,
                                // focusNode: _model.textFieldFocusNode1,

                                autofocus: true,
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
                                // controller: _model.textController2,
                                // focusNode: _model.textFieldFocusNode2,

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
                                // controller: _model.textController3,
                                // focusNode: _model.textFieldFocusNode3,

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
                                // controller: _model.textController3,
                                // focusNode: _model.textFieldFocusNode3,

                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1800),
                                    lastDate: DateTime.now(),
                                  ).then((value) {});
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
                        child: Column(
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
                                // controller: _model.textController4,
                                // focusNode: _model.textFieldFocusNode4,

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
                                // controller: _model.textController5,
                                // focusNode: _model.textFieldFocusNode5,
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Author Name',
                                  hintText: 'Enter author name',
                                ),
                              ),
                            )
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
                                title: "title",
                                authorName: "authorName",
                                description: "description",
                                picture: "",
                                authorId: "authorId",
                                publishedAt: "publishedAt",
                                id: "id",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "CREATE ARTICLE",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
