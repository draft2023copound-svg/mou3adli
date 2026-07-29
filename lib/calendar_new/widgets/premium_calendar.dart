import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mou3adli/calendar_new/controllers/calendar_controller.dart';
import 'package:mou3adli/calendar_new/models/calendar_day.dart';

class PremiumCalendar extends StatefulWidget {
  final CalendarController controller;
  final Map<DateTime, int> events;
  final Function(DateTime) onSelect;

  const PremiumCalendar({
    super.key,
    required this.controller,
    required this.events,
    required this.onSelect,
  });

  @override
  State<PremiumCalendar> createState() => _PremiumCalendarState();
}

class _PremiumCalendarState extends State<PremiumCalendar> {
  late PageController pageController;
  int currentPage = 500;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) {
        return Column(
          children: [
            // --- HEADER MOIS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff4F8CFF), Color(0xff6D5DF6)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      color: const Color(0xff4F8CFF).withOpacity(.30),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        widget.controller.previousMonth();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.20),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.chevron_left, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: Text(
                            _monthName(),
                            key: ValueKey(widget.controller.currentMonth),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        widget.controller.nextMonth();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.20),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.chevron_right, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- JOURS SEMAINE ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _WeekDay("L"),
                  _WeekDay("M"),
                  _WeekDay("M"),
                  _WeekDay("J"),
                  _WeekDay("V"),
                  _WeekDay("S"),
                  _WeekDay("D"),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // --- CALENDRIER (PageView) ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.70),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (page) {
                          if (page > currentPage) {
                            widget.controller.nextMonth();
                          } else if (page < currentPage) {
                            widget.controller.previousMonth();
                          }
                          currentPage = page;
                        },
                        itemBuilder: (_, __) {
                          final days = widget.controller.buildMonth(
                            events: widget.events,
                          );
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(6),
                            itemCount: 42,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                            ),
                            itemBuilder: (_, index) {
                              return _DayCell(
                                day: days[index],
                                onTap: () {
                                  widget.controller.select(days[index].date);
                                  widget.onSelect(days[index].date);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _monthName() {
    const months = [
      "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
      "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"
    ];
    final m = widget.controller.currentMonth;
    return "${months[m.month - 1]} ${m.year}";
  }
}

// --- Jours de la semaine ---
class _WeekDay extends StatelessWidget {
  final String text;
  const _WeekDay(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// --- CELLULE DU JOUR (DayCell) premium ---
class _DayCell extends StatelessWidget {
  final CalendarDay day;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color heatColor = day.eventCount == 0
        ? Colors.transparent
        : day.eventCount == 1
            ? Colors.green
            : day.eventCount == 2
                ? Colors.orange
                : Colors.red;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween(begin: .92, end: 1),
      builder: (_, value, child) {
        return Transform.scale(
          scale: day.isSelected ? value : 1,
          child: child,
        );
      },
      child: AnimatedScale(
        scale: day.isSelected ? 1.08 : 1,
        duration: const Duration(milliseconds: 120),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              gradient: day.isSelected
                  ? const LinearGradient(
                      colors: [Color(0xff4F8CFF), Color(0xff6C63FF)],
                    )
                  : null,
              color: day.isSelected
                  ? null
                  : day.isToday
                      ? const Color(0xffEEF4FF)
                      : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: day.isToday
                  ? Border.all(color: const Color(0xff4F8CFF), width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.03),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
                if (day.isSelected)
                  BoxShadow(
                    color: const Color(0xff4F8CFF).withOpacity(.40),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
              ],
            ),
            child: Stack(
              children: [
                if (day.isSelected)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 35,
                            spreadRadius: 2,
                            color: const Color(0xff4F8CFF).withOpacity(.45),
                          ),
                        ],
                      ),
                    ),
                  ),

                Center(
                  child: Hero(
                    tag: day.date.toIso8601String(),
                    child: Material(
                      color: Colors.transparent,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          color: day.isSelected
                              ? Colors.white
                              : day.isCurrentMonth
                                  ? Colors.black87
                                  : Colors.grey.shade400,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        child: Text("${day.date.day}"),
                      ),
                    ),
                  ),
                ),

                if (day.eventCount > 0)
                  Positioned(
                    bottom: 4,
                    left: 4,
                    right: 4,
                    child: Center(
                      child: Container(
                        height: 4,
                        width: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              heatColor,
                              heatColor.withOpacity(.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}