import 'package:assab/features/branch_manager_expenses/domain/entities/pre_approval_entity.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/single_invoice_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../../../core/widgets/time_lines_view.dart';
import '../../../domain/entities/grouped_invoice_entity.dart';
import '../../../domain/entities/quick_cash_entity.dart';
import '../../screens/expense_approval_view.dart';

sealed class ExpenseDetailsState extends Equatable {
  const ExpenseDetailsState();

  @override
  List<Object> get props => [];

  Widget buildTimeLinesView() {
    return const SizedBox.shrink();
  }

  Widget buildApprovalView() {
    return const SizedBox.shrink();
  }
}

final class ExpenseDetailsInitial extends ExpenseDetailsState {}

final class ExpenseDetailsLoading extends ExpenseDetailsState {}

final class ExpenseQuickCashDetailsSuccess extends ExpenseDetailsState {
  final QuickCashEntity quickCashResponseDataModel;

  const ExpenseQuickCashDetailsSuccess(this.quickCashResponseDataModel);

  @override
  List<Object> get props => [quickCashResponseDataModel];

  @override
  Widget buildTimeLinesView() {
    return TimeLinesView(
      timelines: quickCashResponseDataModel.timelines.timelines,
    );
  }

  @override
  Widget buildApprovalView() {
    return ExpenseApprovalView(approval: quickCashResponseDataModel.approval);
  }
}

final class ExpenseSingleInvoiceDetailsSuccess extends ExpenseDetailsState {
  final SingleInvoiceEntity singleInvoiceResponseDataModel;

  const ExpenseSingleInvoiceDetailsSuccess(this.singleInvoiceResponseDataModel);

  @override
  List<Object> get props => [singleInvoiceResponseDataModel];

  @override
  Widget buildTimeLinesView() {
    return TimeLinesView(
      timelines: singleInvoiceResponseDataModel.timelines.timelines,
    );
  }

  @override
  Widget buildApprovalView() {
    return ExpenseApprovalView(
      approval: singleInvoiceResponseDataModel.approval,
    );
  }
}

final class ExpensePreApprovalDetailsSuccess extends ExpenseDetailsState {
  final PreApprovalEntity preApprovalEntity;

  const ExpensePreApprovalDetailsSuccess(this.preApprovalEntity);

  @override
  List<Object> get props => [preApprovalEntity];

  @override
  Widget buildTimeLinesView() {
    return TimeLinesView(timelines: preApprovalEntity.timelines.timelines);
  }

  @override
  Widget buildApprovalView() {
    return ExpenseApprovalView(approval: preApprovalEntity.approval);
  }
}

final class ExpenseGroupedInvoiceDetailsSuccess extends ExpenseDetailsState {
  final GroupedInvoiceEntity groupedInvoiceEntity;

  const ExpenseGroupedInvoiceDetailsSuccess(this.groupedInvoiceEntity);

  @override
  List<Object> get props => [groupedInvoiceEntity];

  @override
  Widget buildTimeLinesView() {
    return TimeLinesView(timelines: groupedInvoiceEntity.timelines.timelines);
  }

  @override
  Widget buildApprovalView() {
    return ExpenseApprovalView(approval: groupedInvoiceEntity.approval);
  }
}

final class ExpenseDetailsFailure extends ExpenseDetailsState {
  final ApiFailure failure;

  const ExpenseDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
