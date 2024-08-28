import 'package:doer/data/sources/graphql/graphql_data_source.dart';
import 'package:doer/data/sources/in_memory_cache.dart';
import 'package:doer/data/task_repository.dart';
import 'package:doer/data/workflow_repository.dart';
import 'package:doer/inherited_repository.dart';
import 'package:doer/presentation/board_scope.dart';
import 'package:doer/presentation/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  final graphql = await GraphqlDataSourceImpl.initialize('http://localhost:4000');
  final cache = InMemoryCache();

  final workflowRepository = WorkflowRepositoryImpl(graphql, cache);
  final taskRepository = TaskRepositoryImpl(graphql, cache);

  runApp(
    RepositoryScope(
      workflowRepository: workflowRepository,
      taskRepository: taskRepository,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BoardScope(
      child: MaterialApp(
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.red.shade50,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
