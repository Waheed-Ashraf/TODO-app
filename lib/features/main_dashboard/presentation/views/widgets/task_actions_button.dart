import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/core/utils/app_colors.dart';
import 'package:todo_app_task/core/utils/app_text_styles.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/task_menu_action.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/task_dialogs_and_sheets.dart';

class TaskActionsButton extends StatelessWidget {
  final TaskModel task;
  const TaskActionsButton({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BoardBloc>();

    return PopupMenuButton<TaskMenuAction>(
      tooltip: 'Task actions',
      color: Theme.of(context).cardColor, // styled to match cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (value) async {
        switch (value) {
          case TaskMenuAction.display:
            showTaskDetailsDialog(context, task);
            break;

          case TaskMenuAction.edit:
            final updated = await showEditTaskBottomSheet(context, task);
            if (updated != null) {
              bloc.add(BoardUpdateTask(updated));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Task updated')));
            }
            break;

          case TaskMenuAction.delete:
            final confirmed = await confirmDeleteTask(context, task);
            if (confirmed == true) {
              bloc.add(
                BoardDeleteTaskById(taskId: task.id, column: task.status),
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Task deleted')));
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: TaskMenuAction.display,
          child: Text(
            'Display',
            style: TextStyles.body.copyWith(color: AppColors.text),
          ),
        ),
        PopupMenuItem(
          value: TaskMenuAction.edit,
          child: Text(
            'Edit',
            style: TextStyles.body.copyWith(color: AppColors.text),
          ),
        ),
        PopupMenuItem(
          value: TaskMenuAction.delete,
          child: Text(
            'Delete',
            style: TextStyles.body.copyWith(color: AppColors.text),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert, size: 20, color: AppColors.text),
    );
  }
}
