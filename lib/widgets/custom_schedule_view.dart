import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_user_app/common/functions.dart';

class CustomScheduleView extends StatelessWidget {
  final List<Appointment> plans;
  final Function(CalendarTapDetails)? onTap;

  const CustomScheduleView({
    required this.plans,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      showDatePickerButton: true,
      showTodayButton: true,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      view: CalendarView.schedule,
      scheduleViewSettings: const ScheduleViewSettings(
        hideEmptyScheduleWeek: true,
      ),
      dataSource: _DataSource(plans),
      headerDateFormat: 'yyyy年MM月',
      onTap: onTap,
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

Widget scheduleViewBuilder(
  BuildContext buildContext,
  ScheduleViewMonthHeaderDetails details,
) {
  return Stack(
    children: <Widget>[
      Image(
        image: ExactAssetImage(
          'assets/images/months/${details.date.month}.png',
        ),
        fit: BoxFit.cover,
        width: details.bounds.width,
        height: details.bounds.height,
      ),
      Positioned(
        left: 55,
        right: 0,
        top: 20,
        bottom: 0,
        child: Text(
          dateText('yyyy年MM月', details.date),
          style: const TextStyle(fontSize: 18),
        ),
      )
    ],
  );
}
