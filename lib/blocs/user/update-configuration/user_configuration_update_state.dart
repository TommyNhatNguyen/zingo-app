import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';

class UserConfigurationUpdateState extends Equatable {
  final RequestStatus requestStatus;
  final String? error;

  const UserConfigurationUpdateState({
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory UserConfigurationUpdateState.initial() =>
      const UserConfigurationUpdateState();

  UserConfigurationUpdateState copyWith({
    RequestStatus? requestStatus,
    String? error,
  }) {
    return UserConfigurationUpdateState(
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [requestStatus, error];
}
