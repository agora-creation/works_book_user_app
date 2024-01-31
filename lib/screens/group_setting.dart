import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/screens/home.dart';
import 'package:works_book_user_app/services/user_in_apply.dart';
import 'package:works_book_user_app/widgets/custom_sub_button.dart';
import 'package:works_book_user_app/widgets/group_setting_list.dart';
import 'package:works_book_user_app/widgets/link_text.dart';

class GroupSettingScreen extends StatefulWidget {
  final UserInApplyModel userInApply;

  const GroupSettingScreen({
    required this.userInApply,
    super.key,
  });

  @override
  State<GroupSettingScreen> createState() => _GroupSettingScreenState();
}

class _GroupSettingScreenState extends State<GroupSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('会社情報'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          GroupSettingList(
            header: '会社コード',
            value:
                '${widget.userInApply.groupId}${widget.userInApply.sectionId}',
          ),
          GroupSettingList(
            header: '会社名',
            value:
                '${widget.userInApply.groupName} (${widget.userInApply.sectionName})',
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LinkText(
                label: '会社から脱退する',
                labelColor: kRedColor,
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => GroupOutDialog(
                    userInApply: widget.userInApply,
                  ),
                ),
              ),
              !widget.userInApply.admin
                  ? LinkText(
                      label: '管理者になる',
                      labelColor: kBlueColor,
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => GroupAdminDialog(
                          userInApply: widget.userInApply,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class GroupOutDialog extends StatefulWidget {
  final UserInApplyModel userInApply;

  const GroupOutDialog({
    required this.userInApply,
    super.key,
  });

  @override
  State<GroupOutDialog> createState() => _GroupOutDialogState();
}

class _GroupOutDialogState extends State<GroupOutDialog> {
  UserInApplyService userInApplyService = UserInApplyService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '現在所属している会社から脱退します。アプリの機能が最大限ご利用できなくなりますが、よろしいでしょうか？',
            style: TextStyle(color: kBlackColor),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSubButton(
                label: 'いいえ',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomSubButton(
                label: '脱退する',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () {
                  userInApplyService.delete({
                    'id': widget.userInApply.id,
                  });
                  if (!mounted) return;
                  pushReplacementScreen(context, const HomeScreen());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GroupAdminDialog extends StatefulWidget {
  final UserInApplyModel userInApply;

  const GroupAdminDialog({
    required this.userInApply,
    super.key,
  });

  @override
  State<GroupAdminDialog> createState() => _GroupAdminDialogState();
}

class _GroupAdminDialogState extends State<GroupAdminDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '現在所属している会社の管理者になります。アプリの機能が管理者向けの内容に変更されますが、よろしいでしょうか？',
            style: TextStyle(color: kBlackColor),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSubButton(
                label: 'いいえ',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
