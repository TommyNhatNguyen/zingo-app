import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/user_setting.dart';

class UserSettingsGetState extends Equatable {
  final UserSetting? data;
  final RequestStatus requestStatus;
  final String? error;

  const UserSettingsGetState({
    this.data,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory UserSettingsGetState.initial() => const UserSettingsGetState();

  UserSettingsGetState copyWith({
    UserSetting? data,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return UserSettingsGetState(
      data: data ?? this.data,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, requestStatus, error];
}
