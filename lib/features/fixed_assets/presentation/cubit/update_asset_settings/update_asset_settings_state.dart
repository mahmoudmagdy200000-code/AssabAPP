import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class UpdateAssetSettingsState extends Equatable {
  const UpdateAssetSettingsState();

  @override
  List<Object> get props => [];
}

final class UpdateAssetSettingsInit extends UpdateAssetSettingsState {
  const UpdateAssetSettingsInit();
}

final class UpdateAssetSettingsLoading extends UpdateAssetSettingsState {
  const UpdateAssetSettingsLoading();
}

final class UpdateAssetSettingsSuccess extends UpdateAssetSettingsState {
  const UpdateAssetSettingsSuccess();
}

final class UpdateAssetSettingsFailure extends UpdateAssetSettingsState {
  final ApiFailure failure;

  const UpdateAssetSettingsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
