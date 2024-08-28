import 'package:doer/domain/models/workflow.dart';

abstract interface class WorkflowRepository {
  Future<List<Workflow>> getByProjectId(String projectId);
  Future<void> addWorkflow(Workflow workflow);
}
