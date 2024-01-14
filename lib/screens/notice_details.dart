import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_notice.dart';

class NoticeDetailsScreen extends StatefulWidget {
  final UserNoticeModel notice;

  const NoticeDetailsScreen({
    required this.notice,
    super.key,
  });

  @override
  State<NoticeDetailsScreen> createState() => _NoticeDetailsScreenState();
}

class _NoticeDetailsScreenState extends State<NoticeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: AppBar(
        backgroundColor: kBackColor,
        automaticallyImplyLeading: false,
        title: Text(
          widget.notice.title,
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kBlackColor),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.notice.content,
              style: const TextStyle(color: kBlackColor),
            ),
            const Divider(color: kGreyColor),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                dateText('yyyy/MM/dd HH:ss', widget.notice.createdAt),
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
