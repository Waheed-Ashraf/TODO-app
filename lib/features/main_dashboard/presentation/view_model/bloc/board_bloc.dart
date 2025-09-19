import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_state.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/views/widgets/main_dashboard_view_body.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardState.initial()) {
    on<BoardSetHovering>(_onSetHovering);
    on<BoardAcceptTask>(_onAcceptTask);
    on<BoardReorderWithinColumn>(_onReorderWithinColumn);
    on<BoardSetGapHover>(_onSetGapHover);
  }

  void _onSetHovering(BoardSetHovering event, Emitter<BoardState> emit) {
    if (state.hoveringColumn != event.column) {
      emit(state.copyWith(hoveringColumn: event.column));
    }
  }

  void _onSetGapHover(BoardSetGapHover event, Emitter<BoardState> emit) {
    // when column/index is null → clear hover
    if (event.column == null || event.index == null) {
      emit(state.copyWith(clearGapHover: true));
    } else if (state.hoveredGapColumn != event.column ||
        state.hoveredGapIndex != event.index) {
      emit(
        state.copyWith(
          hoveredGapColumn: event.column,
          hoveredGapIndex: event.index,
        ),
      );
    }
  }

  void _onAcceptTask(BoardAcceptTask event, Emitter<BoardState> emit) {
    final lanesCopy = _deepCopy(state.lanes);

    final sourceList = lanesCopy[event.payload.from]!;
    final task = sourceList.removeAt(event.payload.fromIndex);

    final targetList = lanesCopy[event.targetColumn]!;
    final idx =
        (event.insertIndex == null ||
            event.insertIndex! < 0 ||
            event.insertIndex! > targetList.length)
        ? targetList.length
        : event.insertIndex!;

    targetList.insert(idx, task);

    // also clear any gap hover after drop
    emit(state.copyWith(lanes: lanesCopy, clearGapHover: true));
  }

  void _onReorderWithinColumn(
    BoardReorderWithinColumn event,
    Emitter<BoardState> emit,
  ) {
    final lanesCopy = _deepCopy(state.lanes);
    final list = lanesCopy[event.column]!;

    final task = list.removeAt(event.fromIndex);
    final adjusted = event.toIndex > event.fromIndex
        ? event.toIndex - 1
        : event.toIndex;
    list.insert(adjusted.clamp(0, list.length), task);

    emit(state.copyWith(lanes: lanesCopy));
  }

  Map<BoardColumn, List<TaskModel>> _deepCopy(
    Map<BoardColumn, List<TaskModel>> lanes,
  ) => lanes.map((k, v) => MapEntry(k, List<TaskModel>.from(v)));
}
