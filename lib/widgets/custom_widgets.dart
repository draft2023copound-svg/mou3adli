import 'package:flutter/material.dart';

const Color kRoyalBlue = Color(0xFF1C3F7A);
const Color kMatteGold = Color(0xFFC5A059);

// Bouton principal (Plein ou Outline)
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFilled;
  const CustomButton({super.key, required this.text, this.onPressed, this.isFilled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFilled ? kRoyalBlue : Colors.white,
          foregroundColor: isFilled ? Colors.white : kRoyalBlue,
          elevation: isFilled ? 4 : 0,
          side: isFilled ? null : const BorderSide(color: kRoyalBlue, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      ),
    );
  }
}