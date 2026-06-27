import 'package:equatable/equatable.dart';

class OnboardingViewState extends Equatable {
  final int page;
  final int totalPage;

  const OnboardingViewState({required this.page, required this.totalPage});

  factory OnboardingViewState.initial() =>
      const OnboardingViewState(page: 0, totalPage: 3);

  @override
  List<Object?> get props => [page, totalPage];
}
