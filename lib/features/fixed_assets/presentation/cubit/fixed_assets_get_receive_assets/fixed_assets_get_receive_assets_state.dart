part of 'fixed_assets_get_receive_assets_cubit.dart';

sealed class FixedAssetsGetReceiveAssetsState extends Equatable {
  const FixedAssetsGetReceiveAssetsState();

  @override
  List<Object> get props => [];
}

final class FixedAssetsGetReceiveAssetsInitial
    extends FixedAssetsGetReceiveAssetsState {}

final class FixedAssetsGetReceiveAssetsLoading
    extends FixedAssetsGetReceiveAssetsState {}

final class FixedAssetsGetReceiveAssetsSuccess
    extends FixedAssetsGetReceiveAssetsState {
  final List<ReceiveAssetsData> data;

  const FixedAssetsGetReceiveAssetsSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class FixedAssetsGetReceiveAssetsFailure
    extends FixedAssetsGetReceiveAssetsState {
  final ApiFailure failure;

  const FixedAssetsGetReceiveAssetsFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
