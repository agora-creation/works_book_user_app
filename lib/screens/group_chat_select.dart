import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/services/user_in_apply.dart';
import 'package:works_book_user_app/widgets/custom_list_tile.dart';

class GroupChatSelectScreen extends StatefulWidget {
  final UserInApplyModel userInApply;
  final Function(UserInApplyModel userInApply) showGroupChat;

  const GroupChatSelectScreen({
    required this.userInApply,
    required this.showGroupChat,
    super.key,
  });

  @override
  State<GroupChatSelectScreen> createState() => _GroupChatSelectScreenState();
}

class _GroupChatSelectScreenState extends State<GroupChatSelectScreen> {
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
              UserInApplyModel userInApply = UserInApplyModel.fromSnapshot(doc);
              if (userInApply.accept && !userInApply.admin) {
                userInApples.add(userInApply);
              }
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
                trailing: const Icon(Icons.chevron_right),
                onTap: () => widget.showGroupChat(userInApply),
              );
            },
          );
        },
      ),
    );
  }
}
