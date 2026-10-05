import 'package:assab/features/branch_manager_requests/data/models/approve_all_order_request.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/partial_approve_order_request.dart';
import '../../presentation/cubit/approve_or_reject_order/approve_or_reject_order_cubit.dart';

abstract class ApproveOrRejectOrderStrategy {
  void updateReadyTime(String readyTime) {}

  void execute(BuildContext context) {}
}

class ApproveAllOrderStrategy extends ApproveOrRejectOrderStrategy {
  final ApproveAllOrderRequest body;
  final String orderId;

  ApproveAllOrderStrategy({required this.body, required this.orderId});

  @override
  void updateReadyTime(String readyTime) {
    super.updateReadyTime(readyTime);

    body.updateReadyTime(readyTime);
  }

  @override
  void execute(BuildContext context) {
    context.read<ApproveOrRejectOrderCubit>().approveOrder(
      orderId: orderId,
      body: body,
    );
  }
}

class PartialApproveOrderStrategy extends ApproveOrRejectOrderStrategy {
  final PartialApproveOrderRequest body;
  final String orderId;

  PartialApproveOrderStrategy({required this.body, required this.orderId});

  @override
  void updateReadyTime(String readyTime) {
    super.updateReadyTime(readyTime);

    body.updateReadyTime(readyTime);
  }

  @override
  void execute(BuildContext context) {
    context.read<ApproveOrRejectOrderCubit>().partialApproveOrder(
      orderId: orderId,
      body: body,
    );
  }
}

class RejectOrderStrategy extends ApproveOrRejectOrderStrategy {}
