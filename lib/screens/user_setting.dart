import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/screens/sign_in.dart';
import 'package:works_book_user_app/widgets/custom_setting_list.dart';
import 'package:works_book_user_app/widgets/custom_sub_button.dart';
import 'package:works_book_user_app/widgets/custom_text_form_field.dart';
import 'package:works_book_user_app/widgets/link_text.dart';

class UserSettingScreen extends StatefulWidget {
  const UserSettingScreen({super.key});

  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('アカウント情報'),
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
          CustomSettingList(
            header: 'お名前',
            value: userProvider.user?.name ?? '',
            onTap: () => showDialog(
              context: context,
              builder: (context) => NameEditDialog(
                userProvider: userProvider,
              ),
            ),
          ),
          CustomSettingList(
            header: 'メールアドレス',
            value: userProvider.user?.email ?? '',
            onTap: () => showDialog(
              context: context,
              builder: (context) => EmailEditDialog(
                userProvider: userProvider,
              ),
            ),
          ),
          CustomSettingList(
            header: 'パスワード',
            value: '********',
            onTap: () => showDialog(
              context: context,
              builder: (context) => PasswordEditDialog(
                userProvider: userProvider,
              ),
            ),
          ),
          const SizedBox(height: 24),
          LinkText(
            label: 'ログアウト',
            labelColor: kRedColor,
            onTap: () => showDialog(
              context: context,
              builder: (context) => SignOutDialog(
                userProvider: userProvider,
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class NameEditDialog extends StatefulWidget {
  final UserProvider userProvider;

  const NameEditDialog({
    required this.userProvider,
    super.key,
  });

  @override
  State<NameEditDialog> createState() => _NameEditDialogState();
}

class _NameEditDialogState extends State<NameEditDialog> {
  TextEditingController nameController = TextEditingController();
  String? errorText;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userProvider.user?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          errorText != null
              ? Text('$errorText', style: kErrorStyle)
              : Container(),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: nameController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'お名前',
            color: kBaseColor,
            prefix: Icons.person,
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
                label: '入力内容を保存',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await widget.userProvider.updateName(
                    name: nameController.text,
                  );
                  if (error != null) {
                    setState(() {
                      errorText = error;
                    });
                    return;
                  }
                  widget.userProvider.reloadUserModel();
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

class EmailEditDialog extends StatefulWidget {
  final UserProvider userProvider;

  const EmailEditDialog({
    required this.userProvider,
    super.key,
  });

  @override
  State<EmailEditDialog> createState() => _EmailEditDialogState();
}

class _EmailEditDialogState extends State<EmailEditDialog> {
  TextEditingController emailController = TextEditingController();
  String? errorText;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.userProvider.user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          errorText != null
              ? Text('$errorText', style: kErrorStyle)
              : Container(),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: emailController,
            textInputType: TextInputType.emailAddress,
            maxLines: 1,
            label: 'メールアドレス',
            color: kBaseColor,
            prefix: Icons.email,
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
                label: '入力内容を保存',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await widget.userProvider.updateEmail(
                    email: emailController.text,
                  );
                  if (error != null) {
                    setState(() {
                      errorText = error;
                    });
                    return;
                  }
                  widget.userProvider.reloadUserModel();
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

class PasswordEditDialog extends StatefulWidget {
  final UserProvider userProvider;

  const PasswordEditDialog({
    required this.userProvider,
    super.key,
  });

  @override
  State<PasswordEditDialog> createState() => _PasswordEditDialogState();
}

class _PasswordEditDialogState extends State<PasswordEditDialog> {
  TextEditingController passwordController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          errorText != null
              ? Text('$errorText', style: kErrorStyle)
              : Container(),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: passwordController,
            obscureText: true,
            textInputType: TextInputType.visiblePassword,
            maxLines: 1,
            label: 'パスワード',
            color: kBaseColor,
            prefix: Icons.password,
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
                label: '入力内容を保存',
                labelColor: kWhiteColor,
                backgroundColor: kBlueColor,
                onPressed: () async {
                  String? error = await widget.userProvider.updatePassword(
                    password: passwordController.text,
                  );
                  if (error != null) {
                    setState(() {
                      errorText = error;
                    });
                    return;
                  }
                  widget.userProvider.reloadUserModel();
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

class SignOutDialog extends StatefulWidget {
  final UserProvider userProvider;

  const SignOutDialog({
    required this.userProvider,
    super.key,
  });

  @override
  State<SignOutDialog> createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ログアウトして、ログイン画面へ戻ります。よろしいですか？',
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
                label: 'はい',
                labelColor: kWhiteColor,
                backgroundColor: kRedColor,
                onPressed: () async {
                  await widget.userProvider.signOut();
                  if (!mounted) return;
                  pushReplacementScreen(context, const SignInScreen());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
