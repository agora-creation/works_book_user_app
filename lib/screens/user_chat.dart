import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/models/user_message.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/services/fm.dart';
import 'package:works_book_user_app/services/user_message.dart';
import 'package:works_book_user_app/widgets/message_form_field.dart';
import 'package:works_book_user_app/widgets/message_list.dart';

class UserChatScreen extends StatefulWidget {
  final UserInApplyModel userInApply;

  const UserChatScreen({
    required this.userInApply,
    super.key,
  });

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  FmService fmService = FmService();
  UserMessageService messageService = UserMessageService();
  TextEditingController contentController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Focus(
      focusNode: contentFocusNode,
      child: GestureDetector(
        onTap: contentFocusNode.requestFocus,
        child: Container(
          color: kBackColor,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
            ),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  color: kWhiteColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: messageService.streamUserId(
                            groupId: widget.userInApply.groupId,
                            sectionId: widget.userInApply.sectionId,
                            userId: userProvider.user?.id,
                          ),
                          builder: (context, snapshot) {
                            List<UserMessageModel> messages = [];
                            if (snapshot.hasData) {
                              for (DocumentSnapshot<Map<String, dynamic>> doc
                                  in snapshot.data!.docs) {
                                messages
                                    .add(UserMessageModel.fromSnapshot(doc));
                              }
                            }
                            if (messages.isEmpty) {
                              return const Center(child: Text('メッセージがありません'));
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.all(8),
                              reverse: true,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                UserMessageModel message = messages[index];
                                return MessageList(
                                  message: message,
                                  isMe: message.createdUserId ==
                                      userProvider.user?.id,
                                  onTapImage: () => showDialog(
                                    barrierDismissible: true,
                                    barrierLabel: '閉じる',
                                    context: context,
                                    builder: (context) => ImageDialog(
                                      image: message.image,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      MessageFormField(
                        controller: contentController,
                        galleryPressed: () async {
                          String id = messageService.id(
                            userId: userProvider.user?.id,
                          );
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image == null) return;
                          File imageFile = File(image.path);
                          FirebaseStorage storage = FirebaseStorage.instance;
                          String storagePath =
                              'chat/${widget.userInApply.groupId}/${widget.userInApply.sectionId}/${userProvider.user?.id}/$id';
                          final task =
                              await storage.ref(storagePath).putFile(imageFile);
                          messageService.create({
                            'id': id,
                            'userId': userProvider.user?.id,
                            'groupId': widget.userInApply.groupId,
                            'sectionId': widget.userInApply.sectionId,
                            'content': '',
                            'image': await task.ref.getDownloadURL(),
                            'createdUserId': userProvider.user?.id,
                            'createdAt': DateTime.now(),
                          });
                          if (widget.userInApply.admin) {
                          } else {
                            fmService.sendToAdmin(
                              groupId: widget.userInApply.groupId,
                              sectionId: widget.userInApply.sectionId,
                              title: '新着メッセージがありました',
                              body: '画像を送信しました。',
                            );
                          }
                        },
                        sendPressed: () async {
                          if (contentController.text == '') return;
                          String id = messageService.id(
                            userId: userProvider.user?.id,
                          );
                          messageService.create({
                            'id': id,
                            'userId': userProvider.user?.id,
                            'groupId': widget.userInApply.groupId,
                            'sectionId': widget.userInApply.sectionId,
                            'content': contentController.text,
                            'image': '',
                            'createdUserId': userProvider.user?.id,
                            'createdAt': DateTime.now(),
                          });
                          if (widget.userInApply.admin) {
                          } else {
                            fmService.sendToAdmin(
                              groupId: widget.userInApply.groupId,
                              sectionId: widget.userInApply.sectionId,
                              title: '新着メッセージがありました',
                              body: contentController.text,
                            );
                          }
                          contentController.clear();
                          contentFocusNode.unfocus();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageDialog extends StatefulWidget {
  final String image;

  const ImageDialog({
    required this.image,
    super.key,
  });

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
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
