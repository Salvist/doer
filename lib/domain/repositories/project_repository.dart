import 'package:doer/domain/models/project.dart';

abstract interface class ProjectRepository {
  Future<List<Project>> getAll();
}
