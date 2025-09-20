import 'package:flutter/material.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/periority_enum.dart';

class PriorityPill extends StatelessWidget {
  final Priority priority;
  const PriorityPill({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    final bg = _bg(priority);
    final fg = _fg(priority);
    final label = _label(priority);
    final icon = _icon(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: .2,
            ).copyWith(color: fg),
          ),
        ],
      ),
    );
  }

  Color _bg(Priority p) {
    switch (p) {
      case Priority.low:
        return AppColors.prioLowBg;
      case Priority.medium:
        return AppColors.prioMedBg;
      case Priority.high:
        return AppColors.prioHighBg;
      case Priority.urgent:
        return AppColors.prioUrgentBg;
    }
  }

  Color _fg(Priority p) {
    switch (p) {
      case Priority.low:
        return AppColors.prioLowFg;
      case Priority.medium:
        return AppColors.prioMedFg;
      case Priority.high:
        return AppColors.prioHighFg;
      case Priority.urgent:
        return AppColors.prioUrgentFg;
    }
  }

  String _label(Priority p) {
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

  IconData _icon(Priority p) {
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
