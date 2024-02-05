import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/models/user_notice.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/screens/user_notice_detail.dart';
import 'package:works_book_user_app/services/user_notice.dart';
import 'package:works_book_user_app/widgets/user_notice_list.dart';

class UserNoticeScreen extends StatefulWidget {
  final UserInApplyModel userInApply;

  const UserNoticeScreen({
    required this.userInApply,
    super.key,
  });

  @override
  State<UserNoticeScreen> createState() => _UserNoticeScreenState();
}

class _UserNoticeScreenState extends State<UserNoticeScreen> {
  UserNoticeService userNoticeService = UserNoticeService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('お知らせ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey2Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userNoticeService.streamUserId(
          groupId: widget.userInApply.groupId,
          sectionId: widget.userInApply.sectionId,
          userId: userProvider.user?.id,
        ),
        builder: (context, snapshot) {
          List<UserNoticeModel> userNotices = [];
          if (snapshot.hasData) {
            for (DocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.data!.docs) {
              userNotices.add(UserNoticeModel.fromSnapshot(doc));
            }
          }
          if (userNotices.isEmpty) {
            return const Center(child: Text('お知らせがありません'));
          }
          return ListView.builder(
            itemCount: userNotices.length,
            itemBuilder: (context, index) {
              UserNoticeModel userNotice = userNotices[index];
              return UserNoticeList(
                userNotice: userNotice,
                onTap: () => pushScreen(
                  context,
                  UserNoticeDetailScreen(userNotice: userNotice),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
