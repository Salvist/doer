import 'package:doer/data/sources/graphql/graphql_data_source.dart';
import 'package:doer/data/sources/in_memory_cache.dart';
import 'package:doer/domain/models/task.dart';
import 'package:doer/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final GraphqlDataSource? graphqlDataSource;
  final InMemoryCache cache;
  const TaskRepositoryImpl(this.graphqlDataSource, this.cache);

  @override
  Future<List<Task>> getByWorkflowId(String workflowId) async {
    final tasks = await graphqlDataSource?.getTasksByWorkflowId(workflowId);
    return tasks ?? cache.getTasksByWorkflowId(workflowId);
  }

  @override
  Future<void> addTask(Task task) async {}
}
