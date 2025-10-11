import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_3c/home/widgets/chats_list_items.dart';
import 'package:new_3c/home/widgets/search_bar.dart';
import 'package:new_3c/home/widgets/stories_list_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messenger",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.camera_alt,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomSearchBar(),
          ),
          SliverToBoxAdapter(
              child: SizedBox(height: 100, child: StoriesListItems())),
          SliverToBoxAdapter(child: Divider()),
          SliverFillRemaining(
            child: ChatsListItems(),
          ),
        ],
      ),
      bottomNavigationBar:
          BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.group), label: "Users"),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_stack_3d_down_right),
            label: "Stories"),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled), label: "Profile"),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings), label: "Settings"),
      ]),
    );
  }
}
