import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class FixdAssetsStartHandoverState extends Equatable {
  const FixdAssetsStartHandoverState();

  @override
  List<Object> get props => [];
}

final class FixdAssetsStartHandoverInit extends FixdAssetsStartHandoverState {
  const FixdAssetsStartHandoverInit();
}

final class FixdAssetsStartHandoverLoading
    extends FixdAssetsStartHandoverState {
  const FixdAssetsStartHandoverLoading();
}

final class FixdAssetsStartHandoverSuccess
    extends FixdAssetsStartHandoverState {
  const FixdAssetsStartHandoverSuccess();
}

final class FixdAssetsStartHandoverFailure
    extends FixdAssetsStartHandoverState {
  final ApiFailure failure;

  const FixdAssetsStartHandoverFailure(this.failure);
}
