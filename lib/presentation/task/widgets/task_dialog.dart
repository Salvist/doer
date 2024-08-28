import 'package:doer/domain/models/task.dart';
import 'package:doer/domain/models/workflow.dart';
import 'package:flutter/material.dart';

class TaskDialog extends StatefulWidget {
  final Workflow workflow;
  final Task? task;

  const TaskDialog({
    super.key,
    required this.workflow,
    this.task,
  });

  static Future<Task?> show(BuildContext context, {required Workflow workflow, Task? task}) {
    return showDialog<Task>(
      context: context,
      builder: (context) => TaskDialog(
        workflow: workflow,
        task: task,
      ),
    );
  }

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final name = TextEditingController();
  final description = TextEditingController();

  @override
  void initState() {
    if (widget.task != null) {
      name.text = widget.task!.name;
      description.text = widget.task!.description;
    }
    super.initState();
  }

  void _submitTask() {
    if (name.text.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final task = widget.task?.copyWith(
          name: name.text,
          description: description.text,
        ) ??
        Task(
          id: '',
          workflowId: widget.workflow.name,
          name: name.text,
          description: description.text,
          index: 0,
          createdAt: DateTime.now(),
        );
    Navigator.pop(context, task);
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.task == null ? const Text('Add a new task') : const Text('Edit a task'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              minLines: 3,
              maxLines: 10,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitTask,
          child: widget.task == null ? const Text('Add task') : const Text('Edit task'),
        ),
      ],
    );
  }
}
