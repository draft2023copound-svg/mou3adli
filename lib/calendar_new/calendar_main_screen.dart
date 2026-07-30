import 'package:flutter/material.dart';
import 'package:mou3adli/calendar_new/controllers/calendar_controller.dart';
import 'package:mou3adli/calendar_new/widgets/premium_calendar.dart';
import 'package:mou3adli/calendar_new/models/calendar_event.dart';
import 'package:mou3adli/widgets/custom_widgets.dart';

class CalendarMainScreen extends StatefulWidget {
  const CalendarMainScreen({super.key});

  @override
  State<CalendarMainScreen> createState() => _CalendarMainScreenState();
}

class _CalendarMainScreenState extends State<CalendarMainScreen> {
  late CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    final events = _controller.getEventsForDay(_controller.selectedDate);

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
      body: Column(
        children: [
          // --- Calendrier Premium ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: PremiumCalendar(
                controller: _controller,
                onDateSelected: (date) {
                  setState(() {});
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // --- En-tête événements ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Événements du ${_controller.selectedDate.day}/${_controller.selectedDate.month}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC5A059), Color(0xFFF5D799)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${events.length} événement(s)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // --- Liste ou État vide premium ---
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  kRoyalBlue.withOpacity(0.08),
                                  const Color(0xFFC5A059).withOpacity(0.04),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/calendar_illustration.png',
                                height: 160,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Journée libre ✨",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: kRoyalBlue,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Profite de ce moment de calme.",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Clique sur le bouton + pour organiser ta journée.",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _buildEventCard(event);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventBottomSheet(context),
        backgroundColor: kRoyalBlue,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: event.color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 48,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      event.timeString,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: event.typeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        event.typeLabel,
                        style: TextStyle(
                          color: event.typeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey),
            onPressed: () {
              _controller.removeEvent(event.id);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  void _showAddEventBottomSheet(BuildContext context) {
    final titleController = TextEditingController();
    final noteController = TextEditingController();
    EventType selectedType = EventType.other;
    TimeOfDay? selectedTime;
    Color selectedColor = kRoyalBlue;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Nouvel événement',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    // SUPPRESSION DU 'const' ICI
                    decoration: InputDecoration(
                      hintText: 'Titre de l\'événement',
                      filled: true,
                      fillColor: const Color(0xFFF5F7FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<EventType>(
                    value: selectedType,
                    // SUPPRESSION DU 'const' ICI
                    decoration: InputDecoration(
                      hintText: 'Type',
                      filled: true,
                      fillColor: const Color(0xFFF5F7FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: EventType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedType = value!;
                        selectedColor = switch (value) {
                          EventType.exam => Colors.red,
                          EventType.homework => Colors.orange,
                          EventType.reminder => Colors.blue,
                          EventType.other => kRoyalBlue,
                        };
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setModalState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : 'Choisir une heure',
                            style: TextStyle(
                              color: selectedTime != null ? Colors.black87 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    // SUPPRESSION DU 'const' ICI
                    decoration: InputDecoration(
                      hintText: 'Note (optionnel)',
                      filled: true,
                      fillColor: const Color(0xFFF5F7FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty) {
                          final event = CalendarEvent(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: titleController.text,
                            date: _controller.selectedDate,
                            time: selectedTime,
                            color: selectedColor,
                            type: selectedType,
                            note: noteController.text.isNotEmpty ? noteController.text : null,
                          );
                          _controller.addEvent(event);
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRoyalBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Ajouter',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}