import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/models/user_configuration.dart';

class UserConfigurationGetState extends Equatable {
  final UserConfiguration? data;
  final RequestStatus requestStatus;
  final String? error;

  const UserConfigurationGetState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory UserConfigurationGetState.initial() =>
      const UserConfigurationGetState();

  UserConfigurationGetState copyWith({
    UserConfiguration? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return UserConfigurationGetState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
