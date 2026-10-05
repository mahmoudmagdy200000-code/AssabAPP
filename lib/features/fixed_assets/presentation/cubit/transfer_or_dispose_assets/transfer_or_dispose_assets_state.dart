import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';

sealed class TransferOrDisposeAssetsState extends Equatable {
  const TransferOrDisposeAssetsState();

  @override
  List<Object> get props => [];
}

final class TransferOrDisposeAssetsInit extends TransferOrDisposeAssetsState {
  const TransferOrDisposeAssetsInit();
}

final class TransferOrDisposeAssetsLoading
    extends TransferOrDisposeAssetsState {
  const TransferOrDisposeAssetsLoading();
}

final class TransferOrDisposeAssetsSuccess
    extends TransferOrDisposeAssetsState {
  const TransferOrDisposeAssetsSuccess();
}

final class TransferOrDisposeAssetsFailure
    extends TransferOrDisposeAssetsState {
  final ApiFailure failure;

  const TransferOrDisposeAssetsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
