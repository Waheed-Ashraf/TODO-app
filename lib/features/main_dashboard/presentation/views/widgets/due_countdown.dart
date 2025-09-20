import 'package:flutter/material.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
import 'package:todo_app_task/core/utils/app_text_styles.dart';

class DueCountdown extends StatelessWidget {
  final DateTime dueDate;
  const DueCountdown({super.key, required this.dueDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final delta = end.difference(today).inDays;

    final text = switch (delta) {
      < 0 => 'Overdue ${-delta}d',
      0 => 'Due today',
      _ => 'Due in ${delta}d',
    };

    final color = switch (delta) {
      < 0 => AppColors.danger,
      <= 2 => AppColors.warning,
      _ => AppColors.textMuted(.75),
    };

    return Text('• $text', style: TextStyles.meta.copyWith(color: color));
  }
}

/// YYYY-MM-DD
String formatDate(DateTime d) {
  final mm = d.month.toString().padLeft(2, '0');
  final dd = d.day.toString().padLeft(2, '0');
  return '${d.year}-$mm-$dd';
}
