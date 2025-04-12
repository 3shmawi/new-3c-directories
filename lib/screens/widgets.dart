import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_3c/model/news.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({this.articles, this.isLoading = false, super.key});

  final Articles? articles;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: isLoading
          ? null
          : () async {
              final url = Uri.parse(articles?.url ?? "");
              if (!await launchUrl(
                url,
                browserConfiguration:
                    const BrowserConfiguration(showTitle: true),
              )) {
                throw Exception('Could not launch $url');
              }
            },
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: IntrinsicHeight(
          //calculate the height of the child
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: isLoading
                    ? "https://images.unsplash.com/photo-1740832780965-0982fb5dd8d8?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzfHx8ZW58MHx8fHx8"
                    : articles?.urlToImage ??
                        "https://images.unsplash.com/photo-1740832780965-0982fb5dd8d8?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwzfHx8ZW58MHx8fHx8",
                height: 158,
                width: 110,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLoading
                            ? "####################"
                            : articles?.title ?? "Title",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: Text(
                          isLoading
                              ? "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
                              : articles?.content ??
                                  articles?.description ??
                                  "No Description! or Content!",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              isLoading
                                  ? "&&&&&&&&&&&&&&&&&&&"
                                  : articles?.author ?? "",
                              maxLines: 1,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isLoading
                                ? "*******************"
                                : articles?.publishedAt ?? "",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyData extends StatelessWidget {
  const EmptyData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/animation/empty.json", height: 300),
        const SizedBox(height: 20),
        Text(
          "No articles found!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyan,
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}
