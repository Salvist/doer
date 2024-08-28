import 'package:doer/domain/models/project.dart';
import 'package:doer/domain/models/workflow.dart';
import 'package:doer/domain/repositories/task_repository.dart';
import 'package:doer/domain/repositories/workflow_repository.dart';
import 'package:doer/presentation/workflow/workflow_controller.dart';
import 'package:flutter/foundation.dart';

class ProjectController extends ChangeNotifier {
  final Project project;
  final WorkflowRepository _workflowRepository;
  final TaskRepository _taskRepository;
  ProjectController(this.project, this._workflowRepository, this._taskRepository);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final _workflows = <WorkflowController>[];
  List<WorkflowController> get workflows => List.unmodifiable(_workflows);

  Future<void> loadWorkflows() async {
    _isLoading = true;
    notifyListeners();
    _workflows.clear();

    final workflows = await _workflowRepository.getByProjectId(project.id);
    _workflows.addAll(workflows.map((e) => WorkflowController(e, _taskRepository)));

    _isLoading = false;
    notifyListeners();
  }

  void addWorkflow(Workflow workflow) {
    _workflows.add(WorkflowController(workflow, _taskRepository));
    notifyListeners();
  }

  @override
  void dispose() {
    for (final w in _workflows) {
      w.dispose();
    }
    super.dispose();
  }
}
