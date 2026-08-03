import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/calendar_event.dart';
import '../../services/notification_service.dart';
import '../../data/tunisian_holidays.dart';

class CalendarController extends ChangeNotifier {
  List<CalendarEvent> _events = [];
  DateTime _selectedDate = DateTime.now();
  bool _holidaysLoaded = false;

  List<CalendarEvent> get events => List.unmodifiable(_events);
  DateTime get selectedDate => _selectedDate;

  CalendarController() {
    _loadEvents();
  }

  // --- CHARGEMENT ---
  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('calendar_events');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      _events = jsonList.map((e) => CalendarEvent.fromJson(e)).toList();
    }

    // ✅ Charger les événements prédéfinis tunisiens (une seule fois)
    await _loadPredefinedHolidays();

    notifyListeners();
  }

  // ✅ CHARGER LES ÉVÉNEMENTS PRÉDÉFINIS TUNISIENS
  Future<void> _loadPredefinedHolidays() async {
    if (_holidaysLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final bool alreadyLoaded = prefs.getBool('holidays_loaded_2026_2027') ?? false;

    if (!alreadyLoaded) {
      final holidays = TunisianHolidays.getAllEvents();

      // Ajouter uniquement les événements qui n'existent pas déjà
      for (final holiday in holidays) {
        final exists = _events.any((e) => e.id == holiday.id);
        if (!exists) {
          _events.add(holiday);
        }
      }

      // Programmer les notifications
      final notificationService = NotificationService();
      await notificationService.initialize();
      await TunisianHolidays.scheduleAllNotifications(notificationService);

      // Marquer comme chargé
      await prefs.setBool('holidays_loaded_2026_2027', true);
      await _saveEvents();
    }

    _holidaysLoaded = true;
  }

  // --- SAUVEGARDE ---
  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _events.map((e) => e.toJson()).toList();
    await prefs.setString('calendar_events', jsonEncode(jsonList));
  }

  // --- SÉLECTION DE DATE ---
  void selectDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    notifyListeners();
  }

  // --- AJOUT D'ÉVÉNEMENT ---
  Future<void> addEvent(CalendarEvent event) async {
    final normalizedEvent = event.copyWith(
      date: DateTime(event.date.year, event.date.month, event.date.day),
    );
    _events.add(normalizedEvent);
    _events.sort((a, b) => a.date.compareTo(b.date));

    // ✅ Programmer les notifications pour l'événement utilisateur
    if (!normalizedEvent.isPredefined) {
      final notificationService = NotificationService();
      await notificationService.initialize();
      await notificationService.scheduleEventReminders(
        eventId: normalizedEvent.id,
        eventTitle: normalizedEvent.title,
        eventDate: normalizedEvent.date,
      );
    }

    await _saveEvents();
    notifyListeners();
  }

  // --- SUPPRESSION D'ÉVÉNEMENT ---
  Future<void> removeEvent(String id) async {
    final event = _events.firstWhere((e) => e.id == id);

    // ✅ Annuler les notifications associées
    if (!event.isPredefined) {
      final notificationService = NotificationService();
      final baseId = event.id.hashCode.abs();
      await notificationService.cancelNotification(baseId + 1);
      await notificationService.cancelNotification(baseId + 2);
      await notificationService.cancelNotification(baseId + 3);
      await notificationService.cancelNotification(baseId + 4);
    }

    _events.removeWhere((e) => e.id == id);
    await _saveEvents();
    notifyListeners();
  }

  // --- RÉCUPÉRER LES ÉVÉNEMENTS D'UN JOUR PRÉCIS ---
  List<CalendarEvent> getEventsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _events
        .where((e) =>
            e.date.year == normalized.year &&
            e.date.month == normalized.month &&
            e.date.day == normalized.day)
        .toList();
  }

  // --- RÉCUPÉRER LES ÉVÉNEMENTS D'UN MOIS ---
  Map<DateTime, List<CalendarEvent>> getEventsGroupedByDay() {
    final Map<DateTime, List<CalendarEvent>> grouped = {};
    for (final event in _events) {
      final dayKey = DateTime(event.date.year, event.date.month, event.date.day);
      if (!grouped.containsKey(dayKey)) {
        grouped[dayKey] = [];
      }
      grouped[dayKey]!.add(event);
    }
    return grouped;
  }

  // --- RÉINITIALISER ---
  Future<void> clearAllEvents() async {
    // Annuler toutes les notifications
    final notificationService = NotificationService();
    await notificationService.cancelAllNotifications();

    _events.clear();

    // Réinitialiser le flag des vacances
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('holidays_loaded_2026_2027', false);

    await _saveEvents();
    notifyListeners();
  }
}