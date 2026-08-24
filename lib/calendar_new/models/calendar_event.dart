import 'package:flutter/material.dart';

enum EventType {
  exam,
  homework,
  reminder,
  holiday,      // ✅ NOUVEAU : Vacances / Fêtes
  religious,    // ✅ NOUVEAU : Événements religieux
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
      case EventType.holiday:
        return 'Vacances / Fête';
      case EventType.religious:
        return 'Religieux';
      case EventType.other:
        return 'Autre';
    }
  }
}

class CalendarEvent {
  final String id;
  final String title;
  final String? titleFr;        // ✅ NOUVEAU : Titre en français
  final DateTime date;
  final TimeOfDay? time;
  final Color color;
  final EventType type;
  final String? note;
  final bool isPredefined;      // ✅ NOUVEAU : Événement prédéfini tunisien

  CalendarEvent({
    required this.id,
    required this.title,
    this.titleFr,
    required this.date,
    this.time,
    required this.color,
    required this.type,
    this.note,
    this.isPredefined = false,   // Par défaut : événement utilisateur
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? titleFr,
    DateTime? date,
    TimeOfDay? time,
    Color? color,
    EventType? type,
    String? note,
    bool? isPredefined,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      titleFr: titleFr ?? this.titleFr,
      date: date ?? this.date,
      time: time ?? this.time,
      color: color ?? this.color,
      type: type ?? this.type,
      note: note ?? this.note,
      isPredefined: isPredefined ?? this.isPredefined,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'titleFr': titleFr,
    'date': date.toIso8601String(),
    'timeHour': time?.hour,
    'timeMinute': time?.minute,
    'color': color.toARGB32(),
    'type': type.index,
    'note': note,
    'isPredefined': isPredefined,
  };

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => CalendarEvent(
    id: json['id'],
    title: json['title'],
    titleFr: json['titleFr'],
    date: DateTime.parse(json['date']),
    time: json['timeHour'] != null
        ? TimeOfDay(hour: json['timeHour'], minute: json['timeMinute'])
        : null,
    color: Color(json['color']),
    type: EventType.values[json['type']],
    note: json['note'],
    isPredefined: json['isPredefined'] ?? false,
  );

  String get timeString => time != null
      ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
      : 'Toute la journée';

  /// ✅ Affiche le titre en arabe ou français selon la langue
  String get displayTitle => titleFr ?? title;

  Color get typeColor => switch (type) {
    EventType.exam => Colors.red,
    EventType.homework => Colors.orange,
    EventType.reminder => Colors.blue,
    EventType.holiday => Colors.green,
    EventType.religious => Colors.purple,
    EventType.other => Colors.grey,
  };

  String get typeLabel => switch (type) {
    EventType.exam => 'Examen',
    EventType.homework => 'Devoir',
    EventType.reminder => 'Rappel',
    EventType.holiday => 'Vacances',
    EventType.religious => 'Religieux',
    EventType.other => 'Autre',
  };
}