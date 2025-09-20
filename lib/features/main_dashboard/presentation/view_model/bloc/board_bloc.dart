// lib/features/main_dashboard/presentation/view_model/bloc/board_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/data/repo/dashboard_repo.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/bloc/board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final DashboardRepository repo;

  BoardBloc({required this.repo}) : super(BoardState.initial()) {
    on<BoardSetHovering>(_onSetHovering);
    on<BoardSetGapHover>(_onSetGapHover);

    on<BoardLoadAllColumns>(_onLoadAll);
    on<BoardAddTask>(_onAddTask);
    on<BoardUpdateTask>(_onUpdateTask);
    on<BoardDeleteTaskById>(_onDeleteTaskById);

    on<BoardAcceptTask>(_onAcceptTask); // update status in Firestore
    on<BoardReorderWithinColumn>(
      _onReorderWithinColumn,
    ); // (optional) you can persist order later
  }

  // --- UI-only hover ---
  void _onSetHovering(BoardSetHovering e, Emitter<BoardState> emit) {
    if (state.hoveringColumn != e.column) {
      emit(state.copyWith(hoveringColumn: e.column));
    }
  }

  void _onSetGapHover(BoardSetGapHover e, Emitter<BoardState> emit) {
    if (e.column == null || e.index == null) {
      emit(state.copyWith(clearGapHover: true));
    } else if (state.hoveredGapColumn != e.column ||
        state.hoveredGapIndex != e.index) {
      emit(
        state.copyWith(hoveredGapColumn: e.column, hoveredGapIndex: e.index),
      );
    }
  }

  // --- Load from Firestore ---
  Future<void> _onLoadAll(
    BoardLoadAllColumns e,
    Emitter<BoardState> emit,
  ) async {
    final m = <BoardColumn, List<TaskModel>>{};
    for (final col in BoardColumn.values) {
      m[col] = await repo.getAllTasksInColumn(col);
    }
    emit(state.copyWith(lanes: m));
  }

  // --- Add ---
  Future<void> _onAddTask(BoardAddTask e, Emitter<BoardState> emit) async {
    final id = await repo.addTask(e.task);
    final created = e.task.copyWith(id: id);
    final lanesCopy = _deepCopy(state.lanes);
    lanesCopy[created.status] = [...lanesCopy[created.status]!, created];
    emit(state.copyWith(lanes: lanesCopy));
  }

  // --- Update ---
  Future<void> _onUpdateTask(
    BoardUpdateTask e,
    Emitter<BoardState> emit,
  ) async {
    await repo.updateTask(e.task);
    final lanesCopy = _deepCopy(state.lanes);

    // remove from any column it exists
    for (final col in BoardColumn.values) {
      lanesCopy[col] = lanesCopy[col]!.where((t) => t.id != e.task.id).toList();
    }
    // insert into its (possibly new) column
    lanesCopy[e.task.status] = [...lanesCopy[e.task.status]!, e.task];

    emit(state.copyWith(lanes: lanesCopy));
  }

  // --- Delete ---
  Future<void> _onDeleteTaskById(
    BoardDeleteTaskById e,
    Emitter<BoardState> emit,
  ) async {
    await repo.deleteTask(e.taskId);
    final lanesCopy = _deepCopy(state.lanes);
    lanesCopy[e.column] = lanesCopy[e.column]!
        .where((t) => t.id != e.taskId)
        .toList();
    emit(state.copyWith(lanes: lanesCopy));
  }

  // --- Drag between columns (persist new status) ---
  Future<void> _onAcceptTask(
    BoardAcceptTask e,
    Emitter<BoardState> emit,
  ) async {
    final lanesCopy = _deepCopy(state.lanes);

    final sourceList = lanesCopy[e.payload.from]!;
    final moved = sourceList.removeAt(e.payload.fromIndex);

    final targetList = lanesCopy[e.targetColumn]!;
    final idx =
        (e.insertIndex == null ||
            e.insertIndex! < 0 ||
            e.insertIndex! > targetList.length)
        ? targetList.length
        : e.insertIndex!;
    final updated = moved.copyWith(status: e.targetColumn);
    targetList.insert(idx, updated);

    emit(state.copyWith(lanes: lanesCopy, clearGapHover: true));

    // persist status change
    await repo.updateTask(updated);
  }

  // --- Reorder inside a column (optional persist later with a 'order' field) ---
  void _onReorderWithinColumn(
    BoardReorderWithinColumn e,
    Emitter<BoardState> emit,
  ) {
    final lanesCopy = _deepCopy(state.lanes);
    final list = lanesCopy[e.column]!;
    final task = list.removeAt(e.fromIndex);
    final adjusted = e.toIndex > e.fromIndex ? e.toIndex - 1 : e.toIndex;
    list.insert(adjusted.clamp(0, list.length), task);
    emit(state.copyWith(lanes: lanesCopy));
  }

  Map<BoardColumn, List<TaskModel>> _deepCopy(
    Map<BoardColumn, List<TaskModel>> lanes,
  ) => lanes.map((k, v) => MapEntry(k, List<TaskModel>.from(v)));
}
