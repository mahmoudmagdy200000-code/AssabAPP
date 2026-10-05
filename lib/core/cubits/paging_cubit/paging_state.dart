import 'package:equatable/equatable.dart';

class PagingState extends Equatable {
  final int currentIndex;
  final int totalSteps;

  const PagingState({required this.currentIndex, required this.totalSteps});

  bool get isFirstStep => currentIndex == 0;
  bool get isLastStep => currentIndex == totalSteps - 1;
  double get progress => (currentIndex + 1) / totalSteps;

  PagingState copyWith({int? currentIndex, int? totalSteps}) {
    return PagingState(
      currentIndex: currentIndex ?? this.currentIndex,
      totalSteps: totalSteps ?? this.totalSteps,
    );
  }

  @override
  List<Object> get props => [currentIndex, totalSteps];
}
