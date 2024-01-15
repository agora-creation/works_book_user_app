import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/widgets/custom_main_button.dart';

class GroupInApplyNot extends StatelessWidget {
  final Function()? onPressed;

  const GroupInApplyNot({
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
            const Column(
              children: [
                Text(
                  '会社・組織に所属してません',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'はじめに会社・組織への所属申請を行ってください。会社・組織へ所属していないと、このアプリは利用できません。',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: CustomMainButton(
                label: '会社・組織へ所属申請を送る',
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
