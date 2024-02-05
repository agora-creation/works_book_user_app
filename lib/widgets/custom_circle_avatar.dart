import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';

class CustomCircleAvatar extends StatelessWidget {
  final UserInApplyModel? userInApply;
  final Function()? onTap;

  const CustomCircleAvatar({
    required this.userInApply,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String groupName = userInApply?.groupName ?? '';
    bool admin = userInApply?.admin ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: admin ? kRedColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundColor: kBaseColor,
          child: Text(
            groupName.substring(0, 1),
            style: const TextStyle(color: kWhiteColor),
          ),
        ),
      ),
    );
  }
}
