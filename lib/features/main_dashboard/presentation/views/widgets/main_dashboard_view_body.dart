import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/dragable_payload_model.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_state.dart';

enum BoardColumn { backlog, todo, inProgress, done }

class MainDashboardViewBody extends StatelessWidget {
  const MainDashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoardBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "Kanban Board",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Streamline your workflow with the Kanban Board tool",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: BlocBuilder<BoardBloc, BoardState>(
                    buildWhen: (p, c) =>
                        p.lanes != c.lanes ||
                        p.hoveringColumn != c.hoveringColumn,
                    builder: (context, state) {
                      final bloc = context.read<BoardBloc>();
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Lane(
                              title: "Backlog",
                              color: const Color(0xff9895e0),
                              column: BoardColumn.backlog,
                              tasks: state.lanes[BoardColumn.backlog]!,
                              onAcceptTask: (payload, target, {insertIndex}) =>
                                  bloc.add(
                                    BoardAcceptTask(
                                      payload: payload,
                                      targetColumn: target,
                                      insertIndex: insertIndex,
                                    ),
                                  ),
                              onHover: (isHover) => bloc.add(
                                BoardSetHovering(
                                  isHover ? BoardColumn.backlog : null,
                                ),
                              ),
                              hovering:
                                  state.hoveringColumn == BoardColumn.backlog,
                              onReorder: (col, from, to) => bloc.add(
                                BoardReorderWithinColumn(
                                  column: col,
                                  fromIndex: from,
                                  toIndex: to,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Lane(
                              title: "TODO",
                              color: const Color(0xfff84a4a),
                              column: BoardColumn.todo,
                              tasks: state.lanes[BoardColumn.todo]!,
                              onAcceptTask: (payload, target, {insertIndex}) =>
                                  bloc.add(
                                    BoardAcceptTask(
                                      payload: payload,
                                      targetColumn: target,
                                      insertIndex: insertIndex,
                                    ),
                                  ),
                              onHover: (isHover) => bloc.add(
                                BoardSetHovering(
                                  isHover ? BoardColumn.todo : null,
                                ),
                              ),
                              hovering:
                                  state.hoveringColumn == BoardColumn.todo,
                              onReorder: (col, from, to) => bloc.add(
                                BoardReorderWithinColumn(
                                  column: col,
                                  fromIndex: from,
                                  toIndex: to,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Lane(
                              title: "In Progress",
                              color: const Color(0xff4a94f8),
                              column: BoardColumn.inProgress,
                              tasks: state.lanes[BoardColumn.inProgress]!,
                              onAcceptTask: (payload, target, {insertIndex}) =>
                                  bloc.add(
                                    BoardAcceptTask(
                                      payload: payload,
                                      targetColumn: target,
                                      insertIndex: insertIndex,
                                    ),
                                  ),
                              onHover: (isHover) => bloc.add(
                                BoardSetHovering(
                                  isHover ? BoardColumn.inProgress : null,
                                ),
                              ),
                              hovering:
                                  state.hoveringColumn ==
                                  BoardColumn.inProgress,
                              onReorder: (col, from, to) => bloc.add(
                                BoardReorderWithinColumn(
                                  column: col,
                                  fromIndex: from,
                                  toIndex: to,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Lane(
                              title: "Done",
                              color: const Color(0xff56c991),
                              column: BoardColumn.done,
                              tasks: state.lanes[BoardColumn.done]!,
                              onAcceptTask: (payload, target, {insertIndex}) =>
                                  bloc.add(
                                    BoardAcceptTask(
                                      payload: payload,
                                      targetColumn: target,
                                      insertIndex: insertIndex,
                                    ),
                                  ),
                              onHover: (isHover) => bloc.add(
                                BoardSetHovering(
                                  isHover ? BoardColumn.done : null,
                                ),
                              ),
                              hovering:
                                  state.hoveringColumn == BoardColumn.done,
                              onReorder: (col, from, to) => bloc.add(
                                BoardReorderWithinColumn(
                                  column: col,
                                  fromIndex: from,
                                  toIndex: to,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeader(title: title, backgroundColor: color),
                const SizedBox(height: 8),
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

class SectionHeader extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  const SectionHeader({
    super.key,
    required this.title,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Icon(Icons.add_circle_outline),
        ],
      ),
    );
  }
}

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
          feedback: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: width.clamp(220.0, 360.0),
            ),
            child: TaskCard(task: task, elevation: 12),
          ),

          childWhenDragging: Opacity(
            opacity: 0.35,
            child: TaskCard(task: task),
          ),

          dragAnchorStrategy: pointerDragAnchorStrategy,
          child: Stack(
            children: [
              TaskCard(task: task),
              Positioned(
                right: 2,
                top: 6,
                child: _TaskActionsButton(task: task),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum TaskMenuAction { edit, delete, display }

class _TaskActionsButton extends StatelessWidget {
  final TaskModel task;
  const _TaskActionsButton({required this.task});

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

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final double elevation;

  const TaskCard({super.key, required this.task, this.elevation = 4});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xff333333),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          14,
          14,
          36,
          14,
        ), // extra right padding for the menu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              task.description,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

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
