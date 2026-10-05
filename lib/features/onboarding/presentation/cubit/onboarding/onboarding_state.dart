import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingInitState extends OnboardingState {
  const OnboardingInitState();
}

final class OnboardingChangePageState extends OnboardingState {
  final int currentPage;

  const OnboardingChangePageState(this.currentPage);

  @override
  List<Object?> get props => [currentPage];
}

final class OnboardingAppBarAndNumRowHeightState extends OnboardingState {
  final double appBarAndNumRowHeight;

  const OnboardingAppBarAndNumRowHeightState(this.appBarAndNumRowHeight);

  @override
  List<Object?> get props => [appBarAndNumRowHeight];
}
