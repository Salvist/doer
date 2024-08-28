import 'package:doer/domain/models/project.dart';
import 'package:doer/inherited_repository.dart';
import 'package:doer/presentation/project/project_controller.dart';
import 'package:doer/presentation/workflow_board.dart';
import 'package:flutter/material.dart';

class TaskBoard extends StatefulWidget {
  final Project project;
  const TaskBoard({
    super.key,
    required this.project,
  });

  @override
  State<TaskBoard> createState() => _TaskBoardState();
}

class _TaskBoardState extends State<TaskBoard> {
  late final ProjectController projectController;

  @override
  void initState() {
    projectController = ProjectController(
      widget.project,
      RepositoryScope.of(context).workflowRepository,
      RepositoryScope.of(context).taskRepository,
    );
    projectController.loadWorkflows();
    super.initState();
  }

  @override
  void dispose() {
    projectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: projectController,
        builder: (context, child) {
          final workflows = projectController.workflows;

          if (projectController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            color: Colors.red.shade50,
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    workflows.length * 2 + 1,
                    (index) {
                      if (index == workflows.length * 2) {
                        return AddWorkflowButton(
                          onTap: () {
                            setState(() {
                              // workflowControllers.add(WorkflowController(name: 'New workflow'));
                            });
                          },
                        );
                      }
                      final itemIndex = index ~/ 2;
                      if (index.isEven) {
                        final controller = workflows[itemIndex];

                        return ListenableBuilder(
                          listenable: controller,
                          builder: (BuildContext context, Widget? child) {
                            return WorkflowBoard(
                              controller,
                              onTaskAccepted: (task) {
                                final prevController =
                                    workflows.where((element) => element.workflow.id == task.workflowId).first;
                                prevController.removeTask(task);
                                controller.addTask(task);
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox(width: 8);
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class AddWorkflowButton extends StatelessWidget {
  final void Function()? onTap;

  const AddWorkflowButton({
    super.key,
    this.onTap,
  });

  static const _borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: _borderRadius,
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.add_rounded),
              Text('Add a workflow'),
            ],
          ),
        ),
      ),
    );
  }
}
