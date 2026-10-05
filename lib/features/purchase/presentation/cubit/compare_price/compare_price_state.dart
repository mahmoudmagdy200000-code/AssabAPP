import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/compare_price_response.dart';

sealed class ComparePriceState extends Equatable {
  const ComparePriceState();

  @override
  List<Object> get props => [];
}

final class ComparePriceInit extends ComparePriceState {
  const ComparePriceInit();
}

final class ComparePriceLoading extends ComparePriceState {
  const ComparePriceLoading();
}

final class ComparePriceSuccess extends ComparePriceState {
  final PurchaseComparePriceResponse comparePriceResponse;

  const ComparePriceSuccess(this.comparePriceResponse);

  @override
  List<Object> get props => [comparePriceResponse];
}

final class ComparePriceFailure extends ComparePriceState {
  final ApiFailure failure;

  const ComparePriceFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
