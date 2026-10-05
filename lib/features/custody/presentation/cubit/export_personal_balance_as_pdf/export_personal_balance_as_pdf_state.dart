import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportPersonalBalanceAsPdfState extends Equatable {
  const ExportPersonalBalanceAsPdfState();

  @override
  List<Object> get props => [];
}

final class ExportPersonalBalanceAsPdfInit
    extends ExportPersonalBalanceAsPdfState {
  const ExportPersonalBalanceAsPdfInit();
}

final class ExportPersonalBalanceAsPdfLoading
    extends ExportPersonalBalanceAsPdfState {
  const ExportPersonalBalanceAsPdfLoading();
}

final class ExportPersonalBalanceAsPdfSuccess
    extends ExportPersonalBalanceAsPdfState {
  final String fileUrl;

  const ExportPersonalBalanceAsPdfSuccess(this.fileUrl);
}

final class ExportPersonalBalanceAsPdfFailure
    extends ExportPersonalBalanceAsPdfState {
  final ApiFailure failure;

  const ExportPersonalBalanceAsPdfFailure(this.failure);
}
