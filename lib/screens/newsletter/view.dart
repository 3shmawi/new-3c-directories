import 'package:flutter/material.dart';
import 'package:new_3c/models/article.dart';
import 'package:new_3c/screens/newsletter/components/newsletter_item.dart';

class NewsletterView extends StatelessWidget {
  const NewsletterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: ListView.separated(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) => ArticleItemWidget(
          article: ArticleModel(
            title:
                "title sadfjlk alsdfkj;alskdf als;dkjf;lasdkjf ;alsdfj k;asldkfj a;s",
            authorName: "authorName",
            description:
                "description l;aksjdf;l kalsdkfj la;skdfja sl;dfka sdlfkjasdlfkasdlkf asd;lfkjalsdkf ja;sldkf jasfalskdfj ;askdfja sdlfkajs;dfl kjasldfkjas fd",
            picture: "",
            authorId: "authorId",
            publishedAt: "publishedAt",
            id: "id",
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        itemCount: 4,
      ),
    );
  }
}
