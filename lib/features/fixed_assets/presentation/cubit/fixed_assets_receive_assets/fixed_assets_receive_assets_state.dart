part of 'fixed_assets_receive_assets_cubit.dart';

sealed class FixedAssetsReceiveAssetsState extends Equatable {
  const FixedAssetsReceiveAssetsState();

  @override
  List<Object> get props => [];
}

final class FixedAssetsReceiveAssetsInitial
    extends FixedAssetsReceiveAssetsState {}

final class FixedAssetsReceiveAssetsLoading
    extends FixedAssetsReceiveAssetsState {}

final class FixedAssetsReceiveAssetsSuccess
    extends FixedAssetsReceiveAssetsState {
  const FixedAssetsReceiveAssetsSuccess();
}

final class FixedAssetsReceiveAssetsFailure
    extends FixedAssetsReceiveAssetsState {
  final ApiFailure failure;

  const FixedAssetsReceiveAssetsFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
