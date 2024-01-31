import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_notice.dart';

class UserNoticeList extends StatelessWidget {
  final UserNoticeModel userNotice;
  final Function()? onTap;

  const UserNoticeList({
    required this.userNotice,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGrey2Color),
        ),
      ),
      child: ListTile(
        title: Text(
          userNotice.title,
          style: const TextStyle(
            color: kBlackColor,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          dateText('yyyy/MM/dd HH:ss', userNotice.createdAt),
          style: const TextStyle(color: kGreyColor),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
