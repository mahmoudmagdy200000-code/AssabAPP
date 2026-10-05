import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class FixdAssetsActiveHandoverApprovalState extends Equatable {
  const FixdAssetsActiveHandoverApprovalState();

  @override
  List<Object> get props => [];
}

final class FixdAssetsActiveHandoverApprovalInit
    extends FixdAssetsActiveHandoverApprovalState {
  const FixdAssetsActiveHandoverApprovalInit();
}

final class FixdAssetsActiveHandoverApprovalAllLoading
    extends FixdAssetsActiveHandoverApprovalState {
  const FixdAssetsActiveHandoverApprovalAllLoading();
}

final class FixdAssetsActiveHandoverApprovalZoneLoading
    extends FixdAssetsActiveHandoverApprovalState {
  final Set<String> loadingZoneIds;

  const FixdAssetsActiveHandoverApprovalZoneLoading(this.loadingZoneIds);

  @override
  List<Object> get props => [loadingZoneIds];
}

final class FixdAssetsActiveHandoverApprovalAllSuccess
    extends FixdAssetsActiveHandoverApprovalState {
  const FixdAssetsActiveHandoverApprovalAllSuccess();
}

final class FixdAssetsActiveHandoverApprovalZoneSuccess
    extends FixdAssetsActiveHandoverApprovalState {
  final String zoneId;
  final Set<String> loadingZoneIds;

  const FixdAssetsActiveHandoverApprovalZoneSuccess(
    this.zoneId,
    this.loadingZoneIds,
  );

  @override
  List<Object> get props => [zoneId, loadingZoneIds];
}

final class FixdAssetsActiveHandoverApprovalFailure
    extends FixdAssetsActiveHandoverApprovalState {
  final ApiFailure failure;
  final Set<String> loadingZoneIds;

  const FixdAssetsActiveHandoverApprovalFailure(
    this.failure, {
    this.loadingZoneIds = const {},
  });

  @override
  List<Object> get props => [failure, loadingZoneIds];
}
