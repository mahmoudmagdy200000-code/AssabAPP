import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class SupplierStartTrackOrderState extends Equatable {
  const SupplierStartTrackOrderState();

  @override
  List<Object> get props => [];
}

final class SupplierStartTrackOrderInit extends SupplierStartTrackOrderState {
  const SupplierStartTrackOrderInit();
}

final class SupplierStartTrackOrderLoading
    extends SupplierStartTrackOrderState {
  const SupplierStartTrackOrderLoading();
}

final class SupplierStartTrackOrderSuccess
    extends SupplierStartTrackOrderState {
  const SupplierStartTrackOrderSuccess();
}

final class SupplierStartTrackOrderFailure
    extends SupplierStartTrackOrderState {
  final ApiFailure failure;

  const SupplierStartTrackOrderFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
