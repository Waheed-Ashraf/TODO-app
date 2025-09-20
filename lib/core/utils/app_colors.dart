// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const primary = Color(0xFF1F5E3B);
  static const primaryLight = Color(0xFF2D9F5D);
  static const secondary = Color(0xFFF4A91F);
  static const secondaryLight = Color(0xFFF8C76D);

  // Semantic
  static const danger = Color(0xFFF84A4A);
  static const success = Color(0xFF56C991);
  static const info = Color(0xFF4A94F8);

  // Neutrals (dark UI)
  static const bg = Color(0xFF1E1E1E); // page background
  static const surface = Color(0xFF222222); // sheets/bottom sheets
  static const surfaceAlt = Color(0xFF2A2A2A); // dialogs
  static const card = Color(0xFF333333); // cards
  static const border = Color(0xFF3C3C3C);

  // Text
  static const text = Colors.white;
  static Color textMuted([double a = .75]) => Colors.white.withOpacity(a);
  static Color textSubtle([double a = .55]) => Colors.white.withOpacity(a);
}
