import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/task_menu_action.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_event.dart';

class TaskActionsButton extends StatelessWidget {
  final TaskModel task;
  const TaskActionsButton({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BoardBloc>();

    return PopupMenuButton<TaskMenuAction>(
      padding: EdgeInsets.zero,
      tooltip: 'Task actions',
      onSelected: (value) {
        switch (value) {
          case TaskMenuAction.edit:
            bloc.add(BoardEditTask(task));
            break;
          case TaskMenuAction.delete:
            bloc.add(BoardDeleteTask(task));
            break;
          case TaskMenuAction.display:
            bloc.add(BoardDisplayTask(task));
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: TaskMenuAction.edit, child: Text('Edit')),
        PopupMenuItem(value: TaskMenuAction.delete, child: Text('Delete')),
        PopupMenuItem(value: TaskMenuAction.display, child: Text('Display')),
      ],
      icon: const Icon(Icons.more_vert, size: 20),
    );
  }
}
