import 'package:equatable/equatable.dart';
import 'package:zingo/core/constants/enums.dart';

class FavoriteDialogState extends Equatable {
  final bool isFavorite;
  final RequestStatus requestStatus;
  final String? error;

  const FavoriteDialogState({
    this.isFavorite = false,
    this.requestStatus = RequestStatus.initial,
    this.error,
  });

  factory FavoriteDialogState.initial() => const FavoriteDialogState();

  FavoriteDialogState copyWith({
    bool? isFavorite,
    RequestStatus? requestStatus,
    String? error,
  }) {
    return FavoriteDialogState(
      isFavorite: isFavorite ?? this.isFavorite,
      requestStatus: requestStatus ?? this.requestStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isFavorite, requestStatus, error];
}
