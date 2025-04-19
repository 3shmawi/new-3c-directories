import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl/layout_cubit.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutStates>(
      builder: (context, state) {
        final cubit = layoutCubit(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "ISLAM<CHAT/>",
              style: TextStyle(fontFamily: "Merienda"),
            ),
            centerTitle: false,
          ),
          body: PageView.builder(
            controller: cubit.pageCtrl,
            itemBuilder: (context, index) => cubit.pages[index],
            itemCount: cubit.pages.length,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: cubit.changeLayout,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.cyan[800],
            unselectedItemColor: Colors.grey[400],
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_2),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.group),
                label: "Users",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.settings),
                label: "Settings",
              ),
            ],
          ),
        );
      },
    );
  }
}
