import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group_in_apply.dart';
import 'package:works_book_user_app/widgets/link_text.dart';

class GroupInApply2 extends StatelessWidget {
  final GroupInApplyModel? groupInApply;
  final Function()? onTap;

  const GroupInApply2({
    this.groupInApply,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  '所属申請を送信しました',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${groupInApply?.groupName}へ所属申請を送信しました。承認されるまで今しばらくお待ちください。',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            LinkText(
              label: '所属申請を取り消す',
              labelColor: kRedColor,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
