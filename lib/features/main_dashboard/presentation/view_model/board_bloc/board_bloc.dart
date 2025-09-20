import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/core/errors/exceptions.dart';
import 'package:todo_app_task/features/main_dashboard/data/enums/board_column_enum.dart';
import 'package:todo_app_task/features/main_dashboard/data/models/task_model.dart';
import 'package:todo_app_task/features/main_dashboard/data/repo/dashboard_repo.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/board_bloc/board_state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  final DashboardRepository repo;

  BoardBloc({required this.repo}) : super(BoardState.initial()) {
    on<BoardSetHovering>(_onSetHovering);
    on<BoardSetGapHover>(_onSetGapHover);

    on<BoardLoadAllColumns>(_onLoadAll);
    on<BoardAddTask>(_onAddTask);
    on<BoardUpdateTask>(_onUpdateTask);
    on<BoardDeleteTaskById>(_onDeleteTaskById);

    on<BoardAcceptTask>(_onAcceptTask);
    on<BoardReorderWithinColumn>(_onReorderWithinColumn);

    on<BoardClearError>((e, emit) => emit(state.copyWith(clearError: true)));
  }

  void _emitError(Emitter<BoardState> emit, Object err) {
    final msg = err is AppException ? err.message : 'Unexpected error';
    emit(state.copyWith(errorMessage: msg));
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

  // --- Load ---
  Future<void> _onLoadAll(
    BoardLoadAllColumns e,
    Emitter<BoardState> emit,
  ) async {
    try {
      final m = <BoardColumn, List<TaskModel>>{};
      for (final col in BoardColumn.values) {
        m[col] = await repo.getAllTasksInColumn(col);
      }
      emit(state.copyWith(lanes: m, clearError: true));
    } catch (err) {
      _emitError(emit, err);
    }
  }

  // --- Add ---
  Future<void> _onAddTask(BoardAddTask e, Emitter<BoardState> emit) async {
    try {
      final id = await repo.addTask(e.task);
      final created = e.task.copyWith(id: id);
      final lanesCopy = _deepCopy(state.lanes);
      lanesCopy[created.status] = [...lanesCopy[created.status]!, created];
      emit(state.copyWith(lanes: lanesCopy, clearError: true));
    } catch (err) {
      _emitError(emit, err);
    }
  }

  // --- Update ---
  Future<void> _onUpdateTask(
    BoardUpdateTask e,
    Emitter<BoardState> emit,
  ) async {
    try {
      await repo.updateTask(e.task);
      final lanesCopy = _deepCopy(state.lanes);
      for (final col in BoardColumn.values) {
        lanesCopy[col] = lanesCopy[col]!
            .where((t) => t.id != e.task.id)
            .toList();
      }
      lanesCopy[e.task.status] = [...lanesCopy[e.task.status]!, e.task];
      emit(state.copyWith(lanes: lanesCopy, clearError: true));
    } catch (err) {
      _emitError(emit, err);
    }
  }

  // --- Delete ---
  Future<void> _onDeleteTaskById(
    BoardDeleteTaskById e,
    Emitter<BoardState> emit,
  ) async {
    try {
      await repo.deleteTask(e.taskId);
      final lanesCopy = _deepCopy(state.lanes);
      lanesCopy[e.column] = lanesCopy[e.column]!
          .where((t) => t.id != e.taskId)
          .toList();
      emit(state.copyWith(lanes: lanesCopy, clearError: true));
    } catch (err) {
      _emitError(emit, err);
    }
  }

  // --- Drag across columns (+ persist) ---
  Future<void> _onAcceptTask(
    BoardAcceptTask e,
    Emitter<BoardState> emit,
  ) async {
    try {
      final lanesCopy = _deepCopy(state.lanes);
      final src = lanesCopy[e.payload.from]!;
      final moved = src.removeAt(e.payload.fromIndex);
      final tgt = lanesCopy[e.targetColumn]!;
      final idx =
          (e.insertIndex == null ||
              e.insertIndex! < 0 ||
              e.insertIndex! > tgt.length)
          ? tgt.length
          : e.insertIndex!;
      final updated = moved.copyWith(status: e.targetColumn);
      tgt.insert(idx, updated);
      emit(
        state.copyWith(lanes: lanesCopy, clearGapHover: true, clearError: true),
      );
      await repo.updateTask(
        updated,
      ); // if this throws, error will be shown above
    } catch (err) {
      _emitError(emit, err);
    }
  }

  void _onReorderWithinColumn(
    BoardReorderWithinColumn e,
    Emitter<BoardState> emit,
  ) {
    final lanesCopy = _deepCopy(state.lanes);
    final list = lanesCopy[e.column]!;
    final task = list.removeAt(e.fromIndex);
    final adjusted = e.toIndex > e.fromIndex ? e.toIndex - 1 : e.toIndex;
    list.insert(adjusted.clamp(0, list.length), task);
    emit(
      state.copyWith(lanes: lanesCopy),
    ); // local only (no remote persist here)
  }

  Map<BoardColumn, List<TaskModel>> _deepCopy(
    Map<BoardColumn, List<TaskModel>> lanes,
  ) => lanes.map((k, v) => MapEntry(k, List<TaskModel>.from(v)));
}
