import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../../../shared/models/cancel_reason/cancel_reason_response.dart';

sealed class SupplierGetCancellationReasonState extends Equatable {
  const SupplierGetCancellationReasonState();

  @override
  List<Object> get props => [];
}

final class SupplierGetCancellationReasonInit
    extends SupplierGetCancellationReasonState {
  const SupplierGetCancellationReasonInit();
}

final class SupplierGetCancellationReasonLoading
    extends SupplierGetCancellationReasonState {
  const SupplierGetCancellationReasonLoading();
}

final class SupplierGetCancellationReasonSuccess
    extends SupplierGetCancellationReasonState {
  final CancelReasonResponse cancelReason;

  const SupplierGetCancellationReasonSuccess(this.cancelReason);

  @override
  List<Object> get props => [cancelReason];
}

final class SupplierGetCancellationReasonFailure
    extends SupplierGetCancellationReasonState {
  final ApiFailure failure;

  const SupplierGetCancellationReasonFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
