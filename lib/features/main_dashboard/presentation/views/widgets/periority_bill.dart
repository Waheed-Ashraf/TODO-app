// Priority pill
import 'package:flutter/material.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/periority_enum.dart';

class PriorityPill extends StatelessWidget {
  final Priority priority;
  const PriorityPill({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final bg = priorityBg(priority);
    final fg = priorityFg(priority);
    final label = priorityLabel(priority);
    final icon = priorityIcon(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: .25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }

  static Color priorityBg(Priority p) {
    switch (p) {
      case Priority.low:
        return const Color(0xff2e4d2f);
      case Priority.medium:
        return const Color(0xff3b3f57);
      case Priority.high:
        return const Color(0xff5a3a3a);
      case Priority.urgent:
        return const Color(0xff5a2222);
    }
  }

  static Color priorityFg(Priority p) {
    switch (p) {
      case Priority.low:
        return const Color(0xff7EE787);
      case Priority.medium:
        return const Color(0xff9DB2FF);
      case Priority.high:
        return const Color(0xffFFB86B);
      case Priority.urgent:
        return const Color(0xffFF6B6B);
    }
  }

  static String priorityLabel(Priority p) {
    switch (p) {
      case Priority.low:
        return 'LOW';
      case Priority.medium:
        return 'MEDIUM';
      case Priority.high:
        return 'HIGH';
      case Priority.urgent:
        return 'URGENT';
    }
  }

  static IconData priorityIcon(Priority p) {
    switch (p) {
      case Priority.low:
        return Icons.arrow_downward_rounded;
      case Priority.medium:
        return Icons.stream_rounded;
      case Priority.high:
        return Icons.arrow_upward_rounded;
      case Priority.urgent:
        return Icons.priority_high_rounded;
    }
  }
}
