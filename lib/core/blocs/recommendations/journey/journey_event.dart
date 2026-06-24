import 'package:equatable/equatable.dart';
import 'package:zingo/domain/dtos/journey/journey_payload.dart';

abstract class JourneyEvent extends Equatable {
  const JourneyEvent();

  @override
  List<Object?> get props => [];
}

class JourneyFetchEvent extends JourneyEvent {
  final JourneyPayload payload;

  const JourneyFetchEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}

class JourneyFetchMoreEvent extends JourneyEvent {
  final JourneyPayload payload;

  const JourneyFetchMoreEvent({required this.payload});

  @override
  List<Object?> get props => [payload];
}
