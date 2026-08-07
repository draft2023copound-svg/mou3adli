import 'package:flutter/material.dart';
import '../../models/academic_message.dart';
import 'academic_message.dart';

class VoiceMessage extends StatelessWidget {
  final AcademicMessage data;

  const VoiceMessage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return AcademicMessageWidget(
      data: data,
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                child: Icon(Icons.play_arrow),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: List.generate(
                    28,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        height: index.isEven ? 18 : 10,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${data.voiceDuration?.inSeconds ?? 0}s",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}