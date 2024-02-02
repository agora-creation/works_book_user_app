import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group_section_notice.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/services/group_section_notice.dart';
import 'package:works_book_user_app/widgets/custom_sub_button.dart';
import 'package:works_book_user_app/widgets/custom_text_form_field.dart';
import 'package:works_book_user_app/widgets/group_notice_list.dart';

class GroupNoticeScreen extends StatefulWidget {
  final UserInApplyModel userInApply;

  const GroupNoticeScreen({
    required this.userInApply,
    super.key,
  });

  @override
  State<GroupNoticeScreen> createState() => _GroupNoticeScreenState();
}

class _GroupNoticeScreenState extends State<GroupNoticeScreen> {
  GroupSectionNoticeService groupSectionNoticeService =
      GroupSectionNoticeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('お知らせの作成と送信'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey2Color)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: groupSectionNoticeService.streamList(
          groupId: widget.userInApply.groupId,
          sectionId: widget.userInApply.sectionId,
        ),
        builder: (context, snapshot) {
          List<GroupSectionNoticeModel> groupSectionNotices = [];
          if (snapshot.hasData) {
            for (DocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.data!.docs) {
              groupSectionNotices
                  .add(GroupSectionNoticeModel.fromSnapshot(doc));
            }
          }
          if (groupSectionNotices.isEmpty) {
            return const Center(child: Text('お知らせがありません'));
          }
          return ListView.builder(
            itemCount: groupSectionNotices.length,
            itemBuilder: (context, index) {
              GroupSectionNoticeModel groupSectionNotice =
                  groupSectionNotices[index];
              return GroupNoticeList(
                groupSectionNotice: groupSectionNotice,
                sendOnPressed: () => showDialog(
                  context: context,
                  builder: (context) => SendDialog(
                    userInApply: widget.userInApply,
                    groupSectionNotice: groupSectionNotice,
                  ),
                ),
                editOnPressed: () => showDialog(
                  context: context,
                  builder: (context) => EditDialog(
                    groupSectionNotice: groupSectionNotice,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddDialog(
            userInApply: widget.userInApply,
          ),
        ),
        backgroundColor: kBlueColor,
        child: const Icon(Icons.add, color: kWhiteColor),
      ),
    );
  }
}

class AddDialog extends StatefulWidget {
  final UserInApplyModel userInApply;

  const AddDialog({
    required this.userInApply,
    super.key,
  });

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  GroupSectionNoticeService groupSectionNoticeService =
      GroupSectionNoticeService();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'お知らせの作成',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: titleController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'タイトル',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: contentController,
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: 'お知らせ内容',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 16),
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
                label: '作成する',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  if (titleController.text == '') return;
                  if (contentController.text == '') return;
                  String id = groupSectionNoticeService.id(
                    groupId: widget.userInApply.groupId,
                    sectionId: widget.userInApply.sectionId,
                  );
                  groupSectionNoticeService.create({
                    'id': id,
                    'groupId': widget.userInApply.groupId,
                    'sectionId': widget.userInApply.sectionId,
                    'title': titleController.text,
                    'content': contentController.text,
                    'createdAt': DateTime.now(),
                  });
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

class EditDialog extends StatefulWidget {
  final GroupSectionNoticeModel groupSectionNotice;

  const EditDialog({
    required this.groupSectionNotice,
    super.key,
  });

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  GroupSectionNoticeService groupSectionNoticeService =
      GroupSectionNoticeService();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.groupSectionNotice.title;
    contentController.text = widget.groupSectionNotice.content;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'お知らせの編集',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: titleController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'タイトル',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: contentController,
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: 'お知らせ内容',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 16),
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
                label: '上記内容で保存',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  if (titleController.text == '') return;
                  if (contentController.text == '') return;
                  groupSectionNoticeService.update({
                    'id': widget.groupSectionNotice.id,
                    'groupId': widget.groupSectionNotice.groupId,
                    'sectionId': widget.groupSectionNotice.sectionId,
                    'title': titleController.text,
                    'content': contentController.text,
                  });
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

class SendDialog extends StatefulWidget {
  final UserInApplyModel userInApply;
  final GroupSectionNoticeModel groupSectionNotice;

  const SendDialog({
    required this.userInApply,
    required this.groupSectionNotice,
    super.key,
  });

  @override
  State<SendDialog> createState() => _SendDialogState();
}

class _SendDialogState extends State<SendDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'お知らせの一斉送信',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '※『${widget.userInApply.groupName} (${widget.userInApply.sectionName})』に所属しているアカウント(管理者以外)全てに一斉送信します',
            style: kErrorStyle,
          ),
          Text(
            widget.groupSectionNotice.title,
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.groupSectionNotice.content,
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
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
                backgroundColor: kCyanColor,
                onPressed: () async {
                  // if (titleController.text == '') return;
                  // if (contentController.text == '') return;
                  // groupSectionNoticeService.update({
                  //   'id': widget.groupSectionNotice.id,
                  //   'groupId': widget.groupSectionNotice.groupId,
                  //   'sectionId': widget.groupSectionNotice.sectionId,
                  //   'title': titleController.text,
                  //   'content': contentController.text,
                  // });
                  // if (!mounted) return;
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
