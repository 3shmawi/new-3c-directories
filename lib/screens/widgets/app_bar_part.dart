import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/theme_ctrl.dart';

class AppBarPart extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPart({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text.rich(
        TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: "Jana",
              style: TextStyle(
                color: Colors.deepOrange,
              ),
            ),
            TextSpan(
              text: "News",
              style: TextStyle(
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
          ),
        ),

        BlocBuilder<ThemeCtrl, bool>(
          builder: (context, isDark) {
            final ctrl = context.read<ThemeCtrl>();
            return IconButton(
              onPressed: () {
                ctrl.toggleTheme();
              },
              icon: Icon(
               isDark? Icons.sunny: Icons.dark_mode_outlined,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
