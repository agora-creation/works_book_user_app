import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group_in_apply.dart';
import 'package:works_book_user_app/widgets/custom_main_button.dart';

class GroupInApply3 extends StatelessWidget {
  final GroupInApplyModel? groupInApply;
  final Function()? onPressed;

  const GroupInApply3({
    this.groupInApply,
    this.onPressed,
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
                  '所属申請が承認されました',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${groupInApply?.groupName}へ所属申請が承認されました。下のボタンをタップして、利用を開始してください。',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: CustomMainButton(
                label: '利用を開始する',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
