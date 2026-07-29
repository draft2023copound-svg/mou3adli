class CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final int eventCount;

  const CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.eventCount,
  });

  CalendarDay copyWith({
    bool? isSelected,
    int? eventCount,
  }) {
    return CalendarDay(
      date: date,
      isCurrentMonth: isCurrentMonth,
      isToday: isToday,
      isSelected: isSelected ?? this.isSelected,
      eventCount: eventCount ?? this.eventCount,
    );
  }
}