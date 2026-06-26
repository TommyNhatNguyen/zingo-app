import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

class ConnectivityState extends Equatable {
  final List<ConnectivityResult> connectivityResult;
  final bool isConnected;

  const ConnectivityState({
    required this.connectivityResult,
    this.isConnected = false,
  });

  factory ConnectivityState.initial() => const ConnectivityState(
    connectivityResult: [ConnectivityResult.wifi],
    isConnected: true,
  );

  ConnectivityState copyWith({
    List<ConnectivityResult>? connectivityResult,
    bool? isConnected,
  }) => ConnectivityState(
    connectivityResult: connectivityResult ?? this.connectivityResult,
    isConnected: isConnected ?? this.isConnected,
  );

  @override
  List<Object?> get props => [connectivityResult, isConnected];
}
