import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_user_app/models/group_section_plan.dart';

class ScheduleDataSource extends CalendarDataSource {
  ScheduleDataSource(List<GroupSectionPlanModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startedAt;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endedAt;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].allDay;
  }
}
