import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';

class ColorSelectButton extends StatelessWidget {
  final String value;
  final Function(String?)? onChanged;

  const ColorSelectButton({
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      value: value,
      onChanged: onChanged,
      items: kPlanColors.map((Color value) {
        return DropdownMenuItem(
          value: value.value.toRadixString(16),
          child: Container(
            color: value,
            width: double.infinity,
            height: 25,
          ),
        );
      }).toList(),
    );
  }
}
