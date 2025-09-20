// lib/features/main_dashboard/data/models/task_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/main_dashboard_view_body.dart'
    show BoardColumn;

enum Priority { low, medium, high, urgent }

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final BoardColumn status; // backlog | todo | inProgress | done
  final Priority priority; // low | medium | high | urgent
  final DateTime? dueDate; // nullable
  final List<String> tags; // e.g., ["ui","backend"]

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.tags = const [],
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    BoardColumn? status,
    Priority? priority,
    DateTime? dueDate,
    List<String>? tags,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    priority,
    dueDate,
    tags,
  ];

  // --- Firestore mapping ---

  static String statusToString(BoardColumn s) {
    switch (s) {
      case BoardColumn.backlog:
        return 'backlog';
      case BoardColumn.todo:
        return 'todo';
      case BoardColumn.inProgress:
        return 'inProgress';
      case BoardColumn.done:
        return 'done';
    }
  }

  static BoardColumn statusFromString(String s) {
    switch (s) {
      case 'backlog':
        return BoardColumn.backlog;
      case 'todo':
        return BoardColumn.todo;
      case 'inProgress':
        return BoardColumn.inProgress;
      case 'done':
        return BoardColumn.done;
      default:
        return BoardColumn.backlog;
    }
  }

  static String priorityToString(Priority p) {
    switch (p) {
      case Priority.low:
        return 'low';
      case Priority.medium:
        return 'medium';
      case Priority.high:
        return 'high';
      case Priority.urgent:
        return 'urgent';
    }
  }

  static Priority priorityFromString(String s) {
    switch (s) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      case 'urgent':
        return Priority.urgent;
      default:
        return Priority.medium;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': statusToString(status),
      'priority': priorityToString(priority),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'tags': tags,
    };
  }

  factory TaskModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: statusFromString(data['status'] ?? 'backlog'),
      priority: priorityFromString(data['priority'] ?? 'medium'),
      dueDate: data['dueDate'] is Timestamp
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      tags: (data['tags'] as List?)?.cast<String>() ?? const [],
    );
  }
}
