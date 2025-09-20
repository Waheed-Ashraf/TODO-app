// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const primary = Color(0xFF1F5E3B);
  static const primaryLight = Color(0xFF2D9F5D);
  static const secondary = Color(0xFFF4A91F);
  static const secondaryLight = Color.fromARGB(255, 20, 38, 90);

  // Semantic
  static const danger = Color(0xFFF84A4A);
  static const success = Color(0xFF56C991);
  static const info = Color(0xFF4A94F8);
  static const warning = Color(0xFFFFB86B);

  // Neutrals (dark UI)
  static const bg = Color(0xFF1E1E1E);
  static const surface = Color(0xFF222222);
  static const surfaceAlt = Color(0xFF2A2A2A);
  static const card = Color(0xFF333333);
  static const border = Color(0xFF3C3C3C);

  // Text
  static const text = Colors.white;
  static Color textMuted([double a = .75]) => Colors.white.withOpacity(a);
  static Color textSubtle([double a = .55]) => Colors.white.withOpacity(a);

  // ---------- PRIORITY (centralized) ----------
  // Foreground (label/icon)
  static const prioLowFg = Color(0xFF7EE787); // green
  static const prioMedFg = Color(0xFF9DB2FF); // cornflower-ish
  static const prioHighFg = Color(0xFFFFB86B); // amber
  static const prioUrgentFg = Color(0xFFFF6B6B); // red

  // Background (pill)
  static const prioLowBg = Color(0xFF2E4D2F);
  static const prioMedBg = Color(0xFF3B3F57);
  static const prioHighBg = Color(0xFF5A3A3A);
  static const prioUrgentBg = Color(0xFF5A2222);
}
