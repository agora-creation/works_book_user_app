import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/services/user.dart';
import 'package:works_book_user_app/widgets/custom_edit_list.dart';
import 'package:works_book_user_app/widgets/link_text.dart';

class GroupScreen extends StatefulWidget {
  final GroupModel group;

  const GroupScreen({
    required this.group,
    super.key,
  });

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
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
            value: widget.group.code,
          ),
          CustomEditList(
            header: '会社・組織名',
            value: widget.group.name,
          ),
          CustomEditList(
            header: '郵便番号',
            value: widget.group.zip,
          ),
          CustomEditList(
            header: '住所',
            value: widget.group.address,
          ),
          CustomEditList(
            header: '電話番号',
            value: widget.group.tel,
          ),
          const SizedBox(height: 16),
          Center(
            child: LinkText(
              label: 'この会社・組織から脱退する',
              labelColor: kRedColor,
              onTap: () async {
                userService.update({
                  'id': userProvider.user?.id,
                  'groupId': '',
                  'groupInApply': false,
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
