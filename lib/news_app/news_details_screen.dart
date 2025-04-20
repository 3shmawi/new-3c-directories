import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/news_app/news_model.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen(this.category, {super.key});

  final String category;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final dio = Dio();

  //https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=2fbf9799a7fb47c88f266c543fb36a78
  Future<List<Articles>> getNewsData() async {
    final response = await dio.get(
        "https://newsapi.org/v2/top-headlines?country=us&category=${widget.category}&apiKey=2fbf9799a7fb47c88f266c543fb36a78");
    if (response.statusCode == 200) {
      final data = NewsModel.fromJson(response.data);
      return data.articles!;
    } else {
      throw Exception("Failed to load news");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: FutureBuilder(
        future: getNewsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final articles = snapshot.data;
          if (articles == null || articles.isEmpty) {
            return Center(child: Text("No data found"));
          }
          return ListView.separated(
            padding: EdgeInsets.all(10),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return NewsItem(articles[index]);
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        },
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  const NewsItem(this.article, {super.key});

  final Articles article;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                    article.urlToImage ??
                        "https://gsp-image-cdn.wmsports.io/cms/prod/bleacher-report/2025-04/national_nba_play-in-tourney_24_bracket_3x2_720_0.png?w=3800&h=2000",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title ?? "Title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: Text(
                        article.description ??
                            article.content ??
                            "No description available",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            article.author ?? "Unknown",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          article.publishedAt ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
