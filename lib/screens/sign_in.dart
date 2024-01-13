import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/screens/home.dart';
import 'package:works_book_user_app/screens/sign_up.dart';
import 'package:works_book_user_app/widgets/custom_main_button.dart';
import 'package:works_book_user_app/widgets/custom_text_form_field.dart';
import 'package:works_book_user_app/widgets/link_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        kLogoImageUrl,
                        width: 80,
                      ),
                      const Text(
                        'お仕事手帳',
                        style: TextStyle(
                          color: kBaseColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const Text(
                        '- スタッフ用 -',
                        style: TextStyle(
                          color: kGreyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        errorText != null
                            ? Text('$errorText', style: kErrorStyle)
                            : Container(),
                        CustomTextFormField(
                          controller: emailController,
                          textInputType: TextInputType.emailAddress,
                          maxLines: 1,
                          label: 'メールアドレス',
                          color: kBaseColor,
                          prefix: Icons.email,
                        ),
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
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: CustomMainButton(
                            label: 'ログイン',
                            labelColor: kWhiteColor,
                            backgroundColor: kBaseColor,
                            onPressed: () async {
                              String? error = await userProvider.signIn(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              if (error != null) {
                                setState(() {
                                  errorText = error;
                                });
                                return;
                              }
                              if (!mounted) return;
                              pushReplacementScreen(
                                context,
                                const HomeScreen(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinkText(
                          label: '会員登録はコチラ',
                          labelColor: kBaseColor,
                          onTap: () => pushScreen(
                            context,
                            const SignUpScreen(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
