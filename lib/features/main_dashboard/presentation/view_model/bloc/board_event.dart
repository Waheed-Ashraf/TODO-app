import 'package:equatable/equatable.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/dragable_payload_model.dart';
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
