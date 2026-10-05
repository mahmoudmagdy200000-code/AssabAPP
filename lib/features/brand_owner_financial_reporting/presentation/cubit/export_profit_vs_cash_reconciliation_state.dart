import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportProfitVsCashReconciliationState extends Equatable {
  const ExportProfitVsCashReconciliationState();

  @override
  List<Object> get props => [];
}

final class ExportProfitVsCashReconciliationInit
    extends ExportProfitVsCashReconciliationState {
  const ExportProfitVsCashReconciliationInit();
}

final class ExportProfitVsCashReconciliationLoading
    extends ExportProfitVsCashReconciliationState {
  const ExportProfitVsCashReconciliationLoading();
}

final class ExportProfitVsCashReconciliationSuccess
    extends ExportProfitVsCashReconciliationState {
  final String fileUrl;

  const ExportProfitVsCashReconciliationSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportProfitVsCashReconciliationFailure
    extends ExportProfitVsCashReconciliationState {
  final ApiFailure failure;

  const ExportProfitVsCashReconciliationFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class ExportProfitVsCashReconciliationEmailLoading
    extends ExportProfitVsCashReconciliationState {
  const ExportProfitVsCashReconciliationEmailLoading();
}

final class ExportProfitVsCashReconciliationEmailSuccess
    extends ExportProfitVsCashReconciliationState {
  const ExportProfitVsCashReconciliationEmailSuccess();
}

final class ExportProfitVsCashReconciliationEmailFailure
    extends ExportProfitVsCashReconciliationState {
  final ApiFailure failure;

  const ExportProfitVsCashReconciliationEmailFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
