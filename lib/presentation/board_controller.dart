import 'package:flutter/cupertino.dart';

class BoardValue {
  final bool isDragging;

  const BoardValue({
    this.isDragging = false,
  });

  BoardValue copyWith({bool? isDragging}) {
    return BoardValue(
      isDragging: isDragging ?? this.isDragging,
    );
  }
}

class BoardController extends ValueNotifier<BoardValue> {
  BoardController() : super(const BoardValue());

  void toggleDrag(bool isDragging) {
    value = value.copyWith(isDragging: isDragging);
  }
}
