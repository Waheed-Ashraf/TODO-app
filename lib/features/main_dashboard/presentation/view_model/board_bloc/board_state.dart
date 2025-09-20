// lib/features/main_dashboard/presentation/view_model/bloc/board_state.dart
import 'package:equatable/equatable.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';

class BoardState extends Equatable {
  final Map<BoardColumn, List<TaskModel>> lanes;
  final BoardColumn? hoveringColumn;
  final BoardColumn? hoveredGapColumn;
  final int? hoveredGapIndex;
  final String? errorMessage;

  const BoardState({
    required this.lanes,
    this.hoveringColumn,
    this.hoveredGapColumn,
    this.hoveredGapIndex,
    this.errorMessage,
  });

  BoardState copyWith({
    Map<BoardColumn, List<TaskModel>>? lanes,
    BoardColumn? hoveringColumn,
    BoardColumn? hoveredGapColumn,
    int? hoveredGapIndex,
    bool clearGapHover = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BoardState(
      lanes: lanes ?? this.lanes,
      hoveringColumn: hoveringColumn,
      hoveredGapColumn: clearGapHover
          ? null
          : (hoveredGapColumn ?? this.hoveredGapColumn),
      hoveredGapIndex: clearGapHover
          ? null
          : (hoveredGapIndex ?? this.hoveredGapIndex),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    lanes,
    hoveringColumn,
    hoveredGapColumn,
    hoveredGapIndex,
    errorMessage,
  ];

  factory BoardState.initial() {
    return const BoardState(
      lanes: {
        BoardColumn.backlog: [],
        BoardColumn.todo: [],
        BoardColumn.inProgress: [],
        BoardColumn.done: [],
      },
    );
  }
}
