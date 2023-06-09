import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarStyleSheet {
  CalendarStyle calendarStyle(BuildContext context) {
    return CalendarStyle(
      cellMargin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      todayDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      todayTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      tableBorder: const TableBorder(
          horizontalInside: BorderSide(width: 1, color: Color(0xFF8F9BB3))),
      selectedDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        shape: BoxShape.rectangle,
        color: Theme.of(context).colorScheme.primary,
      ),
      selectedTextStyle: const TextStyle(
          color: CupertinoColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      defaultDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      weekendDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      defaultTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.inverseSurface,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      outsideTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.outlineVariant,
          fontWeight: FontWeight.w500,
          fontSize: 16),
    );
  }

  TextStyle defaultTextStyle = const TextStyle(
      color: Color(0xFF4F4F4F), fontWeight: FontWeight.w500, fontSize: 16);

  TextStyle saturdayTextStyle = const TextStyle(
      color: Color(0xFF9999FF), fontWeight: FontWeight.w500, fontSize: 16);

  TextStyle sundayTextStyle = const TextStyle(
      color: Color(0xFFFF9999), fontWeight: FontWeight.w500, fontSize: 16);
}


const containerTitleTextStyle = TextStyle(
    fontSize: 18,
    color: CupertinoColors.white,
    fontWeight: FontWeight.w600
    
);

const containerSubTitleTextStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF494B7C),
    fontWeight: FontWeight.w500
);