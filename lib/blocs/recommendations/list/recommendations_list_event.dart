import 'package:equatable/equatable.dart';
import 'package:zingo/dtos/recommendations/recommendations_payload.dart';

class RecommendationsListEvent extends Equatable {
  const RecommendationsListEvent();

  @override
  List<Object?> get props => [];
}

class RecommendationsListFetch extends RecommendationsListEvent {
  final RecommendationsPayload payload;

  const RecommendationsListFetch({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class RecommendationsListFetchMore extends RecommendationsListEvent {
  final RecommendationsPayload payload;

  const RecommendationsListFetchMore({required this.payload});

  @override
  List<Object?> get props => [payload];
}
