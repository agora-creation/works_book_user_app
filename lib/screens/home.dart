import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/widgets/custom_circle_avatar.dart';
import 'package:works_book_user_app/widgets/custom_persistent_tab_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController? controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(userProvider.user?.name ?? ''),
        actions: [
          CustomCircleAvatar(
            image: '',
            onTap: () {},
          ),
        ],
      ),
      body: CustomPersistentTabView(
        context: context,
        controller: controller,
        screens: [
          Container(),
          Container(),
          Container(),
        ],
        items: [
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.view_day),
            title: 'スケジュール',
            activeColorPrimary: kBaseColor,
            inactiveColorPrimary: kGrey2Color,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.notifications),
            title: 'お知らせ',
            activeColorPrimary: kBaseColor,
            inactiveColorPrimary: kGrey2Color,
          ),
          PersistentBottomNavBarItem(
            icon: const Icon(Icons.wechat),
            title: 'チャット',
            activeColorPrimary: kBaseColor,
            inactiveColorPrimary: kGrey2Color,
          ),
        ],
      ),
    );
  }
}
