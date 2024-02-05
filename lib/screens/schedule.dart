import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group_section_plan.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';
import 'package:works_book_user_app/services/group_section_plan.dart';
import 'package:works_book_user_app/widgets/custom_schedule_view.dart';

class ScheduleScreen extends StatefulWidget {
  final UserInApplyModel userInApply;
  final Function(UserInApplyModel) showPlanAdd;
  final Function(UserInApplyModel, Appointment) showPlanDetail;

  const ScheduleScreen({
    required this.userInApply,
    required this.showPlanAdd,
    required this.showPlanDetail,
    super.key,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  GroupSectionPlanService planService = GroupSectionPlanService();
  List<Appointment> plans = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: kWhiteColor,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: planService.streamGroupSectionId(
                        groupId: widget.userInApply.groupId,
                        sectionId: widget.userInApply.sectionId,
                      ),
                      builder: (context, snapshot) {
                        plans.clear();
                        if (snapshot.hasData) {
                          for (DocumentSnapshot<Map<String, dynamic>> doc
                              in snapshot.data!.docs) {
                            GroupSectionPlanModel plan =
                                GroupSectionPlanModel.fromSnapshot(doc);
                            plans.add(Appointment(
                              startTime: plan.startedAt,
                              endTime: plan.endedAt,
                              subject: plan.title,
                              notes: plan.content,
                              color: plan.color,
                              isAllDay: plan.allDay,
                              id: plan.id,
                            ));
                          }
                        }
                        return CustomScheduleView(
                          plans: plans,
                          onTap: (CalendarTapDetails details) async {
                            dynamic appointment = details.appointments;
                            if (appointment != null) {
                              widget.showPlanDetail(
                                widget.userInApply,
                                appointment.first,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                widget.userInApply.admin
                    ? ListTile(
                        tileColor: kBaseColor,
                        leading: const Icon(Icons.add, color: kWhiteColor),
                        title: const Text(
                          '予定を追加する',
                          style: TextStyle(color: kWhiteColor),
                        ),
                        onTap: () => widget.showPlanAdd(widget.userInApply),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
