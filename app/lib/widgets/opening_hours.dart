import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const WEEK_DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

double timeOfDayToDouble(TimeOfDay t) {
  return t.hour*60.0 + t.minute;
}

bool isOpen(Map<String, OpeningHourDayEntry?> hours) {
  final dayOfWeek = DateTime.now().weekday-1;
  final entry = hours[WEEK_DAYS[dayOfWeek].toLowerCase()];
  if(entry == null) return false;
  return entry.isOpenNow();
}

class OpeningHours extends StatelessWidget {

  final Map<String, OpeningHourDayEntry?> hours;
  final TextStyle? textStyle;

  const OpeningHours({Key? key, required this.hours, this.textStyle}) : super(key: key);

  String getEntry(String day, BuildContext context) {
    return hours[day]?.getOpeningHourString(context) ?? "Closed";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WEEK_DAYS.map((e) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text("$e: ${getEntry(e.toLowerCase(), context)}", style: textStyle,),
      )).toList(),
    );
  }
}

class OpeningHourEntry {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  OpeningHourEntry(this.startTime, this.endTime);

  String getDurationAsString(BuildContext context) {
    final start = startTime.format(context);
    final end = endTime.format(context);

    return "$start-$end";
  }
}

class OpeningHourDayEntry {
  final List<OpeningHourEntry> entries;

  OpeningHourDayEntry(this.entries);

  String getOpeningHourString(BuildContext context) {
    final parts = entries.map((e) => e.getDurationAsString(context));
    return parts.join(", ");
  }

  bool isOpenNow() {
    final now = timeOfDayToDouble(TimeOfDay.now());
    var open = false;
    for(var e in entries) {
      open = open || ((timeOfDayToDouble(e.startTime) <= now) && (timeOfDayToDouble(e.endTime) >= now));
    }

    return open;
  }
}
