// lib/features/main_dashboard/data/repo/dashboard_repo_imp.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/data/repo/dashboard_repo.dart';

class DashboardRepoImp implements DashboardRepository {
  final FirebaseFirestore _db;
  final String deviceId;

  DashboardRepoImp(this._db, {required this.deviceId});

  CollectionReference<Map<String, dynamic>> get _tasksCol =>
      _db.collection('users').doc(deviceId).collection('tasks');

  @override
  Future<String> addTask(TaskModel task) async {
    final ref = await _tasksCol.add(task.toMap());
    return ref.id;
  }

  @override
  Future<TaskModel?> getTask(String taskId) async {
    final doc = await _tasksCol.doc(taskId).get();
    if (!doc.exists) return null;
    return TaskModel.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _tasksCol.doc(task.id).update(task.toMap());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _tasksCol.doc(taskId).delete();
  }

  @override
  Future<List<TaskModel>> getAllTasksInColumn(BoardColumn column) async {
    final q = await _tasksCol
        .where('status', isEqualTo: TaskModel.statusToString(column))
        .orderBy('dueDate', descending: false)
        .get();

    return q.docs.map((d) => TaskModel.fromDoc(d)).toList();
  }
}
