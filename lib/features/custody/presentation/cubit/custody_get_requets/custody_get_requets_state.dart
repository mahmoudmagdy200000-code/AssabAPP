import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/custody_get_past_requests_response.dart';
import '../../../data/models/custody_requests_response.dart';

sealed class CustodyGetRequetsState extends Equatable {
  const CustodyGetRequetsState();

  @override
  List<Object> get props => [];
}

final class CustodyGetRequetsInit extends CustodyGetRequetsState {
  const CustodyGetRequetsInit();
}

final class CustodyGetRequetsLoading extends CustodyGetRequetsState {
  const CustodyGetRequetsLoading();
}

final class CustodyGetRequetsSuccess extends CustodyGetRequetsState {
  final CustodyRequestsResponse requestsResponse;

  const CustodyGetRequetsSuccess(this.requestsResponse);

  @override
  List<Object> get props => [requestsResponse];
}

final class CustodyGetPastRequestsSuccess extends CustodyGetRequetsState {
  final CustodyGetPastRequestsResponse requestsResponse;

  const CustodyGetPastRequestsSuccess(this.requestsResponse);

  @override
  List<Object> get props => [requestsResponse];
}

final class CustodyGetRequetsFailure extends CustodyGetRequetsState {
  final ApiFailure failure;

  const CustodyGetRequetsFailure(this.failure);
}
