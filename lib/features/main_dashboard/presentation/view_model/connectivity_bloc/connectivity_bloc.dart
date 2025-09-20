import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/connectivity_bloc/connectivity_event.dart';
import 'package:todo_app_task/features/main_dashboard/presentation/view_model/connectivity_bloc/connectivity_state.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// BLOC
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  final InternetConnectionChecker _checker;
  StreamSubscription<List<ConnectivityResult>>? _radioSub;
  StreamSubscription<InternetConnectionStatus>? _reachSub;

  ConnectivityBloc({
    Connectivity? connectivity,
    InternetConnectionChecker? checker,
  }) : _connectivity = connectivity ?? Connectivity(),
       _checker = checker ?? InternetConnectionChecker(),
       super(ConnectivityState.initial) {
    on<ConnectivityStart>(_onStart);
    on<RadioChanged>(_onRadioChanged);
    on<ReachabilityChanged>(_onReachabilityChanged);
  }

  Future<void> _onStart(
    ConnectivityStart event,
    Emitter<ConnectivityState> emit,
  ) async {
    // Initial reachability
    final hasNet = await _checker.hasConnection;
    emit(state.copyWith(online: hasNet));

    _radioSub = _connectivity.onConnectivityChanged.listen((results) {
      // Pick one result (e.g., first), or derive a combined state.
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;

      // Keep your existing event signature:
      add(RadioChanged(result));
    });
    // Listen for actual internet reachability
    _reachSub = _checker.onStatusChange.listen((status) {
      add(ReachabilityChanged(status == InternetConnectionStatus.connected));
    });
  }

  Future<void> _onRadioChanged(
    RadioChanged event,
    Emitter<ConnectivityState> emit,
  ) async {
    // When radio changes, confirm reachability (some Wi-Fi networks have no internet)
    final ok = await _checker.hasConnection;
    emit(state.copyWith(online: ok));
  }

  void _onReachabilityChanged(
    ReachabilityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(state.copyWith(online: event.hasInternet));
  }

  @override
  Future<void> close() async {
    await _radioSub?.cancel();
    await _reachSub?.cancel();
    return super.close();
  }
}
