import 'package:flutter/material.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
import 'package:todo_app_task/core/utils/app_text_styles.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/due_countdown.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/periority_bill.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/tag_chip.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/task_actions_button.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final double elevation;
  final bool showActions;

  const TaskCard({
    super.key,
    required this.task,
    this.elevation = 4,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isOverdue =
        task.dueDate != null &&
        DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        ).isBefore(DateTime.now());

    final dueText = task.dueDate == null
        ? 'No due date'
        : formatDate(task.dueDate!);

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(12),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.titleSm.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (showActions) TaskActionsButton(task: task),
              ],
            ),

            // Description
            if (task.description.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                task.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.body.copyWith(color: AppColors.textMuted(.9)),
              ),
            ],

            const SizedBox(height: 8),
            // Priority pill (right-aligned)
            Align(
              alignment: Alignment.centerRight,
              child: PriorityPill(priority: task.priority),
            ),

            // Tags
            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: task.tags
                    .map((t) => TagChip(text: t))
                    .toList(growable: false),
              ),
            ],

            const SizedBox(height: 10),

            // Footer: Due date + countdown
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  Icons.event,
                  size: 16,
                  color: isOverdue ? AppColors.danger : AppColors.textMuted(.8),
                ),
                const SizedBox(width: 6),
                Text(
                  dueText,
                  style: TextStyles.meta.copyWith(
                    color: isOverdue
                        ? AppColors.danger
                        : AppColors.textMuted(.9),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (task.dueDate != null) ...[
                  const SizedBox(width: 8),
                  DueCountdown(dueDate: task.dueDate!),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
