import 'package:flutter/material.dart';

enum EventType {
  exam,
  homework,
  reminder,
  other,
}

// --- EXTENSION AJOUTÉE POUR DONNER UN LABEL À CHAQUE TYPE ---
extension EventTypeExtension on EventType {
  String get label {
    switch (this) {
      case EventType.exam:
        return 'Examen';
      case EventType.homework:
        return 'Devoir';
      case EventType.reminder:
        return 'Rappel';
      case EventType.other:
        return 'Autre';
    }
  }
}

class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay? time;
  final Color color;
  final EventType type;
  final String? note;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    this.time,
    required this.color,
    required this.type,
    this.note,
  });

  // Copie pour les modifications
  CalendarEvent copyWith({
    String? id,
    String? title,
    DateTime? date,
    TimeOfDay? time,
    Color? color,
    EventType? type,
    String? note,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      color: color ?? this.color,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }

  // Sérialisation pour sauvegarde
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date.toIso8601String(),
    'timeHour': time?.hour,
    'timeMinute': time?.minute,
    'color': color.value,
    'type': type.index,
    'note': note,
  };

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => CalendarEvent(
    id: json['id'],
    title: json['title'],
    date: DateTime.parse(json['date']),
    time: json['timeHour'] != null
        ? TimeOfDay(hour: json['timeHour'], minute: json['timeMinute'])
        : null,
    color: Color(json['color']),
    type: EventType.values[json['type']],
    note: json['note'],
  );

  String get timeString => time != null
      ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
      : 'Toute la journée';

  Color get typeColor => switch (type) {
    EventType.exam => Colors.red,
    EventType.homework => Colors.orange,
    EventType.reminder => Colors.blue,
    EventType.other => Colors.grey,
  };

  String get typeLabel => switch (type) {
    EventType.exam => 'Examen',
    EventType.homework => 'Devoir',
    EventType.reminder => 'Rappel',
    EventType.other => 'Autre',
  };
}