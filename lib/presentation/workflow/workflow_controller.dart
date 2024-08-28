import 'package:doer/domain/models/task.dart';
import 'package:doer/domain/models/workflow.dart';
import 'package:doer/domain/repositories/task_repository.dart';
import 'package:flutter/foundation.dart';

class WorkflowController extends ChangeNotifier {
  final Workflow workflow;
  final TaskRepository _taskRepository;
  WorkflowController(this.workflow, this._taskRepository) {
    loadTasks();
  }

  final _tasks = <Task>[];
  List<Task> get tasks => List.unmodifiable(_tasks);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    final tasks = await _taskRepository.getByWorkflowId(workflow.id);
    _tasks.addAll(tasks);

    _isLoading = false;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task.copyWith(workflowId: workflow.id));
    notifyListeners();
  }

  void editTask(Task task) {
    _tasks[task.index] = task;
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
