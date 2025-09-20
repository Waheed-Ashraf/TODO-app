import 'package:equatable/equatable.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/dragable_payload_model.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/main_dashboard_view_body.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();
  @override
  List<Object?> get props => [];
}

class BoardSetHovering extends BoardEvent {
  final BoardColumn? column;
  const BoardSetHovering(this.column);
  @override
  List<Object?> get props => [column];
}

class BoardAcceptTask extends BoardEvent {
  final DraggedPayloadModel payload;
  final BoardColumn targetColumn;
  final int? insertIndex;
  const BoardAcceptTask({
    required this.payload,
    required this.targetColumn,
    this.insertIndex,
  });
  @override
  List<Object?> get props => [payload, targetColumn, insertIndex];
}

class BoardReorderWithinColumn extends BoardEvent {
  final BoardColumn column;
  final int fromIndex;
  final int toIndex;
  const BoardReorderWithinColumn({
    required this.column,
    required this.fromIndex,
    required this.toIndex,
  });
  @override
  List<Object?> get props => [column, fromIndex, toIndex];
}

class BoardSetGapHover extends BoardEvent {
  final BoardColumn? column; // null = no gap hovered
  final int? index; // null = no gap hovered
  const BoardSetGapHover({this.column, this.index});

  @override
  List<Object?> get props => [column, index];
}

// board_event.dart
class BoardEditTask extends BoardEvent {
  final TaskModel task;
  const BoardEditTask(this.task);
  @override
  List<Object?> get props => [task];
}

class BoardDeleteTask extends BoardEvent {
  final TaskModel task;
  const BoardDeleteTask(this.task);
  @override
  List<Object?> get props => [task];
}

class BoardDisplayTask extends BoardEvent {
  final TaskModel task;
  const BoardDisplayTask(this.task);
  @override
  List<Object?> get props => [task];
}

class BoardLoadAllColumns extends BoardEvent {}

class BoardAddTask extends BoardEvent {
  final TaskModel task;
  const BoardAddTask(this.task);
}

class BoardUpdateTask extends BoardEvent {
  final TaskModel task;
  const BoardUpdateTask(this.task);
}

class BoardDeleteTaskById extends BoardEvent {
  final String taskId;
  final BoardColumn column; // to update UI immediately
  const BoardDeleteTaskById({required this.taskId, required this.column});
}
