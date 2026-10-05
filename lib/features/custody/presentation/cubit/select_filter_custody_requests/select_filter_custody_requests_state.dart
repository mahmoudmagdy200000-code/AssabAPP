import 'package:assab/core/enums/time_keys.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/enums/custody_requests_status_enum.dart';

class SelectFilterCustodyRequestsState extends Equatable {
  final CustodyRequestsStatusEnum status;
  final TimeKeys time;

  const SelectFilterCustodyRequestsState({
    this.status = CustodyRequestsStatusEnum.non,
    this.time = TimeKeys.non,
  });

  SelectFilterCustodyRequestsState copyWith({
    CustodyRequestsStatusEnum? status,
    TimeKeys? time,
  }) {
    return SelectFilterCustodyRequestsState(
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }

  @override
  List<Object> get props => [status, time];
}
