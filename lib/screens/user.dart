import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/services/user_in_apply.dart';
import 'package:works_book_user_app/widgets/custom_list_tile.dart';
import 'package:works_book_user_app/widgets/custom_sub_button.dart';
import 'package:works_book_user_app/widgets/link_text.dart';

class UserScreen extends StatefulWidget {
  final UserInApplyModel userInApply;

  const UserScreen({
    required this.userInApply,
    super.key,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserInApplyService userInApplyService = UserInApplyService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userInApplyService.streamGroupSectionId(
          groupId: widget.userInApply.groupId,
          sectionId: widget.userInApply.sectionId,
        ),
        builder: (context, snapshot) {
          List<UserInApplyModel> userInApples = [];
          if (snapshot.hasData) {
            for (DocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.data!.docs) {
              userInApples.add(UserInApplyModel.fromSnapshot(doc));
            }
          }
          if (userInApples.isEmpty) {
            return const Center(
              child: Text('この会社に所属しているスタッフがいません'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
            ),
            itemCount: userInApples.length,
            itemBuilder: (context, index) {
              UserInApplyModel userInApply = userInApples[index];
              return CustomListTile(
                title: Text(userInApply.userName),
                subtitle: userInApply.admin
                    ? const Text(
                        '管理者',
                        style: TextStyle(color: kRedColor),
                      )
                    : null,
                trailing: !userInApply.accept
                    ? const Text(
                        '所属申請承認待ち',
                        style: TextStyle(color: kRedColor),
                      )
                    : null,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => UserDialog(
                    userInApply: userInApply,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserDialog extends StatefulWidget {
  final UserInApplyModel userInApply;

  const UserDialog({
    required this.userInApply,
    super.key,
  });

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  UserInApplyService userInApplyService = UserInApplyService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('アカウント名'),
          Text(widget.userInApply.userName),
          const Divider(),
          widget.userInApply.accept
              ? const Text(
                  '上記アカウントを会社から強制脱退させることができます。',
                  style: TextStyle(color: kBlackColor),
                )
              : const Text(
                  '上記アカウントから所属申請がありました。承認もしくは却下して対応してください。',
                  style: TextStyle(color: kBlackColor),
                ),
          const SizedBox(height: 16),
          widget.userInApply.accept
              ? Center(
                  child: LinkText(
                    label: '強制脱退させる',
                    labelColor: kRedColor,
                    onTap: () {
                      userInApplyService.delete({
                        'id': widget.userInApply.id,
                      });
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomSubButton(
                      label: '却下する',
                      labelColor: kWhiteColor,
                      backgroundColor: kRedColor,
                      onPressed: () {
                        userInApplyService.delete({
                          'id': widget.userInApply.id,
                        });
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                    ),
                    CustomSubButton(
                      label: '承認する',
                      labelColor: kWhiteColor,
                      backgroundColor: kBlueColor,
                      onPressed: () {
                        userInApplyService.update({
                          'id': widget.userInApply.id,
                          'accept': true,
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
