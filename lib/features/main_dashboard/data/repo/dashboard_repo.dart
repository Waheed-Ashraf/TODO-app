abstract class DashboardRepository {
  Future<void> addTask();
  Future<Map<String, dynamic>?> getTask();
  Future<void> updateTask();
  Future<void> deleteTask();
  Future<List<Map<String, dynamic>>> getAllTasksInColumn();
}
