import 'package:equatable/equatable.dart';

class OnboardingViewState extends Equatable {
  final int page;
  final int totalPage;

  final String? displayName;

  const OnboardingViewState({
    required this.page,
    required this.totalPage,
    this.displayName,
  });

  factory OnboardingViewState.initial() =>
      const OnboardingViewState(page: 0, totalPage: 3, displayName: null);

  OnboardingViewState copyWith({
    int? page,
    int? totalPage,
    String? displayName,
  }) {
    return OnboardingViewState(
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object?> get props => [page, totalPage, displayName];
}
