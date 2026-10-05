import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportMenuEngineeringState extends Equatable {
  const ExportMenuEngineeringState();

  @override
  List<Object> get props => [];
}

final class ExportMenuEngineeringInit extends ExportMenuEngineeringState {
  const ExportMenuEngineeringInit();
}

final class ExportMenuEngineeringLoading extends ExportMenuEngineeringState {
  const ExportMenuEngineeringLoading();
}

final class ExportMenuEngineeringSuccess extends ExportMenuEngineeringState {
  final String fileUrl;

  const ExportMenuEngineeringSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportMenuEngineeringFailure extends ExportMenuEngineeringState {
  final ApiFailure failure;

  const ExportMenuEngineeringFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class ExportMenuEngineeringEmailLoading
    extends ExportMenuEngineeringState {
  const ExportMenuEngineeringEmailLoading();
}

final class ExportMenuEngineeringEmailSuccess
    extends ExportMenuEngineeringState {
  const ExportMenuEngineeringEmailSuccess();
}

final class ExportMenuEngineeringEmailFailure
    extends ExportMenuEngineeringState {
  final ApiFailure failure;

  const ExportMenuEngineeringEmailFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
