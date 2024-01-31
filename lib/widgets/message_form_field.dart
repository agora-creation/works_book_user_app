import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';

class MessageFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function()? galleryPressed;
  final Function()? sendPressed;

  const MessageFormField({
    required this.controller,
    required this.galleryPressed,
    required this.sendPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kGrey2Color)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: IconButton(
              onPressed: galleryPressed,
              icon: const Icon(Icons.photo, color: kGrey2Color),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration.collapsed(
                  hintText: 'メッセージを入力...',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: IconButton(
              onPressed: sendPressed,
              icon: const Icon(Icons.send, color: kGrey2Color),
            ),
          ),
        ],
      ),
    );
  }
}
