import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/models/user_notice.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/screens/group_in_apply.dart';
import 'package:works_book_user_app/screens/notice_details.dart';
import 'package:works_book_user_app/screens/plan_details.dart';
import 'package:works_book_user_app/services/user_in_apply.dart';
import 'package:works_book_user_app/widgets/custom_circle_avatar.dart';
import 'package:works_book_user_app/widgets/custom_main_button.dart';
import 'package:works_book_user_app/widgets/custom_persistent_tab_view.dart';
import 'package:works_book_user_app/widgets/link_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserInApplyService userInApplyService = UserInApplyService();
  PersistentTabController? controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  void _showPlanDetails(Appointment plan) {
    showBottomUpScreen(
      context,
      PlanDetailsScreen(plan: plan),
    );
  }

  void _showNoticeDetails(UserNoticeModel notice) {
    showBottomUpScreen(
      context,
      NoticeDetailsScreen(notice: notice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    UserModel? user = userProvider.user;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: userInApplyService.streamList(userId: user?.id),
      builder: (context, snapshot) {
        UserInApplyModel? userInApply;
        if (snapshot.hasData) {
          userInApply =
              UserInApplyModel.fromSnapshot(snapshot.data!.docs.first);
        }
        Widget body = Container();
        if (userInApply == null) {
          body = UserInApplyWidget(
            onPressed: () => showBottomUpScreen(
              context,
              const GroupInApplyScreen(),
            ),
          );
        } else {
          if (!userInApply.accept) {
            body = UserInApplyWaitWidget(
              userInApply: userInApply,
              onTap: () async {
                userInApplyService.delete({
                  'id': userInApply?.id,
                });
              },
            );
          } else {
            body = CustomPersistentTabView(
              context: context,
              controller: controller,
              screens: [
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
                  icon: const Icon(Icons.wechat),
                  title: 'チャット',
                  activeColorPrimary: kBaseColor,
                  inactiveColorPrimary: kGrey2Color,
                ),
              ],
            );
          }
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(user?.name ?? ''),
            actions: [
              CustomCircleAvatar(
                image: '',
                onTap: () {},
              ),
            ],
          ),
          body: body,
        );
      },
    );
  }
}

class UserInApplyWidget extends StatelessWidget {
  final Function()? onPressed;

  const UserInApplyWidget({
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Column(
              children: [
                Text(
                  'あなたは会社に所属してません',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '会社への所属申請を行ってください。会社へ所属していないと、このアプリは利用できません。',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: CustomMainButton(
                label: '会社へ所属申請を送る',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInApplyWaitWidget extends StatelessWidget {
  final UserInApplyModel? userInApply;
  final Function()? onTap;

  const UserInApplyWaitWidget({
    this.userInApply,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  '所属申請を送信しました',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${userInApply?.groupName}へ所属申請を送信しました。承認されるまで今しばらくお待ちください。',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            LinkText(
              label: '所属申請を取り消す',
              labelColor: kRedColor,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
