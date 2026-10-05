import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/receive_order_inspection_response.dart';

sealed class GetReceiveOrderInspectionState extends Equatable {
  const GetReceiveOrderInspectionState();

  @override
  List<Object> get props => [];
}

final class GetReceiveOrderInspectionInit
    extends GetReceiveOrderInspectionState {
  const GetReceiveOrderInspectionInit();
}

final class GetReceiveOrderInspectionLoading
    extends GetReceiveOrderInspectionState {
  const GetReceiveOrderInspectionLoading();
}

final class GetReceiveOrderInspectionSuccess
    extends GetReceiveOrderInspectionState {
  final ReceiveOrderInspectionResponse response;

  const GetReceiveOrderInspectionSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetReceiveOrderInspectionFailure
    extends GetReceiveOrderInspectionState {
  final ApiFailure failure;

  const GetReceiveOrderInspectionFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
