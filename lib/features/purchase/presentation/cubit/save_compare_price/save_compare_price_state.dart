import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class SaveComparePriceState extends Equatable {
  const SaveComparePriceState();

  @override
  List<Object> get props => [];
}

final class SaveComparePriceInit extends SaveComparePriceState {
  const SaveComparePriceInit();
}

final class SaveComparePriceLoading extends SaveComparePriceState {
  const SaveComparePriceLoading();
}

final class SaveComparePriceSuccess extends SaveComparePriceState {
  const SaveComparePriceSuccess();
}

final class SaveComparePriceFailure extends SaveComparePriceState {
  final ApiFailure failure;

  const SaveComparePriceFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
