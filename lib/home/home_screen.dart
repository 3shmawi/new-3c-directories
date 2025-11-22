import 'package:flutter/material.dart';

import '/home/widgets/chats_list_items.dart';
import '/home/widgets/search_bar.dart';
import '/home/widgets/stories_list_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
    );
  }
}
