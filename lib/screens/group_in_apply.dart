import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/models/group_section.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/services/fm.dart';
import 'package:works_book_user_app/services/group.dart';
import 'package:works_book_user_app/services/group_section.dart';
import 'package:works_book_user_app/services/user.dart';
import 'package:works_book_user_app/services/user_in_apply.dart';
import 'package:works_book_user_app/widgets/custom_main_button.dart';
import 'package:works_book_user_app/widgets/custom_text_form_field.dart';
import 'package:works_book_user_app/widgets/group_section_list.dart';

class GroupInApplyScreen extends StatefulWidget {
  const GroupInApplyScreen({super.key});

  @override
  State<GroupInApplyScreen> createState() => _GroupInApplyScreenState();
}

class _GroupInApplyScreenState extends State<GroupInApplyScreen> {
  FmService fmService = FmService();
  GroupService groupService = GroupService();
  GroupSectionService groupSectionService = GroupSectionService();
  UserService userService = UserService();
  UserInApplyService userInApplyService = UserInApplyService();
  GroupModel? group;
  GroupSectionModel? groupSection;
  TextEditingController codeController = TextEditingController();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('会社へ所属申請を送る'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              errorText != null
                  ? Text('$errorText', style: kErrorStyle)
                  : Container(),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: codeController,
                textInputType: TextInputType.number,
                maxLines: 1,
                label: '会社コード(7桁)',
                color: kBaseColor,
                prefix: Icons.numbers,
              ),
              group == null
                  ? Container()
                  : GroupSectionList(
                      group: group,
                      groupSection: groupSection,
                    ),
              const SizedBox(height: 8),
              group == null
                  ? SizedBox(
                      width: double.infinity,
                      child: CustomMainButton(
                        label: 'コードから会社を検索する',
                        labelColor: kWhiteColor,
                        backgroundColor: kBaseColor,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          String code = codeController.text;
                          if (code.length != 7) {
                            setState(() {
                              errorText = '必ず7桁で入力してください';
                            });
                            return;
                          }
                          String groupCode = code.substring(0, 3);
                          String sectionCode = code.substring(3, 7);
                          GroupModel? tmpGroup = await groupService.select(
                            groupCode: groupCode,
                          );
                          if (tmpGroup == null) {
                            setState(() {
                              errorText = '会社が見つかりませんでした';
                            });
                            return;
                          }
                          GroupSectionModel? tmpGroupSection =
                              await groupSectionService.select(
                            groupId: tmpGroup.id,
                            sectionCode: sectionCode,
                          );
                          if (tmpGroupSection == null) {
                            setState(() {
                              errorText = '会社が見つかりませんでした';
                            });
                            return;
                          }
                          setState(() {
                            group = tmpGroup;
                            groupSection = tmpGroupSection;
                          });
                        },
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: CustomMainButton(
                            label: '所属申請を送る',
                            labelColor: kWhiteColor,
                            backgroundColor: kBaseColor,
                            onPressed: () async {
                              userInApplyService.create({
                                'id': userProvider.user?.id,
                                'groupId': group?.id,
                                'groupName': group?.name,
                                'sectionId': groupSection?.id,
                                'sectionName': groupSection?.name,
                                'userId': userProvider.user?.id,
                                'userName': userProvider.user?.name,
                                'accept': false,
                                'admin': false,
                                'createdAt': DateTime.now(),
                              });
                              fmService.sendToAdmin(
                                groupId: group?.id,
                                sectionId: groupSection?.id,
                                title: '${userProvider.user?.name}から所属申請がありました',
                                body:
                                    '${userProvider.user?.name}から所属申請がありました。アプリを開いて確認してください。',
                              );
                              if (!mounted) return;
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: CustomMainButton(
                            label: 'コード入力に戻る',
                            labelColor: kWhiteColor,
                            backgroundColor: kGreyColor,
                            onPressed: () {
                              setState(() {
                                group = null;
                                groupSection = null;
                                codeController.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
