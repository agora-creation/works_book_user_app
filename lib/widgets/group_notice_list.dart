import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group_section_notice.dart';
import 'package:works_book_user_app/widgets/custom_sub_button.dart';

class GroupNoticeList extends StatelessWidget {
  final GroupSectionNoticeModel groupSectionNotice;
  final Function()? sendOnPressed;
  final Function()? editOnPressed;

  const GroupNoticeList({
    required this.groupSectionNotice,
    this.sendOnPressed,
    this.editOnPressed,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              groupSectionNotice.title,
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              groupSectionNotice.content,
              style: const TextStyle(color: kGreyColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomSubButton(
                  label: '一斉送信',
                  labelColor: kWhiteColor,
                  backgroundColor: kCyanColor,
                  onPressed: sendOnPressed,
                ),
                CustomSubButton(
                  label: '編集',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: editOnPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
