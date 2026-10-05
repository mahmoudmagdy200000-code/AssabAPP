import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ModifyAssetState extends Equatable {
  const ModifyAssetState();

  @override
  List<Object> get props => [];
}

final class ModifyAssetInit extends ModifyAssetState {
  const ModifyAssetInit();
}

final class ModifyAssetLoading extends ModifyAssetState {
  const ModifyAssetLoading();
}

final class ModifyAssetSuccess extends ModifyAssetState {
  const ModifyAssetSuccess();
}

final class ModifyAssetFailure extends ModifyAssetState {
  final ApiFailure failure;

  const ModifyAssetFailure(this.failure);
}
