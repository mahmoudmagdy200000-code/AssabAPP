import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportProfitAndLossStatementState extends Equatable {
  const ExportProfitAndLossStatementState();

  @override
  List<Object> get props => [];
}

final class ExportProfitAndLossStatementInit
    extends ExportProfitAndLossStatementState {
  const ExportProfitAndLossStatementInit();
}

final class ExportProfitAndLossStatementLoading
    extends ExportProfitAndLossStatementState {
  const ExportProfitAndLossStatementLoading();
}

final class ExportProfitAndLossStatementSuccess
    extends ExportProfitAndLossStatementState {
  final String fileUrl;

  const ExportProfitAndLossStatementSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportProfitAndLossStatementFailure
    extends ExportProfitAndLossStatementState {
  final ApiFailure failure;

  const ExportProfitAndLossStatementFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class ExportProfitAndLossStatementEmailLoading
    extends ExportProfitAndLossStatementState {
  const ExportProfitAndLossStatementEmailLoading();
}

final class ExportProfitAndLossStatementEmailSuccess
    extends ExportProfitAndLossStatementState {
  const ExportProfitAndLossStatementEmailSuccess();
}

final class ExportProfitAndLossStatementEmailFailure
    extends ExportProfitAndLossStatementState {
  final ApiFailure failure;

  const ExportProfitAndLossStatementEmailFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
