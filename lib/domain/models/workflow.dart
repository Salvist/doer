import 'package:equatable/equatable.dart';

class Workflow extends Equatable {
  final String id;
  final String projectId;

  final String name;

  const Workflow({
    required this.id,
    required this.projectId,
    required this.name,
  });

  @override
  List<Object?> get props => [id, projectId, name];
}
