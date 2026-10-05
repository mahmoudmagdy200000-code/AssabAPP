import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/purchase_history_response.dart';

sealed class PurchaseHistoryState extends Equatable {
  const PurchaseHistoryState();

  @override
  List<Object> get props => [];
}

final class PurchaseHistoryInit extends PurchaseHistoryState {
  const PurchaseHistoryInit();
}

final class PurchaseHistoryLoading extends PurchaseHistoryState {
  const PurchaseHistoryLoading();
}

final class PurchaseHistorySuccess extends PurchaseHistoryState {
  final List<PurchaseHistoryData> purchases;

  const PurchaseHistorySuccess(this.purchases);

  @override
  List<Object> get props => [purchases];
}

final class PurchaseHistoryFailure extends PurchaseHistoryState {
  final ApiFailure failure;

  const PurchaseHistoryFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
