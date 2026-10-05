import '../../../../../../core/errors/api_failure.dart';
import '../../../domain/entity/shift/shift_entity.dart';

class CashierShiftTabState<T> {
  final List<ShiftEntity> items;
  final bool isLoading;
  final bool hasMore;
  final ApiFailure? failure;

  const CashierShiftTabState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.failure,
  });

  CashierShiftTabState<T> copyWith({
    List<ShiftEntity>? items,
    bool? isLoading,
    bool? hasMore,
    ApiFailure? failure,
  }) {
    return CashierShiftTabState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      failure: failure,
    );
  }
}
