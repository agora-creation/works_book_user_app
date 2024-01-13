import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/models/group_in_apply.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/services/group_in_apply.dart';
import 'package:works_book_user_app/services/user.dart';
import 'package:works_book_user_app/widgets/custom_edit_list.dart';
import 'package:works_book_user_app/widgets/link_text.dart';

class GroupScreen extends StatefulWidget {
  final GroupModel group;
  final GroupInApplyModel groupInApply;

  const GroupScreen({
    required this.group,
    required this.groupInApply,
    super.key,
  });

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  GroupInApplyService groupInApplyService = GroupInApplyService();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('会社・組織情報'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: ClipOval(
              child: Image.network(
                widget.group.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          CustomEditList(
            header: '会社・組織番号',
            value: widget.group.number,
          ),
          CustomEditList(
            header: '会社・組織名',
            value: widget.group.name,
          ),
          CustomEditList(
            header: '郵便番号',
            value: widget.group.zipCode,
          ),
          CustomEditList(
            header: '住所',
            value: widget.group.address,
          ),
          CustomEditList(
            header: '電話番号',
            value: widget.group.tel,
          ),
          CustomEditList(
            header: 'メールアドレス',
            value: widget.group.email,
          ),
          const SizedBox(height: 16),
          Center(
            child: LinkText(
              label: 'この会社・組織から脱退する',
              labelColor: kRedColor,
              onTap: () async {
                groupInApplyService.delete({
                  'userId': widget.groupInApply.userId,
                });
                userService.update({
                  'id': widget.groupInApply.userId,
                  'groupId': '',
                });
                await userProvider.reloadUserModel();
                if (!mounted) return;
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
