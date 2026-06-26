import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class ConnectivityCheckEvent extends ConnectivityEvent {
  final List<ConnectivityResult>? connectivityResult;
  final bool? isConnected;

  const ConnectivityCheckEvent({this.connectivityResult, this.isConnected});

  @override
  List<Object?> get props => [connectivityResult, isConnected];
}
