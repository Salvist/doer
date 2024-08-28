import 'dart:convert';
import 'dart:developer';

import 'package:doer/domain/models/project.dart';
import 'package:doer/domain/models/task.dart';
import 'package:doer/domain/models/workflow.dart';
import 'package:http/http.dart' as http;

abstract interface class GraphqlDataSource {
  Future<List<Project>> getAllProject();
  Future<List<Workflow>> getWorkflowsByProjectId(String projectId);
  Future<List<Task>> getTasksByWorkflowId(String workflowId);
  Future<Workflow> addWorkflow(Workflow workflow);
}

class GraphqlDataSourceImpl implements GraphqlDataSource {
  final String _url;
  const GraphqlDataSourceImpl._(this._url);

  static Future<GraphqlDataSourceImpl?> initialize(String url) async {
    return GraphqlDataSourceImpl._(url);
  }

  @override
  Future<List<Project>> getAllProject() async {
    http.post(Uri.parse(_url));
    return [];
  }

  @override
  Future<List<Workflow>> getWorkflowsByProjectId(String projectId) async {
    try {
      const query = '''query GetWorkflows(\$projectId: ID!){
  workflow(projectId: \$projectId) {
    id
    projectId
    name
  }
}
    ''';

      final body = jsonEncode({
        'query': query,
        'operationName': 'GetWorkflows',
        "variables": {"projectId": projectId}
      });
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data']['workflow'] as List<dynamic>;
      final workflows = data.map(
        (e) => Workflow(
          id: e['id'],
          projectId: projectId,
          name: e['name'],
        ),
      );
      return workflows.toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<Task>> getTasksByWorkflowId(String workflowId) async {
    try {
      const operationName = 'GetTasks';

      const query = '''query $operationName(\$workflowId: ID!){
  tasksByWorkflowId(workflowId: \$workflowId) {
    id
    workflowId
    index
    name
    description
    createdAt
  }
}
    ''';

      final body = jsonEncode({
        'query': query,
        'operationName': operationName,
        "variables": {"workflowId": workflowId}
      });
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data']['tasksByWorkflowId'] as List<dynamic>;
      final tasks = data.map(
        (e) => Task(
          id: e['id'],
          workflowId: workflowId,
          index: e['index'],
          name: e['name'],
          description: e['description'],
          createdAt: DateTime.fromMillisecondsSinceEpoch(e['createdAt']),
        ),
      );
      return tasks.toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<Workflow> addWorkflow(Workflow workflow) async {
    const operationName = 'AddWorkflow';
    try {
      const query = '''mutation $operationName(\$id: ID!, \$projectId: String!, \$name: String!){
  addWorkflow(projectId: \$projectId) {
    id
    projectId
    name
  }
}
    ''';

      final body = jsonEncode({
        'query': query,
        'operationName': 'GetWorkflows',
        "variables": {
          "id": workflow.id,
          "projectId": workflow.projectId,
          "name": workflow.name,
        }
      });
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      // final json = jsonDecode(response.body) as Map<String, dynamic>;
      // final data = json['data']['workflow'] as List<dynamic>;
      // final workflows = data.map(
      //   (e) => Workflow(
      //     id: e['id'],
      //     projectId: projectId,
      //     name: e['name'],
      //   ),
      // );
      // return workflows.toList();
      return workflow;
    } catch (e) {
      print(e);
      return workflow;
    }
  }
}
