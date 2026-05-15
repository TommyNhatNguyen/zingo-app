import 'package:equatable/equatable.dart';
import 'package:zingo/constants/enums.dart';
import 'package:zingo/models/user_profile.dart';
import 'package:zingo/models/users.dart';

class UserSettingsState extends Equatable {
  final Users? user;
  final UserProfile? profile;
  final List<String> topicCodes;
  final RequestStatus loadStatus;
  final RequestStatus saveStatus;
  final String? error;

  const UserSettingsState({
    this.user,
    this.profile,
    this.topicCodes = const [],
    this.loadStatus = RequestStatus.initial,
    this.saveStatus = RequestStatus.initial,
    this.error,
  });

  factory UserSettingsState.initial() => const UserSettingsState();

  UserSettingsState copyWith({
    Users? user,
    UserProfile? profile,
    List<String>? topicCodes,
    RequestStatus? loadStatus,
    RequestStatus? saveStatus,
    String? error,
    bool clearError = false,
  }) {
    return UserSettingsState(
      user: user ?? this.user,
      profile: profile ?? this.profile,
      topicCodes: topicCodes ?? this.topicCodes,
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    user,
    profile,
    topicCodes,
    loadStatus,
    saveStatus,
    error,
  ];
}
