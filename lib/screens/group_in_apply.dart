import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/models/group_section.dart';
import 'package:works_book_user_app/providers/user.dart';
import 'package:works_book_user_app/services/fm.dart';
import 'package:works_book_user_app/services/group.dart';
import 'package:works_book_user_app/services/group_section.dart';
import 'package:works_book_user_app/widgets/custom_main_button.dart';
import 'package:works_book_user_app/widgets/custom_text_form_field.dart';
import 'package:works_book_user_app/widgets/group_in_apply_list.dart';

class GroupInApplyScreen extends StatefulWidget {
  const GroupInApplyScreen({super.key});

  @override
  State<GroupInApplyScreen> createState() => _GroupInApplyScreenState();
}

class _GroupInApplyScreenState extends State<GroupInApplyScreen> {
  FmService fmService = FmService();
  GroupService groupService = GroupService();
  GroupSectionService groupSectionService = GroupSectionService();
  GroupModel? group;
  GroupSectionModel? groupSection;
  TextEditingController codeController = TextEditingController();

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
              CustomTextFormField(
                controller: codeController,
                textInputType: TextInputType.number,
                maxLines: 1,
                label: '会社コード(7桁)',
                color: kBaseColor,
                prefix: Icons.numbers,
              ),
              group == null ? Container() : GroupInApplyList(group: group),
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
                          String groupCode = code.substring(0, 3);
                          String sectionCode = code.substring(3, 7);

                          print(groupCode);
                          print(sectionCode);

                          // GroupModel? tmpGroup = await groupService.select(
                          //   groupCode: codeController.text,
                          // );
                          // setState(() {
                          //   group = tmpGroup;
                          // });
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
                              // userService.update({
                              //   'id': userProvider.user?.id,
                              //   'groupId': group?.id,
                              //   'groupInApply': false,
                              // });
                              // List<String> tokens = group?.tokens ?? [];
                              // for (String token in tokens) {
                              //   fmService.send(
                              //     token: token,
                              //     title: '所属申請がありました',
                              //     body:
                              //         '${userProvider.user?.name}様から所属申請がありました。至急対応してください。',
                              //   );
                              // }
                              await userProvider.reloadUserModel();
                              if (!mounted) return;
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: CustomMainButton(
                            label: 'キャンセル',
                            labelColor: kWhiteColor,
                            backgroundColor: kGreyColor,
                            onPressed: () {
                              setState(() {
                                group = null;
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
