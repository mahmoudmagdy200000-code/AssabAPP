import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class SupplierConfirmOrRejectOrderOrItemState extends Equatable {
  const SupplierConfirmOrRejectOrderOrItemState();

  @override
  List<Object> get props => [];
}

final class SupplierConfirmOrRejectOrderOrItemInit
    extends SupplierConfirmOrRejectOrderOrItemState {
  const SupplierConfirmOrRejectOrderOrItemInit();
}

final class SupplierConfirmOrRejectOrderOrItemLoading
    extends SupplierConfirmOrRejectOrderOrItemState {
  const SupplierConfirmOrRejectOrderOrItemLoading();
}

final class SupplierConfirmOrRejectOrderOrItemSuccess
    extends SupplierConfirmOrRejectOrderOrItemState {
  const SupplierConfirmOrRejectOrderOrItemSuccess();
}

final class SupplierConfirmOrRejectOrderOrItemFailure
    extends SupplierConfirmOrRejectOrderOrItemState {
  final ApiFailure failure;

  const SupplierConfirmOrRejectOrderOrItemFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
