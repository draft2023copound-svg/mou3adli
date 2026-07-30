import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/calendar_event.dart';

class CalendarController extends ChangeNotifier {
  List<CalendarEvent> _events = [];
  DateTime _selectedDate = DateTime.now();

  // Getters
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
    notifyListeners();
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
  void addEvent(CalendarEvent event) {
    // On normalise la date de l'événement pour qu'elle soit au bon format
    final normalizedEvent = event.copyWith(
      date: DateTime(event.date.year, event.date.month, event.date.day),
    );
    _events.add(normalizedEvent);
    // Trier les événements par date (du plus récent au plus ancien)
    _events.sort((a, b) => a.date.compareTo(b.date));
    _saveEvents();
    notifyListeners();
  }

  // --- SUPPRESSION D'ÉVÉNEMENT ---
  void removeEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    _saveEvents();
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

  // --- RÉCUPÉRER LES ÉVÉNEMENTS D'UN MOIS (Pour les marqueurs) ---
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

  // --- RÉINITIALISER LES ÉVÉNEMENTS (Pour le debug) ---
  void clearAllEvents() {
    _events.clear();
    _saveEvents();
    notifyListeners();
  }
}