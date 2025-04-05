import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/cubit/news.dart';
import 'package:new_3c/cubit/theme.dart';
import 'package:new_3c/screens/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsHomeScreen extends StatelessWidget {
  const NewsHomeScreen({super.key});

  // bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, isDark) {
              return IconButton(
                onPressed: context.read<ThemeCubit>().toggleTheme,
                icon: Icon(
                  isDark
                      ? CupertinoIcons.lightbulb_slash_fill
                      : CupertinoIcons.lightbulb_fill,
                  color: !isDark ? Colors.grey : Colors.yellow,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsCubit, NewsStates>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<NewsCubit, NewsStates>(
                  buildWhen: (_, current) => current is ToggleSearchState,
                  builder: (context, state) {
                    final cubit = context.read<NewsCubit>();
                    return AnimatedCrossFade(
                      firstChild: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: cubit.searchCtrl,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  hintText: 'Search for news',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: cubit.getNewsData,
                            ),
                          ],
                        ),
                      ),
                      secondChild: SizedBox.shrink(),
                      crossFadeState: cubit.isSearchEnabled
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: BlocBuilder<NewsCubit, NewsStates>(
                      buildWhen: (_, current) =>
                          current is NewsLoadingState ||
                          current is NewsSuccessState ||
                          current is NewsErrorState ||
                          current is NewsEmptyState,
                      builder: (context, state) {
                        switch (state) {
                          case NewsEmptyState():
                            return Center(
                              child: Text("no articles founded"),
                            );
                          case NewsLoadingState():
                            return Skeletonizer(
                              enabled: true,
                              child: ListView.separated(
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return NewsItem(isLoading: true);
                                },
                                separatorBuilder: (context, index) => Divider(),
                              ),
                            );
                          case NewsSuccessState():
                            return ListView.separated(
                              itemCount: state.articles.length,
                              itemBuilder: (context, index) {
                                return NewsItem(
                                  articles: state.articles[index],
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            );

                          case NewsErrorState():
                            return Center(
                              child: Text(state.error),
                            );
                        }

                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<NewsCubit>().toggleSearchEnabled,
        child: Icon(Icons.search),
      ),
    );
  }
}
