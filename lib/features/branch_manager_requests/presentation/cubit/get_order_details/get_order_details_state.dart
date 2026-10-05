import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../shared/models/supplier_details_response.dart';
import '../../../../../shared/models/time_line_response.dart';
import '../../../data/models/direct_supplier_order_details_response.dart';
import '../../../data/models/officer_order_details_response.dart';
import '../../../data/models/order_details_response.dart';

sealed class GetOrderDetailsState extends Equatable {
  const GetOrderDetailsState();

  @override
  List<Object> get props => [];

  void addTrackView(BuildContext context) {}

  void addSaveApproval(BuildContext context) {}

  void addSaveTimeLine(BuildContext context) {}
}

final class GetOrderDetailsInit extends GetOrderDetailsState {
  const GetOrderDetailsInit();
}

final class GetOrderDetailsLoading extends GetOrderDetailsState {
  const GetOrderDetailsLoading();
}

final class GetBranchOrderDetailsSuccess extends GetOrderDetailsState {
  final OrderDetailsResponse orderDetails;

  const GetBranchOrderDetailsSuccess(this.orderDetails);

  @override
  List<Object> get props => [orderDetails];

  @override
  void addSaveTimeLine(BuildContext context) {
    super.addSaveTimeLine(context);

    context.read<ValidationCubit>().validateFieldAndStoreList<TimeLineItem>(
      fieldName: 'timelines',
      value: orderDetails.data.timelines.timelines,
      isValid: true,
    );
  }
}

final class GetDirectSupplierOrderDetailsSuccess extends GetOrderDetailsState {
  final DirectSupplierOrderDetailsResponse orderDetails;

  const GetDirectSupplierOrderDetailsSuccess(this.orderDetails);

  @override
  List<Object> get props => [orderDetails];

  @override
  void addTrackView(BuildContext context) {
    orderDetails.requestSummary.status.addTrackView(
      context,
      orderDetails.requestSummary.id,
    );
  }

  @override
  void addSaveApproval(BuildContext context) {
    super.addSaveApproval(context);

    context
        .read<ValidationCubit>()
        .validateFieldAndStoreTypedValue<SupplierDetailsResponse>(
          fieldName: 'approval',
          value: orderDetails.supplier,
          isValid: true,
        );
  }

  @override
  void addSaveTimeLine(BuildContext context) {
    super.addSaveTimeLine(context);

    context.read<ValidationCubit>().validateFieldAndStoreList<TimeLineItem>(
      fieldName: 'timelines',
      value: orderDetails.timelines.timelines,
      isValid: true,
    );
  }
}

final class GetOfficerOrderDetailsSuccess extends GetOrderDetailsState {
  final OfficerOrderDetailsResponse orderDetails;

  const GetOfficerOrderDetailsSuccess(this.orderDetails);

  @override
  List<Object> get props => [orderDetails];

  @override
  void addTrackView(BuildContext context) {
    orderDetails.requestSummary.status.addTrackView(
      context,
      orderDetails.requestSummary.id,
    );
  }

  @override
  void addSaveTimeLine(BuildContext context) {
    super.addSaveTimeLine(context);

    context.read<ValidationCubit>().validateFieldAndStoreList<TimeLineItem>(
      fieldName: 'timelines',
      value: orderDetails.timelines.timelines,
      isValid: true,
    );
  }
}

final class GetOrderDetailsFailure extends GetOrderDetailsState {
  final ApiFailure failure;

  const GetOrderDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
