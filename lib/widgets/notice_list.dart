import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_notice.dart';

class NoticeList extends StatelessWidget {
  final UserNoticeModel notice;
  final Function()? onTap;

  const NoticeList({
    required this.notice,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateText('yyyy/MM/dd HH:ss', notice.createdAt),
                        style: const TextStyle(
                          color: kGreyColor,
                          fontSize: 12,
                        ),
                      ),
                      notice.isRead == false
                          ? const Icon(
                              Icons.circle,
                              color: kRedColor,
                              size: 14,
                            )
                          : Container(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notice.title,
                    style: const TextStyle(
                      color: kBlackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notice.content,
                    style: const TextStyle(
                      color: kBlackColor,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
