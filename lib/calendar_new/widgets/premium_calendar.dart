import 'package:flutter/material.dart';
import '../controllers/calendar_controller.dart';
import '../models/calendar_event.dart';

class PremiumCalendar extends StatefulWidget {
  final CalendarController controller;
  final Function(DateTime) onDateSelected;

  const PremiumCalendar({
    super.key,
    required this.controller,
    required this.onDateSelected,
  });

  @override
  State<PremiumCalendar> createState() => _PremiumCalendarState();
}

class _PremiumCalendarState extends State<PremiumCalendar> {
  late CalendarController _controller;
  DateTime _focusedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final eventsByDay = _controller.getEventsGroupedByDay();
        final days = _generateMonthDays(_focusedMonth);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // --- HEADER : Mois et année ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () {
                      setState(() {
                        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                      });
                    },
                  ),
                  Text(
                    '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {
                      setState(() {
                        _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- JOURS DE LA SEMAINE ---
              Row(
                children: [
                  'L', 'M', 'M', 'J', 'V', 'S', 'D'
                ].map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 8),

              // --- GRILLE DES JOURS ---
              Column(
                children: List.generate((days.length / 7).ceil(), (weekIndex) {
                  final start = weekIndex * 7;
                  final weekDays = days.sublist(start, start + 7 > days.length ? days.length : start + 7);
                  return Row(
                    children: weekDays.map((day) {
                      final isToday = _isToday(day);
                      final isSelected = _isSameDay(day, _controller.selectedDate);
                      final eventsForDay = eventsByDay[day] ?? [];
                      final hasEvents = eventsForDay.isNotEmpty;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _controller.selectDate(day);
                            widget.onDateSelected(day);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            height: 48,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF4F8CFF)
                                  : isToday
                                      ? const Color(0xFFEEF4FF)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: isToday && !isSelected
                                  ? Border.all(color: const Color(0xFF4F8CFF), width: 2)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF4F8CFF).withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : isToday
                                              ? const Color(0xFF4F8CFF)
                                              : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (hasEvents)
                                  Positioned(
                                    bottom: 4,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.white
                                              : eventsForDay.first.color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  List<DateTime> _generateMonthDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final int daysInMonth = lastDay.day;

    final List<DateTime> days = [];
    // Jours du mois précédent
    final int firstWeekday = firstDay.weekday % 7;
    for (int i = firstWeekday; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }
    // Jours du mois actuel
    for (int i = 0; i < daysInMonth; i++) {
      days.add(firstDay.add(Duration(days: i)));
    }
    // Jours du mois suivant pour compléter la grille
    while (days.length % 7 != 0) {
      days.add(days.last.add(const Duration(days: 1)));
    }
    return days;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }
}