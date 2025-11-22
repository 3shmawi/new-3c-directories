import 'package:flutter/material.dart';

import '/home/widgets/app_bar_item.dart';
import '/home/widgets/bottom_nav_item.dart';
import '/home/widgets/chats_list_items.dart';
import '/home/widgets/search_bar.dart';
import '/home/widgets/stories_list_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLocalized,
      builder: (context, value, child) {
        return Directionality(
          textDirection: value ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBarItem(),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CustomSearchBar(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                    child: StoriesListItems(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverFillRemaining(
                  child: ChatsListItems(),
                ),
              ],
            ),
            bottomNavigationBar: const BottomNavItem(),
          ),
        );
      },
    );
  }
}
