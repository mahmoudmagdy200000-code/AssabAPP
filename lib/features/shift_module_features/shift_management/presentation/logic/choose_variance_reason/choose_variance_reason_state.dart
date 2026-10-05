import 'package:assab/core/helpers/variance_strategy.dart';
import 'package:equatable/equatable.dart';

class ChooseVarianceReasonState extends Equatable {
  final VarianceStrategy? varianceStrategy;

  const ChooseVarianceReasonState({this.varianceStrategy});

  ChooseVarianceReasonState copyWith({VarianceStrategy? varianceStrategy}) {
    return ChooseVarianceReasonState(
      varianceStrategy: varianceStrategy ?? this.varianceStrategy,
    );
  }

  @override
  List<Object?> get props => [varianceStrategy];
}
