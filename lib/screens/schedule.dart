import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_user_app/common/style.dart';
import 'package:works_book_user_app/models/group.dart';
import 'package:works_book_user_app/models/group_section_plan.dart';
import 'package:works_book_user_app/services/group_section_plan.dart';
import 'package:works_book_user_app/widgets/custom_schedule_view.dart';

class ScheduleScreen extends StatefulWidget {
  final GroupModel? group;
  final Function(Appointment) showPlanDetails;

  const ScheduleScreen({
    this.group,
    required this.showPlanDetails,
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
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: planService.streamList(
          groupId: widget.group?.id,
          sectionId: '',
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
          return Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 16,
            ),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CustomScheduleView(
                  plans: plans,
                  onTap: (CalendarTapDetails details) async {
                    dynamic appointment = details.appointments;
                    if (appointment != null) {
                      widget.showPlanDetails(appointment.first);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
