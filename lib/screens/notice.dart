import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/models/user.dart';
import 'package:works_book_user_app/models/user_notice.dart';
import 'package:works_book_user_app/services/user_notice.dart';
import 'package:works_book_user_app/widgets/notice_list.dart';

class NoticeScreen extends StatefulWidget {
  final UserModel? user;
  final GroupModel? group;
  final Function(UserNoticeModel) showNoticeDetails;

  const NoticeScreen({
    this.user,
    this.group,
    required this.showNoticeDetails,
    super.key,
  });

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  UserNoticeService noticeService = UserNoticeService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: noticeService.streamList(
          userId: widget.user?.id,
          groupId: widget.group?.id,
        ),
        builder: (context, snapshot) {
          List<UserNoticeModel> notices = [];
          if (snapshot.hasData) {
            for (DocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.data!.docs) {
              notices.add(UserNoticeModel.fromSnapshot(doc));
            }
          }
          if (notices.isEmpty) {
            return const Center(child: Text('お知らせがありません'));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 16,
            ),
            itemCount: notices.length,
            itemBuilder: (context, index) {
              UserNoticeModel notice = notices[index];
              return NoticeList(
                notice: notice,
                onTap: () => widget.showNoticeDetails(notice),
              );
            },
          );
        },
      ),
    );
  }
}
