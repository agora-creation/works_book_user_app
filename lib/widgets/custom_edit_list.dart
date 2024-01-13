import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';

class CustomEditList extends StatelessWidget {
  final String header;
  final String value;
  final Function()? onTap;

  const CustomEditList({
    required this.header,
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: kGrey2Color),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap != null
                ? const Icon(Icons.edit, color: kBaseColor)
                : Container(),
          ],
        ),
      ),
    );
  }
}
