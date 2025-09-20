import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/dragable_payload_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_state.dart';

/// Narrow drop area used between cards and at the lane end to control the insert index.
class GapTarget extends StatelessWidget {
  final BoardColumn column;
  final int index;
  final void Function(
    DraggedPayloadModel payload,
    BoardColumn targetColumn, {
    int? insertIndex,
  })
  onAcceptTask;
  final Color color;

  const GapTarget({
    super.key,
    required this.column,
    required this.index,
    required this.onAcceptTask,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BoardBloc>();

    return DragTarget<DraggedPayloadModel>(
      onWillAcceptWithDetails: (details) {
        bloc.add(BoardSetGapHover(column: column, index: index));
        return true;
      },
      onLeave: (_) {
        final s = context.read<BoardBloc>().state;
        if (s.hoveredGapColumn == column && s.hoveredGapIndex == index) {
          bloc.add(const BoardSetGapHover()); // clear
        }
      },
      onAcceptWithDetails: (details) {
        bloc.add(const BoardSetGapHover()); // clear
        onAcceptTask(details.data, column, insertIndex: index);
      },
      builder: (context, candidate, rejected) {
        return BlocSelector<BoardBloc, BoardState, bool>(
          selector: (state) =>
              state.hoveredGapColumn == column &&
              state.hoveredGapIndex == index,
          builder: (context, isHovered) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: isHovered ? 22 : 12,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                // was: color.withOpacity(0.35)
                color: isHovered
                    ? color.withValues(alpha: 0.35)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          },
        );
      },
    );
  }
}
