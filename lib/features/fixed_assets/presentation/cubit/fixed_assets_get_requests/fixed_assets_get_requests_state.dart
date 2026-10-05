part of 'fixed_assets_get_requests_cubit.dart';

sealed class FixedAssetsGetRequestsState extends Equatable {
  const FixedAssetsGetRequestsState();

  @override
  List<Object> get props => [];
}

final class FixedAssetsGetRequestsInitial extends FixedAssetsGetRequestsState {}

final class FixedAssetsGetModificationRequestsLoading
    extends FixedAssetsGetRequestsState {}

final class FixedAssetsGetTransfersRequestsLoading
    extends FixedAssetsGetRequestsState {}

final class FixedAssetsGetDisposalsRequestsLoading
    extends FixedAssetsGetRequestsState {}

final class FixedAssetsGetModificationRequestsSuccess
    extends FixedAssetsGetRequestsState {
  final List<FixedAssetsModificationRequestsItem> response;

  const FixedAssetsGetModificationRequestsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class FixedAssetsGetTransfersRequestsSuccess
    extends FixedAssetsGetRequestsState {
  final List<FixedAssetsTransfersRequestsItem> response;

  const FixedAssetsGetTransfersRequestsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class FixedAssetsGetDisposalsRequestsSuccess
    extends FixedAssetsGetRequestsState {
  final List<FixedAssetsDisposalsRequestsItem> response;

  const FixedAssetsGetDisposalsRequestsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class FixedAssetsGetModificationRequestsFailure
    extends FixedAssetsGetRequestsState {
  final ApiFailure failure;

  const FixedAssetsGetModificationRequestsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class FixedAssetsGetTransfersRequestsFailure
    extends FixedAssetsGetRequestsState {
  final ApiFailure failure;

  const FixedAssetsGetTransfersRequestsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class FixedAssetsGetDisposalsRequestsFailure
    extends FixedAssetsGetRequestsState {
  final ApiFailure failure;

  const FixedAssetsGetDisposalsRequestsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class FixedAssetsGetHandoverRequestsLoading
    extends FixedAssetsGetRequestsState {
  const FixedAssetsGetHandoverRequestsLoading();
}

final class FixedAssetsGetHandoverRequestsSuccess
    extends FixedAssetsGetRequestsState {
  final List<FixedAssetsHandoverRequestsItem> response;

  const FixedAssetsGetHandoverRequestsSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class FixedAssetsGetHandoverRequestsFailure
    extends FixedAssetsGetRequestsState {
  final ApiFailure failure;

  const FixedAssetsGetHandoverRequestsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
