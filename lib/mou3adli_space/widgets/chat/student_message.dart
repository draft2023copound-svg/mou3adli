import 'package:flutter/material.dart';
import '../../models/academic_message.dart';
import 'academic_message.dart';

class StudentMessage extends StatelessWidget {
  final AcademicMessage data;

  const StudentMessage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return AcademicMessageWidget(
      data: data,
      child: Text(
        data.message,
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: data.mine ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}