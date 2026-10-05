import 'package:equatable/equatable.dart';

sealed class FilterPurchaseHistoryState extends Equatable {
  const FilterPurchaseHistoryState();

  @override
  List<Object> get props => [];
}

final class FilterPurchaseHistoryInit extends FilterPurchaseHistoryState {
  const FilterPurchaseHistoryInit();
}

final class FilterPurchaseHistoryLoading extends FilterPurchaseHistoryState {
  const FilterPurchaseHistoryLoading();
}

final class FilterPurchaseHistorySuccess extends FilterPurchaseHistoryState {
  const FilterPurchaseHistorySuccess();
}

final class FilterPurchaseHistoryFailure extends FilterPurchaseHistoryState {
  const FilterPurchaseHistoryFailure();
}
