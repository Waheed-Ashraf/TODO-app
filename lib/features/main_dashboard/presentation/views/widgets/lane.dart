import 'package:flutter/material.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/dragable_payload_model.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/add_task_form.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/draggable_task_card.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/gap_target.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/section_header.dart';

class Lane extends StatelessWidget {
  final String title;
  final Color color;
  final BoardColumn column;
  final List<TaskModel> tasks;
  final void Function(
    DraggedPayloadModel payload,
    BoardColumn targetColumn, {
    int? insertIndex,
  })
  onAcceptTask;
  final void Function(bool hovering) onHover;
  final bool hovering;
  final void Function(BoardColumn column, int fromIndex, int toIndex) onReorder;

  const Lane({
    super.key,
    required this.title,
    required this.color,
    required this.column,
    required this.tasks,
    required this.onAcceptTask,
    required this.onHover,
    required this.hovering,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<DraggedPayloadModel>(
      onWillAcceptWithDetails: (details) {
        onHover(true);
        return true;
      },
      onLeave: (_) => onHover(false),
      onAcceptWithDetails: (details) {
        onHover(false);
        onAcceptTask(details.data, column);
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            color: hovering ? Colors.white10 : Colors.transparent,
            border: Border.all(
              // was: color.withOpacity(0.6)
              color: hovering ? color.withValues(alpha: 0.6) : Colors.white10,
              width: hovering ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(
                title: title,
                backgroundColor: color,
                onAdd: () => showAddTaskBottomSheet(context, column),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._buildCardsWithDropGaps(context),
                      GapTarget(
                        column: column,
                        index: tasks.length,
                        onAcceptTask: onAcceptTask,
                        color: color,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCardsWithDropGaps(BuildContext context) {
    final widgets = <Widget>[];
    for (var i = 0; i < tasks.length; i++) {
      // Gap before each card (to support precise reordering/insertion)
      widgets.add(
        GapTarget(
          column: column,
          index: i,
          onAcceptTask: onAcceptTask,
          color: color,
        ),
      );

      widgets.add(
        DraggableTaskCard(
          key: ValueKey(tasks[i].id),
          task: tasks[i],
          column: column,
          index: i,
          onReorder: onReorder,
        ),
      );
      widgets.add(const SizedBox(height: 8));
    }
    return widgets;
  }
}
