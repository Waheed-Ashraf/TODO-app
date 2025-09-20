import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/periority_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_event.dart';

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
      child: AddTaskForm(initialColumn: column, contex: context),
    ),
  );
}

class AddTaskForm extends StatefulWidget {
  final BuildContext contex;
  final BoardColumn initialColumn;
  const AddTaskForm({required this.initialColumn, required this.contex});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
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
