import 'package:flutter/material.dart';

class TimelineEvent {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final DateTime date;

  const TimelineEvent({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.date,
  });
}

class AcademicTimeline extends StatelessWidget {
  final List<TimelineEvent> events;

  const AcademicTimeline({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: events.map((e) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: e.color,
                    child: Icon(
                      e.icon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 70,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(e.subtitle),
                      const SizedBox(height: 8),
                      Text(
                        "${e.date.day}/${e.date.month}/${e.date.year}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}