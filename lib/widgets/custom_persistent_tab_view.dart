import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:works_book_user_app/common/style.dart';

class CustomPersistentTabView extends StatelessWidget {
  final BuildContext context;
  final PersistentTabController? controller;
  final List<Widget> screens;
  final List<PersistentBottomNavBarItem>? items;

  const CustomPersistentTabView({
    required this.context,
    this.controller,
    required this.screens,
    this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller,
      screens: screens,
      items: items,
      decoration: const NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: kGrey2Color,
            blurRadius: 8,
          ),
        ],
      ),
      backgroundColor: kWhiteColor,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
