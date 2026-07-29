import 'package:flutter/material.dart';
import '../models/calendar_day.dart';

class CalendarController extends ChangeNotifier {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  void nextMonth() {
    currentMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
    );
    notifyListeners();
  }

  void previousMonth() {
    currentMonth = DateTime(
      currentMonth.year,
      currentMonth.month - 1,
    );
    notifyListeners();
  }

  void select(DateTime day) {
    selectedDate = day;
    notifyListeners();
  }

  List<CalendarDay> buildMonth({
    required Map<DateTime, int> events,
  }) {
    final List<CalendarDay> days = [];
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    int weekDay = firstDay.weekday;
    if (weekDay == 7) weekDay = 0;

    for (int i = weekDay - 1; i >= 0; i--) {
      final date = firstDay.subtract(Duration(days: i + 1));
      days.add(
        CalendarDay(
          date: date,
          isCurrentMonth: false,
          isToday: _isToday(date),
          isSelected: _isSelected(date),
          eventCount: events[_normalize(date)] ?? 0,
        ),
      );
    }

    for (int i = 1; i <= lastDay.day; i++) {
      final date = DateTime(currentMonth.year, currentMonth.month, i);
      days.add(
        CalendarDay(
          date: date,
          isCurrentMonth: true,
          isToday: _isToday(date),
          isSelected: _isSelected(date),
          eventCount: events[_normalize(date)] ?? 0,
        ),
      );
    }

    while (days.length < 42) {
      final last = days.last.date;
      final date = last.add(const Duration(days: 1));
      days.add(
        CalendarDay(
          date: date,
          isCurrentMonth: false,
          isToday: _isToday(date),
          isSelected: _isSelected(date),
          eventCount: events[_normalize(date)] ?? 0,
        ),
      );
    }

    return days;
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return now.year == d.year && now.month == d.month && now.day == d.day;
  }

  bool _isSelected(DateTime d) {
    return selectedDate.year == d.year &&
        selectedDate.month == d.month &&
        selectedDate.day == d.day;
  }

  DateTime _normalize(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }
}