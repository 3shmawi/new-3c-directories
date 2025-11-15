import 'package:flutter/material.dart';

void showAvatarPreviewDialog(
  BuildContext context, {
  required String avatarUrl,
  required String name,
  Key? key,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AvatarPreviewDialog(
        name: name,
        avatar: avatarUrl,
        key: key,
      );
    },
  );
}

class AvatarPreviewDialog extends StatelessWidget {
  const AvatarPreviewDialog({
    required this.name,
    required this.avatar,
    super.key,
  });

  final String name;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      content: Stack(
        children: [
          Hero(
            tag: key ?? UniqueKey(),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.black12,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.chat),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.phone),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.video_call_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.info),
        ),
      ],
    );
  }
}
