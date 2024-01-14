import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';

class BottomRightButton extends StatelessWidget {
  final String heroTag;
  final IconData iconData;
  final Function()? onPressed;

  const BottomRightButton({
    required this.heroTag,
    required this.iconData,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 16),
        child: FloatingActionButton(
          heroTag: heroTag,
          backgroundColor: kBaseColor.withOpacity(0.9),
          onPressed: onPressed,
          child: Icon(iconData, color: kWhiteColor),
        ),
      ),
    );
  }
}
