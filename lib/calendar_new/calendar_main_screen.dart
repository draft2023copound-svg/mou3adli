import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/calendar_controller.dart';
import 'widgets/premium_calendar.dart';

class CalendarMainScreen extends StatefulWidget {
  const CalendarMainScreen({super.key});

  @override
  State<CalendarMainScreen> createState() => _CalendarMainScreenState();
}

class _CalendarMainScreenState extends State<CalendarMainScreen> {
  late CalendarController controller;
  final Map<DateTime, int> _eventCounts = {};

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString("calendar_events");
    if (json == null) return;

    // À développer plus tard avec tes événements
    setState(() {});
  }

  // --- FENÊTRE D'AJOUT D'ÉVÉNEMENT (À développer plus tard) ---
  void _openAddEventBottomSheet() {
    // Placeholder pour l'ajout d'événement
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Calendrier",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: PremiumCalendar(
            controller: controller,
            events: _eventCounts,
            onSelect: (date) {
              setState(() {});
            },
          ),
        ),
      ),
      // --- AJOUT DU BOUTON FLOTTANT ICI ---
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddEventBottomSheet,
        backgroundColor: const Color(0xFF4F8CFF),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}