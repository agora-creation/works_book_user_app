import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';

class GroupSettingList extends StatelessWidget {
  final String header;
  final String value;

  const GroupSettingList({
    required this.header,
    required this.value,
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(
              color: kGrey2Color,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
