import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/cubit/news.dart';
import 'package:new_3c/cubit/theme.dart';
import 'package:new_3c/screens/widgets.dart';

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  State<NewsHomeScreen> createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  // bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        actions: [
          IconButton(
            onPressed: context.read<ThemeCubit>().toggleTheme,
            icon: Icon(Icons.dark_mode_outlined),
          ),
        ],
      ),
      body: BlocBuilder<NewsCubit, NewsStates>(
        builder: (context, state) {
          final cubit = context.read<NewsCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedCrossFade(
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
                ),
                state is NewsLoadingState
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : state is NewsSuccessState
                        ? state.articles.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Text("no articles founded"),
                                ),
                              )
                            : Expanded(
                                child: ListView.separated(
                                  itemCount: state.articles.length,
                                  itemBuilder: (context, index) {
                                    return NewsItem(state.articles[index]);
                                  },
                                  separatorBuilder: (context, index) =>
                                      Divider(),
                                ),
                              )
                        : state is NewsErrorState
                            ? Expanded(
                                child: Center(
                                  child: Text(state.error),
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: Text("please enter a search word"),
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
