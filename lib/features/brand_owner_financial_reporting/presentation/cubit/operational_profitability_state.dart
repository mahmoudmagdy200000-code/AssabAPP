import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/brand_owner_operational_profitability_entity.dart';

sealed class OperationalProfitabilityState extends Equatable {
  const OperationalProfitabilityState();

  @override
  List<Object> get props => [];
}

final class OperationalProfitabilityInitial
    extends OperationalProfitabilityState {
  const OperationalProfitabilityInitial();
}

final class OperationalProfitabilityLoading
    extends OperationalProfitabilityState {
  const OperationalProfitabilityLoading();
}

final class OperationalProfitabilitySuccess
    extends OperationalProfitabilityState {
  final OperationalProfitabilityEntity data;

  const OperationalProfitabilitySuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class OperationalProfitabilityFailure
    extends OperationalProfitabilityState {
  final ApiFailure failure;

  const OperationalProfitabilityFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
