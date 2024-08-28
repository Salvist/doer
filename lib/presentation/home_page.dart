import 'package:doer/domain/models/project.dart';
import 'package:doer/presentation/board_controller.dart';
import 'package:doer/presentation/task_board.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BoardController _boardController;

  @override
  void initState() {
    _boardController = BoardController();
    super.initState();
  }

  @override
  void dispose() {
    _boardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 240,
            child: Material(
              color: Colors.red.shade100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doer',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('First Project'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Spacer(),
                    const Row(
                      children: [
                        Icon(Icons.info_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Help', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const Text('Drag to move task'),
                    const Text('Double tap to edit a task'),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: TaskBoard(
              project: Project(id: '1', name: 'First Project'),
            ),
          ),
        ],
      ),
    );
  }
}
