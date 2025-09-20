import 'package:flutter/material.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/periority_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/due_countdown.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/periority_bill.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/tag_chip.dart';

Future<void> showTaskDetailsDialog(BuildContext context, TaskModel task) {
  final theme = Theme.of(context);
  final textMuted = Colors.white.withValues(alpha: .75);

  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: const Color(0xff2a2a2a),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  PriorityPill(priority: task.priority),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff333333),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Status: ${TaskModel.statusToString(task.status).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 11,
                        color: textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (task.description.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: .9),
                  ),
                ),
              ],
              if (task.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: task.tags.map((t) => TagChip(text: t)).toList(),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.event,
                    size: 18,
                    color: Colors.white.withValues(alpha: .8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    task.dueDate == null
                        ? 'No due date'
                        : formatDate(task.dueDate!),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(width: 8),
                    DueCountdown(dueDate: task.dueDate!),
                  ],
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    ),
  );
}

// ---------- EDIT ----------
Future<TaskModel?> showEditTaskBottomSheet(
  BuildContext context,
  TaskModel task,
) async {
  return showModalBottomSheet<TaskModel>(
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
      child: _EditTaskForm(task: task),
    ),
  );
}

class _EditTaskForm extends StatefulWidget {
  final TaskModel task;
  const _EditTaskForm({required this.task});
  @override
  State<_EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<_EditTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title = TextEditingController(
    text: widget.task.title,
  );
  late final TextEditingController _description = TextEditingController(
    text: widget.task.description,
  );
  late final TextEditingController _tags = TextEditingController(
    text: widget.task.tags.join(', '),
  );
  late Priority _priority = widget.task.priority;
  DateTime? _due;
  late BoardColumn _status = widget.task.status;

  @override
  void initState() {
    super.initState();
    _due = widget.task.dueDate;
  }

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
                  'Edit Task',
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
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<BoardColumn>(
                        value: _status,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: BoardColumn.backlog,
                            child: Text('Backlog'),
                          ),
                          DropdownMenuItem(
                            value: BoardColumn.todo,
                            child: Text('To Do'),
                          ),
                          DropdownMenuItem(
                            value: BoardColumn.inProgress,
                            child: Text('In Progress'),
                          ),
                          DropdownMenuItem(
                            value: BoardColumn.done,
                            child: Text('Done'),
                          ),
                        ],
                        onChanged: (s) =>
                            setState(() => _status = s ?? widget.task.status),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 5),
                        initialDate: _due ?? now,
                        builder: (ctx, child) =>
                            Theme(data: Theme.of(ctx), child: child!),
                      );
                      if (picked != null) setState(() => _due = picked);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Due date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_due == null ? 'Not set' : formatDate(_due!)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _tags,
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save changes'),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  final tags = _tags.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  final updated = widget.task.copyWith(
                    title: _title.text.trim(),
                    description: _description.text.trim(),
                    status: _status,
                    priority: _priority,
                    dueDate: _due,
                    tags: tags,
                  );

                  Navigator.pop(context, updated); // return updated task
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- DELETE ----------
Future<bool?> confirmDeleteTask(BuildContext context, TaskModel task) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xff2a2a2a),
      title: const Text('Delete task', style: TextStyle(color: Colors.white)),
      content: Text(
        'Are you sure you want to delete “${task.title}”? This action cannot be undone.',
        style: TextStyle(color: Colors.white.withValues(alpha: .9)),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, false),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xfff84a4a),
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
