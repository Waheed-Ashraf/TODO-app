import 'package:flutter/material.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/dragable_payload_model.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/task_card.dart';

class DraggableTaskCard extends StatelessWidget {
  final TaskModel task;
  final BoardColumn column;
  final int index;
  final void Function(BoardColumn column, int fromIndex, int toIndex) onReorder;

  const DraggableTaskCard({
    required Key key,
    required this.task,
    required this.column,
    required this.index,
    required this.onReorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Whole card is draggable (tap + move)
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Draggable<DraggedPayloadModel>(
          data: DraggedPayloadModel(task: task, from: column, fromIndex: index),

          // Feedback (ghost) – omit actions to reduce visual noise while dragging
          feedback: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: width.clamp(220.0, 360.0),
            ),
            child: TaskCard(task: task, elevation: 12, showActions: false),
          ),
          childWhenDragging: Opacity(
            opacity: 0.35,
            child: TaskCard(task: task),
          ),
          dragAnchorStrategy: pointerDragAnchorStrategy,

          // The real card (with actions inside)
          child: TaskCard(task: task),
        );
      },
    );
  }
}
