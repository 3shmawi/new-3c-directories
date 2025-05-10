import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDataItem extends StatelessWidget {
  const UserDataItem({
    required this.title,
    required this.icon,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: Colors.cyan,
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: "Merienda",
          ),
        ),
        trailing: const Icon(
          CupertinoIcons.chevron_forward,
          color: Colors.cyan,
        ),
      ),
    );
  }
}
