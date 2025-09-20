// lib/features/main_dashboard/data/repo/dashboard_repo.dart
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/main_dashboard_view_body.dart'
    show BoardColumn;

abstract class DashboardRepository {
  Future<String> addTask(TaskModel task); // returns generated id
  Future<TaskModel?> getTask(String taskId);
  Future<void> updateTask(TaskModel task); // task.id must exist
  Future<void> deleteTask(String taskId);
  Future<List<TaskModel>> getAllTasksInColumn(BoardColumn column);
}
