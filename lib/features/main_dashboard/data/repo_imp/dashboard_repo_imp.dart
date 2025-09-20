import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_task/core/errors/exceptions.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/data/repo/dashboard_repo.dart';

class DashboardRepoImp implements DashboardRepository {
  final FirebaseFirestore _db;
  final String deviceId;

  DashboardRepoImp(this._db, {required this.deviceId});

  CollectionReference<Map<String, dynamic>> get _tasksCol =>
      _db.collection('users').doc(deviceId).collection('tasks');

  static const _defaultTimeout = Duration(seconds: 15);

  Future<T> _guard<T>(Future<T> Function() op) async {
    try {
      return await op().timeout(_defaultTimeout);
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw AppException(
            'You don’t have permission to perform this action.',
          );
        case 'unavailable':
          throw AppException(
            'Service temporarily unavailable. Please try again.',
          );
        case 'not-found':
          throw AppException('The requested item was not found.');

        default:
          throw AppException(
            e.message ?? 'Something went wrong with the server.',
          );
      }
    } on SocketException {
      throw AppException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw AppException('Request timed out. Please try again.');
    } catch (_) {
      throw AppException('Unexpected error. Please try again.');
    }
  }

  @override
  Future<String> addTask(TaskModel task) => _guard(() async {
    final ref = await _tasksCol.add(task.toMap());
    return ref.id;
  });

  @override
  Future<TaskModel?> getTask(String taskId) => _guard(() async {
    final doc = await _tasksCol.doc(taskId).get();
    if (!doc.exists) return null;
    return TaskModel.fromDoc(doc);
  });

  @override
  Future<void> updateTask(TaskModel task) => _guard(() async {
    await _tasksCol.doc(task.id).update(task.toMap());
  });

  @override
  Future<void> deleteTask(String taskId) => _guard(() async {
    await _tasksCol.doc(taskId).delete();
  });

  @override
  Future<List<TaskModel>> getAllTasksInColumn(BoardColumn column) =>
      _guard(() async {
        final q = await _tasksCol
            .where('status', isEqualTo: TaskModel.statusToString(column))
            .orderBy('dueDate', descending: false)
            .get();
        return q.docs.map((d) => TaskModel.fromDoc(d)).toList();
      });
}
