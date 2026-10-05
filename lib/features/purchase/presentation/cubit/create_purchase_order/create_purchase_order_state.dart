import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class CreatePurchaseOrderState extends Equatable {
  const CreatePurchaseOrderState();

  @override
  List<Object> get props => [];
}

final class CreatePurchaseOrderInit extends CreatePurchaseOrderState {
  const CreatePurchaseOrderInit();
}

final class CreatePurchaseOrderLoading extends CreatePurchaseOrderState {
  const CreatePurchaseOrderLoading();
}

final class CreatePurchaseOrderSuccess extends CreatePurchaseOrderState {
  const CreatePurchaseOrderSuccess();
}

final class CreatePurchaseOrderFailure extends CreatePurchaseOrderState {
  final ApiFailure failure;

  const CreatePurchaseOrderFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
