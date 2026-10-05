import 'package:flutter/material.dart';

import '../../../../core/errors/api_failure.dart';
import '../../domain/entities/cashier_my_shift_entity.dart';

@immutable
class ShiftTabState {
  final List<CashierShiftEntity> items;
  final bool isLoading;
  final bool hasMore;
  final ApiFailure? failure;

  const ShiftTabState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.failure,
  });

  ShiftTabState copyWith({
    List<CashierShiftEntity>? items,
    bool? isLoading,
    bool? hasMore,
    ApiFailure? failure,
  }) {
    return ShiftTabState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      failure: failure,
    );
  }
}
