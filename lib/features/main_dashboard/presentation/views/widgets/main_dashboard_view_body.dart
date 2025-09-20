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
    return Scaffold(
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
                            hovering: state.hoveringColumn == BoardColumn.todo,
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
                                state.hoveringColumn == BoardColumn.inProgress,
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
                            hovering: state.hoveringColumn == BoardColumn.done,
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
                SectionHeader(
                  title: title,
                  backgroundColor: color,
                  onAdd: () => showAddTaskBottomSheet(context, column),
                ),
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
  final VoidCallback onAdd; // ⬅️ new

  const SectionHeader({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.onAdd,
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
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: onAdd,
            tooltip: 'Add Task',
          ),
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
  final bool showActions;

  const TaskCard({
    super.key,
    required this.task,
    this.elevation = 4,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        task.dueDate != null &&
        DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        ).isBefore(DateTime.now());

    final dueText = task.dueDate == null
        ? 'No due date'
        : _formatDate(task.dueDate!);

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(12),
      color: const Color(0xff333333),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Priority pill + actions
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _PriorityPill(priority: task.priority),
                const Spacer(),
                if (showActions) _TaskActionsButton(task: task),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            // Description
            if (task.description.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                task.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],

            // Tags
            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: task.tags
                    .map((t) => _TagChip(text: t))
                    .toList(growable: false),
              ),
            ],

            const SizedBox(height: 10),

            // Footer: Due date
            Row(
              children: [
                Icon(
                  Icons.event,
                  size: 16,
                  color: isOverdue
                      ? const Color(0xfff84a4a)
                      : Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 6),
                Text(
                  dueText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isOverdue
                        ? const Color(0xfff84a4a)
                        : Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                if (task.dueDate != null) ...[
                  const SizedBox(width: 8),
                  _DueCountdown(dueDate: task.dueDate!),
                ],
              ],
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

Future<void> showAddTaskBottomSheet(BuildContext context, BoardColumn column) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: const Color(0xff222222),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: _AddTaskForm(initialColumn: column, contex: context),
    ),
  );
}

class _AddTaskForm extends StatefulWidget {
  final BuildContext contex;
  final BoardColumn initialColumn;
  const _AddTaskForm({required this.initialColumn, required this.contex});

  @override
  State<_AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<_AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _tags = TextEditingController();
  Priority _priority = Priority.medium;
  DateTime? _due;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _tags.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _description,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Priority>(
                        value: _priority,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: Priority.low,
                            child: Text('Low'),
                          ),
                          DropdownMenuItem(
                            value: Priority.medium,
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(
                            value: Priority.high,
                            child: Text('High'),
                          ),
                          DropdownMenuItem(
                            value: Priority.urgent,
                            child: Text('Urgent'),
                          ),
                        ],
                        onChanged: (p) =>
                            setState(() => _priority = p ?? Priority.medium),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 5),
                        initialDate: _due ?? now,
                        builder: (ctx, child) {
                          // keep dark look
                          return Theme(data: Theme.of(ctx), child: child!);
                        },
                      );
                      if (picked != null) setState(() => _due = picked);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _due == null
                            ? 'Not set'
                            : '${_due!.year}-${_due!.month.toString().padLeft(2, '0')}-${_due!.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _tags,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Create Task'),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final tags = _tags.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  // NOTE: id will be generated by repo, so pass empty here
                  final task = TaskModel(
                    id: '',
                    title: _title.text.trim(),
                    description: _description.text.trim(),
                    status: widget.initialColumn,
                    priority: _priority,
                    dueDate: _due,
                    tags: tags,
                  );

                  widget.contex.read<BoardBloc>().add(BoardAddTask(task));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Priority pill
class _PriorityPill extends StatelessWidget {
  final Priority priority;
  const _PriorityPill({required this.priority});

  @override
  Widget build(BuildContext context) {
    final bg = _priorityBg(priority);
    final fg = _priorityFg(priority);
    final label = _priorityLabel(priority);
    final icon = _priorityIcon(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: .25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }

  static Color _priorityBg(Priority p) {
    switch (p) {
      case Priority.low:
        return const Color(0xff2e4d2f);
      case Priority.medium:
        return const Color(0xff3b3f57);
      case Priority.high:
        return const Color(0xff5a3a3a);
      case Priority.urgent:
        return const Color(0xff5a2222);
    }
  }

  static Color _priorityFg(Priority p) {
    switch (p) {
      case Priority.low:
        return const Color(0xff7EE787);
      case Priority.medium:
        return const Color(0xff9DB2FF);
      case Priority.high:
        return const Color(0xffFFB86B);
      case Priority.urgent:
        return const Color(0xffFF6B6B);
    }
  }

  static String _priorityLabel(Priority p) {
    switch (p) {
      case Priority.low:
        return 'LOW';
      case Priority.medium:
        return 'MEDIUM';
      case Priority.high:
        return 'HIGH';
      case Priority.urgent:
        return 'URGENT';
    }
  }

  static IconData _priorityIcon(Priority p) {
    switch (p) {
      case Priority.low:
        return Icons.arrow_downward_rounded;
      case Priority.medium:
        return Icons.stream_rounded;
      case Priority.high:
        return Icons.arrow_upward_rounded;
      case Priority.urgent:
        return Icons.priority_high_rounded;
    }
  }
}

// Tags as small chips
class _TagChip extends StatelessWidget {
  final String text;
  const _TagChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xff2b2b2b),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: .9),
          letterSpacing: .2,
        ),
      ),
    );
  }
}

// Due in Xd / Overdue
class _DueCountdown extends StatelessWidget {
  final DateTime dueDate;
  const _DueCountdown({required this.dueDate});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final d0 = DateTime(today.year, today.month, today.day);
    final d1 = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final delta = d1.difference(d0).inDays;

    final text = delta < 0
        ? 'Overdue ${-delta}d'
        : delta == 0
        ? 'Due today'
        : 'Due in ${delta}d';

    final color = delta < 0
        ? const Color(0xfff84a4a)
        : delta <= 2
        ? const Color(0xffFFB86B)
        : Colors.white.withValues(alpha: .75);

    return Text(
      '• $text',
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
    );
  }
}

String _formatDate(DateTime d) {
  final mm = d.month.toString().padLeft(2, '0');
  final dd = d.day.toString().padLeft(2, '0');
  return '${d.year}-$mm-$dd';
}
