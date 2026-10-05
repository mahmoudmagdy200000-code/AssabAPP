import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/custody_request_details_response.dart';

sealed class GetCustodyDetailsState extends Equatable {
  const GetCustodyDetailsState();

  @override
  List<Object> get props => [];
}

final class GetCustodyDetailsInit extends GetCustodyDetailsState {
  const GetCustodyDetailsInit();
}

final class GetCustodyDetailsLoading extends GetCustodyDetailsState {
  const GetCustodyDetailsLoading();
}

final class GetCustodyRequestDetailsSuccess extends GetCustodyDetailsState {
  final CustodyRequestDetailsResponse details;

  const GetCustodyRequestDetailsSuccess(this.details);

  @override
  List<Object> get props => [details];
}

final class GetCustodyDetailsFailure extends GetCustodyDetailsState {
  final ApiFailure failure;

  const GetCustodyDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
