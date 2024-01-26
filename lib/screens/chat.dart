import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/models/user.dart';
import 'package:works_book_user_app/models/user_message.dart';
import 'package:works_book_user_app/services/fm.dart';
import 'package:works_book_user_app/services/user_message.dart';
import 'package:works_book_user_app/widgets/bottom_right_button.dart';
import 'package:works_book_user_app/widgets/custom_sub_button.dart';
import 'package:works_book_user_app/widgets/custom_text_form_field.dart';
import 'package:works_book_user_app/widgets/message_list.dart';

class ChatScreen extends StatefulWidget {
  final UserModel? user;
  final GroupModel? group;

  const ChatScreen({
    this.user,
    this.group,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FmService fmService = FmService();
  UserMessageService messageService = UserMessageService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: messageService.streamList(
              userId: widget.user?.id,
              groupId: widget.group?.id,
            ),
            builder: (context, snapshot) {
              List<UserMessageModel> messages = [];
              if (snapshot.hasData) {
                for (DocumentSnapshot<Map<String, dynamic>> doc
                    in snapshot.data!.docs) {
                  messages.add(UserMessageModel.fromSnapshot(doc));
                }
              }
              if (messages.isEmpty) {
                return const Center(child: Text('メッセージがありません'));
              }
              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 70,
                ),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  UserMessageModel message = messages[index];
                  return MessageList(
                    message: message,
                    isMe: message.createdUserId == widget.user?.id,
                    onTapImage: () => showDialog(
                      barrierDismissible: true,
                      barrierLabel: '閉じる',
                      context: context,
                      builder: (context) => ChatImageDialog(
                        image: message.image,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomRightButton(
                heroTag: 'addPicture',
                iconData: Icons.add_photo_alternate,
                onPressed: () async {
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image == null) return;
                  File imageFile = File(image.path);
                  String id = messageService.id(widget.user!.id);
                  FirebaseStorage storage = FirebaseStorage.instance;
                  final task = await storage
                      .ref('chat/${widget.group?.id}/${widget.user!.id}/$id')
                      .putFile(imageFile);
                  messageService.create({
                    'id': id,
                    'groupId': widget.group?.id,
                    'userId': widget.user?.id,
                    'content': '',
                    'image': await task.ref.getDownloadURL(),
                    'createdUserId': widget.user?.id,
                    'createdAt': DateTime.now(),
                  });
                  // List<String> tokens = widget.group?.tokens ?? [];
                  // for (String token in tokens) {
                  //   fmService.send(
                  //     token: token,
                  //     title: '新着メッセージ',
                  //     body: '画像を送信しました。',
                  //   );
                  // }
                },
              ),
              BottomRightButton(
                heroTag: 'addMessage',
                iconData: Icons.add_comment,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AddMessageDialog(
                    user: widget.user,
                    group: widget.group,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddMessageDialog extends StatefulWidget {
  final UserModel? user;
  final GroupModel? group;

  const AddMessageDialog({
    this.user,
    this.group,
    super.key,
  });

  @override
  State<AddMessageDialog> createState() => _AddMessageDialogState();
}

class _AddMessageDialogState extends State<AddMessageDialog> {
  FmService fmServices = FmService();
  UserMessageService messageService = UserMessageService();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: contentController,
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: 'メッセージを入力',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSubButton(
                label: 'やめる',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomSubButton(
                label: '送信する',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: () async {
                  if (contentController.text == '') return;
                  String id = messageService.id(widget.user!.id);
                  messageService.create({
                    'id': id,
                    'groupId': widget.group?.id,
                    'userId': widget.user?.id,
                    'content': contentController.text,
                    'image': '',
                    'createdUserId': widget.user?.id,
                    'createdAt': DateTime.now(),
                  });
                  // List<String> tokens = widget.group?.tokens ?? [];
                  // for (String token in tokens) {
                  //   fmServices.send(
                  //     token: token,
                  //     title: '新着メッセージ',
                  //     body: contentController.text,
                  //   );
                  // }
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatImageDialog extends StatefulWidget {
  final String image;

  const ChatImageDialog({
    required this.image,
    super.key,
  });

  @override
  State<ChatImageDialog> createState() => _ChatImageDialogState();
}

class _ChatImageDialogState extends State<ChatImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 5,
                child: Image.network(widget.image),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
