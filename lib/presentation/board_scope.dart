import 'package:doer/presentation/board_controller.dart';
import 'package:flutter/material.dart';

class BoardScope extends InheritedNotifier<BoardController> {
  BoardScope({
    super.key,
    required super.child,
  }) : super(notifier: BoardController());

  static BoardController of(BuildContext context) {
    final BoardScope? result = context.dependOnInheritedWidgetOfExactType<BoardScope>();
    assert(result != null, 'No BoardScope found in context');
    return result!.notifier!;
  }
}
