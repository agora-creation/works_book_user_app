import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/models/group_in_apply.dart';
import 'package:works_book_user_app/models/user_notice.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/screens/chat.dart';
import 'package:works_book_user_app/screens/group.dart';
import 'package:works_book_user_app/screens/group_in_apply.dart';
import 'package:works_book_user_app/screens/notice.dart';
import 'package:works_book_user_app/screens/notice_details.dart';
import 'package:works_book_user_app/screens/plan_details.dart';
import 'package:works_book_user_app/screens/schedule.dart';
import 'package:works_book_user_app/services/group.dart';
import 'package:works_book_user_app/services/group_in_apply.dart';
import 'package:works_book_user_app/widgets/custom_circle_avatar.dart';
import 'package:works_book_user_app/widgets/custom_persistent_tab_view.dart';
import 'package:works_book_user_app/widgets/group_in_apply1.dart';
import 'package:works_book_user_app/widgets/group_in_apply2.dart';
import 'package:works_book_user_app/widgets/group_in_apply3.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GroupService groupService = GroupService();
  GroupInApplyService groupInApplyService = GroupInApplyService();
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

    return StreamBuilder2<QuerySnapshot<Map<String, dynamic>>,
        QuerySnapshot<Map<String, dynamic>>>(
      streams: StreamTuple2(
        groupService.streamList(userProvider.user?.groupId),
        groupInApplyService.streamList(userProvider.user?.id),
      ),
      builder: (context, snapshot) {
        GroupModel? group;
        GroupInApplyModel? groupInApply;
        if (snapshot.snapshot1.hasData) {
          for (DocumentSnapshot<Map<String, dynamic>> doc
              in snapshot.snapshot1.data!.docs) {
            group = GroupModel.fromSnapshot(doc);
          }
        }
        if (snapshot.snapshot2.hasData) {
          for (DocumentSnapshot<Map<String, dynamic>> doc
              in snapshot.snapshot2.data!.docs) {
            groupInApply = GroupInApplyModel.fromSnapshot(doc);
          }
        }
        Widget body = Container();
        if (group == null) {
          if (groupInApply == null) {
            body = GroupInApply1(
              onPressed: () => showBottomUpScreen(
                context,
                const GroupInApplyScreen(),
              ),
            );
          } else {
            if (groupInApply.accept == false) {
              body = GroupInApply2(
                groupInApply: groupInApply,
                onTap: () async {
                  groupInApplyService.delete({
                    'userId': groupInApply?.userId,
                  });
                  await userProvider.reloadUserModel();
                },
              );
            } else {
              body = GroupInApply3(
                groupInApply: groupInApply,
                onPressed: () async {
                  await userProvider.reloadUserModel();
                },
              );
            }
          }
        } else {
          body = CustomPersistentTabView(
            context: context,
            controller: controller,
            screens: [
              ScheduleScreen(
                group: group,
                showPlanDetails: _showPlanDetails,
              ),
              NoticeScreen(
                user: userProvider.user,
                group: group,
                showNoticeDetails: _showNoticeDetails,
              ),
              ChatScreen(
                user: userProvider.user,
                group: group,
              ),
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
          );
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(userProvider.user?.name ?? ''),
            actions: [
              group != null
                  ? CustomCircleAvatar(
                      image: group.image,
                      onTap: () => showBottomUpScreen(
                        context,
                        GroupScreen(
                          group: group!,
                          groupInApply: groupInApply!,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          body: body,
        );
      },
    );
  }
}
