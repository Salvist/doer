import 'package:doer/domain/models/task.dart';
import 'package:doer/presentation/board_scope.dart';
import 'package:doer/presentation/task/widgets/task_dialog.dart';
import 'package:doer/presentation/task_card.dart';
import 'package:doer/presentation/workflow/workflow_controller.dart';
import 'package:flutter/material.dart';

class WorkflowBoard extends StatefulWidget {
  final WorkflowController controller;
  final double taskHeight;
  final void Function(Task task)? onTaskAccepted;

  const WorkflowBoard(
    this.controller, {
    super.key,
    this.taskHeight = 120,
    this.onTaskAccepted,
  });

  @override
  State<WorkflowBoard> createState() => _WorkflowBoardState();
}

class _WorkflowBoardState extends State<WorkflowBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      width: 240,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text(widget.controller.workflow.name),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      ...widget.controller.tasks.map(
                        (e) => Draggable(
                          data: e,
                          onDragStarted: () {
                            BoardScope.of(context).toggleDrag(true);
                          },
                          onDragEnd: (details) {
                            BoardScope.of(context).toggleDrag(false);
                          },
                          feedback: TaskCard(e, height: widget.taskHeight),
                          child: GestureDetector(
                            onDoubleTap: () async {
                              final editedTask =
                                  await TaskDialog.show(context, workflow: widget.controller.workflow, task: e);
                              if (editedTask == null) return;
                              widget.controller.editTask(editedTask);
                            },
                            child: TaskCard(e, height: widget.taskHeight),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AddTaskButton(
                        onPressed: () async {
                          final task = await TaskDialog.show(context, workflow: widget.controller.workflow);
                          if (task == null) return;

                          widget.controller.addTask(task.copyWith(index: widget.controller.tasks.length));
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < widget.controller.tasks.length + 1; i++)
                        IgnorePointer(
                          ignoring: !BoardScope.of(context).value.isDragging,
                          child: DragTarget<Task>(
                            onAcceptWithDetails: (details) {
                              final task = details.data;
                              if (widget.onTaskAccepted != null) {
                                widget.onTaskAccepted!(task);
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                // color: Colors.yellow.withOpacity(0.2),
                                height: i == 0 || i == widget.controller.tasks.length
                                    ? widget.taskHeight / 2
                                    : widget.taskHeight,
                                margin: const EdgeInsets.only(bottom: 8),
                              );
                            },
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskButton extends StatelessWidget {
  final void Function()? onPressed;

  const AddTaskButton({
    super.key,
    this.onPressed,
  });

  static const _borderRadius = BorderRadius.all(Radius.circular(4));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: _borderRadius,
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded),
              Text('Add new task'),
            ],
          ),
        ),
      ),
    );
  }
}
