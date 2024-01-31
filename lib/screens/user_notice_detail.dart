import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_notice.dart';
import 'package:works_book_user_app/services/user_notice.dart';

class UserNoticeDetailScreen extends StatefulWidget {
  final UserNoticeModel userNotice;

  const UserNoticeDetailScreen({
    required this.userNotice,
    super.key,
  });

  @override
  State<UserNoticeDetailScreen> createState() => _UserNoticeDetailScreenState();
}

class _UserNoticeDetailScreenState extends State<UserNoticeDetailScreen> {
  UserNoticeService userNoticeService = UserNoticeService();

  void _init() {
    if (widget.userNotice.isRead) return;
    userNoticeService.update({
      'id': widget.userNotice.id,
      'userId': widget.userNotice.userId,
      'isRead': true,
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(widget.userNotice.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userNotice.content,
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                dateText('yyyy/MM/dd HH:ss', widget.userNotice.createdAt),
                style: const TextStyle(
                  color: kGrey2Color,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
