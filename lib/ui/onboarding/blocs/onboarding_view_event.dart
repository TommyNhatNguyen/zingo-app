import 'package:equatable/equatable.dart';

sealed class OnboardingViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingViewGoToPage extends OnboardingViewEvent {
  final int page;

  OnboardingViewGoToPage({required this.page});

  @override
  List<Object?> get props => [page];
}
