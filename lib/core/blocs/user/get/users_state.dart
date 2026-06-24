import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/domain/models/users.dart';

class UsersState extends Equatable {
  final Users? data;
  final RequestStatus requestStatus;
  final String? error;

  const UsersState({
    required this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory UsersState.initial() {
    return const UsersState(
      data: null,
      requestStatus: RequestStatus.initial,
      error: null,
    );
  }

  UsersState copyWith({
    Users? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return UsersState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
