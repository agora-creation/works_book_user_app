import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';

class DatePickerButton extends StatelessWidget {
  final DateTime value;
  final Function()? onTap;

  const DatePickerButton({
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              dateText('yyyy/MM/dd', value),
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.calendar_today,
              color: kGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
