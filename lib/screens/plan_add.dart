import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/services/group_section_plan.dart';
import 'package:works_book_user_app/widgets/color_select_button.dart';
import 'package:works_book_user_app/widgets/custom_main_button.dart';
import 'package:works_book_user_app/widgets/custom_text_form_field.dart';
import 'package:works_book_user_app/widgets/date_picker_button.dart';
import 'package:works_book_user_app/widgets/time_picker_button.dart';

class PlanAddScreen extends StatefulWidget {
  final UserInApplyModel userInApply;

  const PlanAddScreen({
    required this.userInApply,
    super.key,
  });

  @override
  State<PlanAddScreen> createState() => _PlanAddScreenState();
}

class _PlanAddScreenState extends State<PlanAddScreen> {
  GroupSectionPlanService planService = GroupSectionPlanService();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  String color = kPlanColors.first.value.toRadixString(16);
  bool allDay = false;

  void _init() {
    setState(() {
      startedAt = DateTime.now();
      endedAt = startedAt.add(const Duration(hours: 1));
    });
  }

  void _allDayChange(bool value) {
    setState(() {
      allDay = value;
      if (value) {
        startedAt = DateTime(
          startedAt.year,
          startedAt.month,
          startedAt.day,
          0,
          0,
          0,
        );
        endedAt = DateTime(
          endedAt.year,
          endedAt.month,
          endedAt.day,
          23,
          59,
          59,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('予定を追加する'),
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
            label: '内容',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: kGreyColor),
          SwitchListTile(
            value: allDay,
            title: const Text('終日'),
            onChanged: _allDayChange,
          ),
          const Divider(height: 1, color: kGreyColor),
          const Text(
            '開始日時',
            style: TextStyle(
              color: kGrey2Color,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              DatePickerButton(
                value: startedAt,
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: startedAt,
                    firstDate: kFirstDate,
                    lastDate: kLastDate,
                  );
                  if (selected == null) return;
                  setState(() {
                    startedAt = rebuildDate(selected, startedAt);
                  });
                },
              ),
              const SizedBox(width: 8),
              TimePickerButton(
                value: startedAt,
                onTap: () async {
                  String initTime = dateText('HH:mm', startedAt);
                  List<String> hourMinute = initTime.split(':');
                  final selected = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: int.parse(hourMinute.first),
                      minute: int.parse(hourMinute.last),
                    ),
                  );
                  if (selected == null) return;
                  if (!mounted) return;
                  String selectedTime = selected.format(context);
                  setState(() {
                    startedAt = rebuildTime(
                      context,
                      startedAt,
                      selectedTime,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '終了日時',
            style: TextStyle(
              color: kGrey2Color,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              DatePickerButton(
                value: endedAt,
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: endedAt,
                    firstDate: kFirstDate,
                    lastDate: kLastDate,
                  );
                  if (selected == null) return;
                  setState(() {
                    endedAt = rebuildDate(selected, endedAt);
                  });
                },
              ),
              const SizedBox(width: 8),
              TimePickerButton(
                value: endedAt,
                onTap: () async {
                  String initTime = dateText('HH:mm', endedAt);
                  List<String> hourMinute = initTime.split(':');
                  final selected = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: int.parse(hourMinute.first),
                      minute: int.parse(hourMinute.last),
                    ),
                  );
                  if (selected == null) return;
                  if (!mounted) return;
                  String selectedTime = selected.format(context);
                  setState(() {
                    endedAt = rebuildTime(context, endedAt, selectedTime);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: kGreyColor),
          const SizedBox(height: 8),
          const Text(
            '色',
            style: TextStyle(
              color: kGrey2Color,
              fontSize: 14,
            ),
          ),
          ColorSelectButton(
            value: color,
            onChanged: (value) {
              setState(() {
                color = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          CustomMainButton(
            label: '上記内容を追加する',
            labelColor: kWhiteColor,
            backgroundColor: kBaseColor,
            onPressed: () async {
              if (titleController.text == '') return;
              String id = planService.id(
                groupId: widget.userInApply.groupId,
                sectionId: widget.userInApply.sectionId,
              );
              planService.create({
                'id': id,
                'groupId': widget.userInApply.groupId,
                'sectionId': widget.userInApply.sectionId,
                'title': titleController.text,
                'content': contentController.text,
                'startedAt': startedAt,
                'endedAt': endedAt,
                'color': color,
                'allDay': allDay,
                'createdAt': DateTime.now(),
              });

              if (!mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
