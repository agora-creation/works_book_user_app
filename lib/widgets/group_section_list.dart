import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/models/group_section.dart';

class GroupSectionList extends StatelessWidget {
  final GroupModel? group;
  final GroupSectionModel? groupSection;

  const GroupSectionList({
    this.group,
    this.groupSection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey2Color)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '会社名',
              style: TextStyle(
                color: kGrey2Color,
                fontSize: 12,
              ),
            ),
            Text(
              '${group?.name} (${groupSection?.name})',
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
