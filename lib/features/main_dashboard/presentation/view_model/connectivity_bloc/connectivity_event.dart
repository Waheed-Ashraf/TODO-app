import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
  @override
  List<Object?> get props => [];
}

class ConnectivityStart extends ConnectivityEvent {}

class RadioChanged extends ConnectivityEvent {
  final ConnectivityResult result;
  const RadioChanged(this.result);
  @override
  List<Object?> get props => [result];
}

class ReachabilityChanged extends ConnectivityEvent {
  final bool hasInternet;
  const ReachabilityChanged(this.hasInternet);
  @override
  List<Object?> get props => [hasInternet];
}
