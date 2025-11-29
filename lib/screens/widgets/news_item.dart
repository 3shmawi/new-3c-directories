import 'package:flutter/material.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //image
          Image.asset(
            "assets/images/testt.png",
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 8,
              children: [
                //title
                Text(
                  "Title laskdjflas dkflaksd jf;laskdfj ;alskdfjalskdf lasdkfj laskdjf lasdkf laskd jfl;askjd lfkasdfj laskdfj ;laskdfj; alskdfj;laskdfj a;lsdfk ",
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
                      "Jana",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                //desc
                Text(
                  "Description laskdjflaskd fa;lskd fjlaskdf jlaskdjf laskjf laskdfj;laskd fjlaskdfj alsdkfj laskdfj alskdjf l;asdkjf al;sdkjf laskdjf las;kdjf lasdkjf l;askdjf l;asdkjf la;skdjf als;dfjkasljf ",
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
