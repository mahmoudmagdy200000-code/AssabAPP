import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

enum ExpensesStatus {
  draft('draft'),
  approved('approved'),
  rejected('rejected'),
  pending('pending');

  final String _key;

  const ExpensesStatus(this._key);

  String get key => _key;

  String displayName(BuildContext context) {
    switch (this) {
      case ExpensesStatus.draft:
        return context.tr.draft;
      case ExpensesStatus.approved:
        return context.tr.approved;
      case ExpensesStatus.rejected:
        return context.tr.rejected;
      case ExpensesStatus.pending:
        return context.tr.pending;
    }
  }

  Color statusColor() {
    switch (this) {
      case ExpensesStatus.draft:
        return Colors.grey;
      case ExpensesStatus.approved:
        return AppColors.darkGreen;
      case ExpensesStatus.rejected:
        return AppColors.errorLight;
      case ExpensesStatus.pending:
        return AppColors.yellow;
    }
  }

  static ExpensesStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return ExpensesStatus.draft;
      case 'approved':
        return ExpensesStatus.approved;
      case 'rejected':
        return ExpensesStatus.rejected;
      case 'pending':
        return ExpensesStatus.pending;
      default:
        return ExpensesStatus.pending;
    }
  }
}
