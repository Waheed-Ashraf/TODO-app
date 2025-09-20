// lib/core/theme/text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class TextStyles {
  // Titles
  static const titleLg = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.text,
  );
  static const titleMd = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );
  static const titleSm = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );
  // Body
  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );
  static TextStyle bodyMuted([double alpha = .85]) =>
      body.copyWith(color: AppColors.textMuted(alpha));

  // Meta / labels
  static const meta = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static TextStyle metaMuted([double alpha = .8]) =>
      meta.copyWith(color: AppColors.textMuted(alpha));

  // Buttons
  static const btn = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  // Chips
  static const chip = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );
}
