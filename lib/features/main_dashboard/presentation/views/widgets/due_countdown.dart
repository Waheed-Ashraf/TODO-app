// Due in Xd / Overdue
import 'package:flutter/material.dart';

class DueCountdown extends StatelessWidget {
  final DateTime dueDate;
  const DueCountdown({super.key, required this.dueDate});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final d0 = DateTime(today.year, today.month, today.day);
    final d1 = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final delta = d1.difference(d0).inDays;

    final text = delta < 0
        ? 'Overdue ${-delta}d'
        : delta == 0
        ? 'Due today'
        : 'Due in ${delta}d';

    final color = delta < 0
        ? const Color(0xfff84a4a)
        : delta <= 2
        ? const Color(0xffFFB86B)
        : Colors.white.withValues(alpha: .75);

    return Text(
      '• $text',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
    );
  }
}

String formatDate(DateTime d) {
  final mm = d.month.toString().padLeft(2, '0');
  final dd = d.day.toString().padLeft(2, '0');
  return '${d.year}-$mm-$dd';
}
