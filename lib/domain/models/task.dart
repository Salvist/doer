import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String workflowId;
  final String name;
  final String description;

  final int index;

  final DateTime createdAt;

  const Task({
    required this.id,
    required this.workflowId,
    required this.name,
    this.description = '',
    required this.index,
    required this.createdAt,
  });

  Task copyWith({String? workflowId, String? name, String? description, int? index}) {
    return Task(
      id: id,
      workflowId: workflowId ?? this.workflowId,
      name: name ?? this.name,
      description: description ?? this.description,
      index: index ?? this.index,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [workflowId, name, description, index, createdAt];
}
