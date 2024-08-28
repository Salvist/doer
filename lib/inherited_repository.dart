import 'package:doer/domain/repositories/task_repository.dart';
import 'package:doer/domain/repositories/workflow_repository.dart';
import 'package:flutter/widgets.dart';

class RepositoryScope extends InheritedWidget {
  final WorkflowRepository workflowRepository;
  final TaskRepository taskRepository;

  const RepositoryScope({
    super.key,
    required this.workflowRepository,
    required this.taskRepository,
    required super.child,
  });

  static RepositoryScope of(BuildContext context) {
    final RepositoryScope? result = context.findAncestorWidgetOfExactType<RepositoryScope>();
    assert(result != null, 'No InheritedRepository found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RepositoryScope oldWidget) => false;
}
