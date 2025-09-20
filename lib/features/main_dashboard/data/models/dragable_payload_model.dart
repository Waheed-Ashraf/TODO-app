import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';

class DraggedPayloadModel {
  final TaskModel task;
  final BoardColumn from;
  final int fromIndex;
  DraggedPayloadModel({
    required this.task,
    required this.from,
    required this.fromIndex,
  });
}
