import 'package:equatable/equatable.dart';

/// STATE
class ConnectivityState extends Equatable {
  final bool online;
  const ConnectivityState({required this.online});
  ConnectivityState copyWith({bool? online}) =>
      ConnectivityState(online: online ?? this.online);
  @override
  List<Object?> get props => [online];

  static const initial = ConnectivityState(online: true);
}
