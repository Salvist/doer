import 'package:doer/data/sources/graphql/graphql_data_source.dart';
import 'package:doer/data/sources/in_memory_cache.dart';
import 'package:doer/domain/models/workflow.dart';
import 'package:doer/domain/repositories/workflow_repository.dart';

class WorkflowRepositoryImpl implements WorkflowRepository {
  final GraphqlDataSource? dataSource;
  final InMemoryCache cache;
  const WorkflowRepositoryImpl(this.dataSource, this.cache);

  @override
  Future<List<Workflow>> getByProjectId(String projectId) async {
    final remoteWorkflows = await dataSource?.getWorkflowsByProjectId(projectId);
    return remoteWorkflows ?? cache.getWorkflowByProjectId(projectId);
  }

  @override
  Future<void> addWorkflow(Workflow workflow) async {
    await dataSource?.addWorkflow(workflow);
    cache.addWorkflow(workflow);
  }
}
