import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/purchase/data/models/purchase_branches_response.dart';
import 'package:equatable/equatable.dart';

sealed class GetPurchaseBranchesState extends Equatable {
  const GetPurchaseBranchesState();

  @override
  List<Object> get props => [];
}

final class GetPurchaseBranchesInit extends GetPurchaseBranchesState {
  const GetPurchaseBranchesInit();
}

final class GetPurchaseBranchesLoading extends GetPurchaseBranchesState {
  const GetPurchaseBranchesLoading();
}

final class GetPurchaseBranchesSuccess extends GetPurchaseBranchesState {
  final PurchaseBranchesResponse response;

  const GetPurchaseBranchesSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetPurchaseBranchesFailure extends GetPurchaseBranchesState {
  final ApiFailure failure;

  const GetPurchaseBranchesFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
