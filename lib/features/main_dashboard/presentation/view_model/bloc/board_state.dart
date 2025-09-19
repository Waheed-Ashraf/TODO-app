import 'package:equatable/equatable.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/main_dashboard_view_body.dart';

class BoardState extends Equatable {
  final Map<BoardColumn, List<TaskModel>> lanes;
  final BoardColumn? hoveringColumn;

  // ⬇️ NEW: which gap (column,index) is currently hovered
  final BoardColumn? hoveredGapColumn;
  final int? hoveredGapIndex;

  const BoardState({
    required this.lanes,
    this.hoveringColumn,
    this.hoveredGapColumn,
    this.hoveredGapIndex,
  });

  BoardState copyWith({
    Map<BoardColumn, List<TaskModel>>? lanes,
    BoardColumn? hoveringColumn,
    BoardColumn? hoveredGapColumn,
    int? hoveredGapIndex,
    bool clearGapHover = false, // helper to clear both at once
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
    );
  }

  @override
  List<Object?> get props => [
    lanes,
    hoveringColumn,
    hoveredGapColumn,
    hoveredGapIndex,
  ];

  factory BoardState.initial() {
    return BoardState(
      lanes: {
        BoardColumn.backlog: [
          TaskModel(
            id: 't1',
            title: 'Design new logo',
            description: 'Create a modern logo for the new product line.',
          ),
          TaskModel(
            id: 't2',
            title: 'Draft brief',
            description: 'Collect requirements from marketing & sales.',
          ),
          TaskModel(
            id: 't3',
            title: 'Competitor scan',
            description: 'Research top 5 products in the segment.',
          ),
        ],
        BoardColumn.todo: const [],
        BoardColumn.inProgress: const [],
        BoardColumn.done: const [],
      },
    );
  }
}
