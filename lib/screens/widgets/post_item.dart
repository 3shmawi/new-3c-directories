import 'package:flutter/material.dart';
import 'package:new_3c/models/post.dart';

class PostItem extends StatelessWidget {
  const PostItem({this.post, super.key});

  final PostModel? post;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: NetworkImage(
              post?.picture ?? "https://picsum.photos/200/300",
            ),
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post?.title ?? "Title ==========",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 5,
                ),
                Text(
                  post?.description ??
                      "===== == == = = ==  == ==== === = = = == == =  ==  = = = = === = = = = = == = = = = = = = == = = = = = = =  ==",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        post?.authorName ?? "Author Name",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post?.publishedAt ?? "+++++++++++++++++",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
