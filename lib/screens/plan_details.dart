import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_user_app/common/functions.dart';
import 'package:works_book_user_app/common/style.dart';

class PlanDetailsScreen extends StatefulWidget {
  final Appointment plan;

  const PlanDetailsScreen({
    required this.plan,
    super.key,
  });

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.plan.color,
      appBar: AppBar(
        backgroundColor: widget.plan.color,
        automaticallyImplyLeading: false,
        title: Text(
          widget.plan.subject,
          style: const TextStyle(color: kWhiteColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: kWhiteColor),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.plan.notes != ''
                ? Text(
                    widget.plan.notes ?? '',
                    style: const TextStyle(color: kWhiteColor),
                  )
                : Container(),
            widget.plan.notes != '' ? const SizedBox(height: 8) : Container(),
            widget.plan.isAllDay
                ? Text(
                    '予定日: ${dateText('MM/dd', widget.plan.startTime)}',
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 14,
                    ),
                  )
                : Text(
                    '予定日: ${dateText('MM/dd HH:mm', widget.plan.startTime)}～${dateText('MM/dd HH:mm', widget.plan.endTime)}',
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 14,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
