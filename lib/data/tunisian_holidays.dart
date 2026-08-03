import 'package:flutter/material.dart';
import '../calendar_new/models/calendar_event.dart';
import '../services/notification_service.dart';

/// 🇹🇳 ÉVÉNEMENTS OFFICIELS DU CALENDRIER SCOLAIRE TUNISIEN 2026-2027
/// Sources : Ministère de l'Éducation Tunisien
class TunisianHolidays {
  TunisianHolidays._();

  /// 📅 Tous les événements prédéfinis
  static List<CalendarEvent> getAllEvents() {
    return [
      // ═══════════════════════════════════════════════════════════
      // عيد الجلاء — 15 أكتوبر 2026
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'holiday_evacuation_2026',
        title: 'عيد الجلاء',
        titleFr: 'Jour de l\'Évacuation',
        date: DateTime(2026, 10, 15),
        color: Colors.red,
        type: EventType.holiday,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // عطلة الشتاء — 12 ديسمبر → 27 ديسمبر 2026
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'holiday_winter_start_2026',
        title: 'بداية عطلة الشتاء',
        titleFr: 'Début des vacances d\'hiver',
        date: DateTime(2026, 12, 12),
        color: Colors.blue,
        type: EventType.holiday,
        isPredefined: true,
      ),
      CalendarEvent(
        id: 'holiday_winter_end_2026',
        title: 'نهاية عطلة الشتاء',
        titleFr: 'Fin des vacances d\'hiver',
        date: DateTime(2026, 12, 27),
        color: Colors.blue,
        type: EventType.holiday,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // عيد الثورة — 17 ديسمبر 2026
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'holiday_revolution_2026',
        title: 'عيد الثورة',
        titleFr: 'Jour de la Révolution',
        date: DateTime(2026, 12, 17),
        color: Colors.red,
        type: EventType.holiday,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // رأس السنة الميلادية — 1 جانفي 2027
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'holiday_new_year_2027',
        title: 'رأس السنة الميلادية',
        titleFr: 'Nouvel An',
        date: DateTime(2027, 1, 1),
        color: Colors.green,
        type: EventType.holiday,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // بداية الصيام (فلكياً) — 8 فيفري 2027
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'ramadan_start_2027',
        title: 'بداية شهر رمضان 🌙',
        titleFr: 'Début du Ramadan',
        date: DateTime(2027, 2, 8),
        color: Colors.purple,
        type: EventType.religious,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // نهاية رمضان (فلكياً) — 9 مارس 2027
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'ramadan_end_2027',
        title: 'نهاية شهر رمضان',
        titleFr: 'Fin du Ramadan',
        date: DateTime(2027, 3, 9),
        color: Colors.purple,
        type: EventType.religious,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // عيد الفطر (متوقع) — 10 مارس 2027
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'eid_fitr_2027',
        title: 'عيد الفطر المبارك 🎉',
        titleFr: 'Aïd el-Fitr',
        date: DateTime(2027, 3, 10),
        color: Colors.purple,
        type: EventType.religious,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // عطلة الربيع — 19 مارس → 4 أفريل 2027
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'holiday_spring_start_2027',
        title: 'بداية عطلة الربيع',
        titleFr: 'Début des vacances de printemps',
        date: DateTime(2027, 3, 19),
        color: Colors.blue,
        type: EventType.holiday,
        isPredefined: true,
      ),
      CalendarEvent(
        id: 'holiday_spring_end_2027',
        title: 'نهاية عطلة الربيع',
        titleFr: 'Fin des vacances de printemps',
        date: DateTime(2027, 4, 4),
        color: Colors.blue,
        type: EventType.holiday,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // عيد الاستقلال — 20 مارس 2027
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'holiday_independence_2027',
        title: 'عيد الاستقلال',
        titleFr: 'Fête de l\'Indépendance',
        date: DateTime(2027, 3, 20),
        color: Colors.red,
        type: EventType.holiday,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // ذكرى الشهداء — 9 أفريل 2027
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'holiday_martyrs_2027',
        title: 'ذكرى الشهداء',
        titleFr: 'Journée des Martyrs',
        date: DateTime(2027, 4, 9),
        color: Colors.red,
        type: EventType.holiday,
        isPredefined: true,
      ),

      // ═══════════════════════════════════════════════════════════
      // عيد الشغل — 1 ماي 2027
      // ═══════════════════════════════════════════════════════════
      CalendarEvent(
        id: 'holiday_labor_2027',
        title: 'عيد الشغل',
        titleFr: 'Fête du Travail',
        date: DateTime(2027, 5, 1),
        color: Colors.red,
        type: EventType.holiday,
        isPredefined: true,
      ),
    ];
  }

  /// 🔔 Programmer les notifications pour tous les événements
  static Future<void> scheduleAllNotifications(NotificationService service) async {
    final events = getAllEvents();
    for (final event in events) {
      await service.scheduleEventReminders(
        eventId: event.id,
        eventTitle: event.title,
        eventDate: event.date,
      );
    }
  }
}