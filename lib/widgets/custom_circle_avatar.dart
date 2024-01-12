import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String image;
  final Function()? onTap;

  const CustomCircleAvatar({
    required this.image,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 58,
        child: CircleAvatar(
          backgroundImage: NetworkImage(image),
          backgroundColor: kGreyColor,
        ),
      ),
    );
  }
}
