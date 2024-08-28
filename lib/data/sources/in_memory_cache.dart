import 'package:doer/domain/models/task.dart';
import 'package:doer/domain/models/workflow.dart';

class InMemoryCache {
  InMemoryCache();

  final _workflows = <Workflow>[];
  final _tasks = <Task>[];

  void addWorkflow(Workflow workflow) {
    _workflows.add(workflow);
  }

  List<Workflow> getWorkflowByProjectId(String projectId) {
    return _workflows.where((element) => element.projectId == projectId).toList();
  }

  List<Task> getTasksByWorkflowId(String workflowId) {
    return _tasks.where((element) => element.workflowId == workflowId).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
  }
}
