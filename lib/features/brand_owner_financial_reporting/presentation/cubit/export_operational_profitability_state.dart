import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportOperationalProfitabilityState extends Equatable {
  const ExportOperationalProfitabilityState();

  @override
  List<Object> get props => [];
}

final class ExportOperationalProfitabilityInit
    extends ExportOperationalProfitabilityState {
  const ExportOperationalProfitabilityInit();
}

final class ExportOperationalProfitabilityLoading
    extends ExportOperationalProfitabilityState {
  const ExportOperationalProfitabilityLoading();
}

final class ExportOperationalProfitabilitySuccess
    extends ExportOperationalProfitabilityState {
  final String fileUrl;

  const ExportOperationalProfitabilitySuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportOperationalProfitabilityFailure
    extends ExportOperationalProfitabilityState {
  final ApiFailure failure;

  const ExportOperationalProfitabilityFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class ExportOperationalProfitabilityEmailLoading
    extends ExportOperationalProfitabilityState {
  const ExportOperationalProfitabilityEmailLoading();
}

final class ExportOperationalProfitabilityEmailSuccess
    extends ExportOperationalProfitabilityState {
  const ExportOperationalProfitabilityEmailSuccess();
}

final class ExportOperationalProfitabilityEmailFailure
    extends ExportOperationalProfitabilityState {
  final ApiFailure failure;

  const ExportOperationalProfitabilityEmailFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
