import 'package:flutter/material.dart';
import 'package:new_3c/model/news.dart';
import 'package:new_3c/screens/widgets.dart';

import '../data/remote.dart';

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  State<NewsHomeScreen> createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  final searchCtrl = TextEditingController();

  bool isSearchEnabled = true;

  void toggleSearchEnabled() {
    setState(() {
      isSearchEnabled = !isSearchEnabled;
    });
  }

  bool isLoading = false;
  List<Articles> articles = [];

  void getNewsData() async {
    if (searchCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("please enter a search word"),
        ),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await APIHandler.getEverythingNews(
      word: searchCtrl.text,
      day: 10,
    );

    articles = response.articles ?? [];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSearchEnabled)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchCtrl,
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
                    onPressed: getNewsData,
                  ),
                ],
              ),
            isLoading
                ? Expanded(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : articles.isEmpty
                    ? Expanded(
                        child: Center(
                        child: Text("no articles founded"),
                      ))
                    : Expanded(
                        child: ListView.separated(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return NewsItem(articles[index]);
                          },
                          separatorBuilder: (context, index) => Divider(),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleSearchEnabled,
        child: Icon(Icons.search),
      ),
    );
  }
}
