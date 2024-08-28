import 'package:doer/domain/models/task.dart';

abstract interface class TaskRepository {
  Future<List<Task>> getByWorkflowId(String workflowId);

  Future<void> addTask(Task task);
}
