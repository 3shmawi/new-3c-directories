import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl/layout_cubit.dart';
import 'package:new_3c/controller/user_ctrl/user_cubit.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<UserCubit>().updateUserStatus(true);
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        context.read<UserCubit>().updateUserStatus(false);
    }
  }

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
