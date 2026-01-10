import 'package:flutter/material.dart';
import 'package:new_3c/models/post_model.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({required this.postModel,super.key});
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //image
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.network(
              postModel.picture??"assets/images/testt.png",
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Text(
                  postModel.title??"No title",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ), //profile info
                Row(
                  spacing: 5,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black,
                    ),
                    Text(
                      postModel.authorName??"None",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                //desc
                Text(
                  postModel.description??"No description",
                  maxLines: 3,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
