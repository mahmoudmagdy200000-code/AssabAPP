import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/purchase/data/models/purchase_branch_items_response.dart';
import 'package:equatable/equatable.dart';

sealed class GetPurchaseBranchItemsState extends Equatable {
  const GetPurchaseBranchItemsState();

  @override
  List<Object> get props => [];
}

final class GetPurchaseBranchItemsInit extends GetPurchaseBranchItemsState {
  const GetPurchaseBranchItemsInit();
}

final class GetPurchaseBranchItemsLoading extends GetPurchaseBranchItemsState {
  const GetPurchaseBranchItemsLoading();
}

final class GetPurchaseBranchItemsSuccess extends GetPurchaseBranchItemsState {
  final List<PurchaseBranchItemData> response;

  const GetPurchaseBranchItemsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetPurchaseBranchItemsFailure extends GetPurchaseBranchItemsState {
  final ApiFailure failure;

  const GetPurchaseBranchItemsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
