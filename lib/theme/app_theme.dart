
import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF8F3EB);
  static const Color brown = Color(0xFF795C43);
  static const Color darkBrown = Color(0xFF44352A);
  static const Color beige = Color(0xFFE8D8C5);
  static const Color softBeige = Color(0xFFF1E7DA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF958779);

  static BoxDecoration card = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: brown.withValues(alpha: 0.08),
        blurRadius: 15,
        offset: const Offset(0, 5),
      ),
    ],
  );
}
