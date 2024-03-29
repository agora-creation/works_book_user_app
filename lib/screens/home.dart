import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/screens/group_chat.dart';
import 'package:works_book_user_app/screens/group_chat_select.dart';
import 'package:works_book_user_app/screens/group_in_apply.dart';
import 'package:works_book_user_app/screens/group_notice.dart';
import 'package:works_book_user_app/screens/group_setting.dart';
import 'package:works_book_user_app/screens/plan_add.dart';
import 'package:works_book_user_app/screens/plan_details.dart';
import 'package:works_book_user_app/screens/schedule.dart';
import 'package:works_book_user_app/screens/user.dart';
import 'package:works_book_user_app/screens/user_chat.dart';
import 'package:works_book_user_app/screens/user_notice.dart';
import 'package:works_book_user_app/screens/user_setting.dart';
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

  void _showPlanAdd(UserInApplyModel userInApply) {
    showBottomUpScreen(
      context,
      PlanAddScreen(userInApply: userInApply),
    );
  }

  void _showPlanDetail(UserInApplyModel userInApply, Appointment plan) {
    showBottomUpScreen(
      context,
      PlanDetailsScreen(userInApply: userInApply, plan: plan),
    );
  }

  void _showGroupChat(UserInApplyModel userInApply) {
    pushScreen(
      context,
      GroupChatScreen(userInApply: userInApply),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: userInApplyService.streamId(
        userId: userProvider.user?.id,
      ),
      builder: (context, snapshot) {
        Widget body = Container();
        UserInApplyModel? userInApply;
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            userInApply = UserInApplyModel.fromSnapshot(
              snapshot.data!.docs.first,
            );
          }
        }
        if (userInApply == null) {
          body = UserInApplyWidget(
            onPressed: () => showBottomUpScreen(
              context,
              const GroupInApplyScreen(),
            ),
          );
        } else if (!userInApply.accept) {
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
            screens: userInApply.admin
                ? [
                    ScheduleScreen(
                      userInApply: userInApply,
                      showPlanAdd: _showPlanAdd,
                      showPlanDetail: _showPlanDetail,
                    ),
                    GroupChatSelectScreen(
                      userInApply: userInApply,
                      showGroupChat: _showGroupChat,
                    ),
                    UserScreen(
                      userInApply: userInApply,
                    ),
                  ]
                : [
                    ScheduleScreen(
                      userInApply: userInApply,
                      showPlanAdd: _showPlanAdd,
                      showPlanDetail: _showPlanDetail,
                    ),
                    UserChatScreen(
                      userInApply: userInApply,
                    ),
                  ],
            items: userInApply.admin
                ? [
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
                    PersistentBottomNavBarItem(
                      icon: const Icon(Icons.supervisor_account),
                      title: 'スタッフ',
                      activeColorPrimary: kBaseColor,
                      inactiveColorPrimary: kGrey2Color,
                    ),
                  ]
                : [
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
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: GestureDetector(
              onTap: () => showBottomUpScreen(
                context,
                const UserSettingScreen(),
              ),
              child: Text(userProvider.user?.name ?? ''),
            ),
            actions: userInApply != null && userInApply.accept
                ? [
                    userInApply.admin
                        ? IconButton(
                            onPressed: () => showBottomUpScreen(
                              context,
                              GroupNoticeScreen(userInApply: userInApply!),
                            ),
                            icon: const Icon(Icons.edit_notifications),
                          )
                        : IconButton(
                            onPressed: () => showBottomUpScreen(
                              context,
                              UserNoticeScreen(userInApply: userInApply!),
                            ),
                            icon: const Icon(Icons.notifications),
                          ),
                    CustomCircleAvatar(
                      userInApply: userInApply,
                      onTap: () => showBottomUpScreen(
                        context,
                        GroupSettingScreen(userInApply: userInApply!),
                      ),
                    ),
                  ]
                : null,
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
                  '${userInApply?.groupName} (${userInApply?.sectionName})へ所属申請を送信しました。承認されるまで今しばらくお待ちください。',
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
