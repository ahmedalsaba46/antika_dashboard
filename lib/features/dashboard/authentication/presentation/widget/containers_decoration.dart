import 'package:flutter/material.dart';

BoxDecoration containersDecoration(BuildContext context) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color(0xFFE0E0E0),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF2E7D32).withOpacity(.1),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ],
  );
}
