import 'package:equatable/equatable.dart';

class UserProfileGetEvent extends Equatable {
  const UserProfileGetEvent();

  @override
  List<Object?> get props => [];
}

class UserProfileGetFetched extends UserProfileGetEvent {
  final String userId;
 
  const UserProfileGetFetched({required this.userId});

  @override
  List<Object?> get props => [userId];
}
