import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_message.dart';

class MessageList extends StatelessWidget {
  final UserMessageModel message;
  final bool isMe;
  final Function()? onTapImage;

  const MessageList({
    required this.message,
    required this.isMe,
    this.onTapImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.image == ''
                ? Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: kBaseColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        message.content,
                        style: const TextStyle(color: kWhiteColor),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kBaseColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.image == ''
                ? Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: kWhiteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(message.content),
                    ),
                  )
                : GestureDetector(
                    onTap: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kWhiteColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.image,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
  }
}
