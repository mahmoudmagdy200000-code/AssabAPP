import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/expenses_steragies_keys.dart';
import '../../presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';

abstract class ExpenseCategory {
  static ExpenseCategory fromType(String type) {
    if (type.toLowerCase() == ExpensesStrategiesKeys.quickCash.key) {
      return const QuickCashExpense();
    } else if (type.toLowerCase() == ExpensesStrategiesKeys.singleInvoice.key) {
      return const SingleInvoiceExpense();
    } else if (type.toLowerCase() ==
        ExpensesStrategiesKeys.groupedInvoice.key) {
      return const GroupInvoicesExpense();
    } else if (type.toLowerCase() == ExpensesStrategiesKeys.preApproval.key) {
      return const PreApprovalExpense();
    } else if (type.toLowerCase() == 'draft') {
      return const DraftExpense();
    } else {
      return const AllExpense();
    }
  }

  void get(BuildContext context);

  String name(BuildContext context);

  String get icon;

  String title(BuildContext context);

  String desc(BuildContext context);
}

class AllExpense implements ExpenseCategory {
  const AllExpense();

  @override
  void get(BuildContext context) {
    context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(type: this);
  }

  @override
  String name(BuildContext context) => context.tr.all;

  @override
  @override
  String title(BuildContext context) => context.tr.noExpensesYet;

  @override
  String desc(BuildContext context) => context.tr.noExpensesYetDesc;

  @override
  String get icon => AppAssets.expensesEmptyPNG;
}

class DraftExpense implements ExpenseCategory {
  const DraftExpense();

  @override
  void get(BuildContext context) {
    context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(type: this);
  }

  @override
  String name(BuildContext context) => context.tr.draft;

  @override
  String title(BuildContext context) => context.tr.nothingInDrafts;

  @override
  String desc(BuildContext context) => context.tr.nothingInDraftsDesc;

  @override
  String get icon => AppAssets.draftPNG;
}

class QuickCashExpense implements ExpenseCategory {
  const QuickCashExpense();

  @override
  void get(BuildContext context) {
    context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(type: this);
  }

  @override
  String name(BuildContext context) => context.tr.quickCashExpense;

  @override
  String get icon => AppAssets.quickCashPNG;

  @override
  String title(BuildContext context) => context.tr.noQuickCashExpensesRecorded;

  @override
  String desc(BuildContext context) =>
      context.tr.noQuickCashExpensesRecordedDesc;
}

class SingleInvoiceExpense implements ExpenseCategory {
  const SingleInvoiceExpense();

  @override
  void get(BuildContext context) {
    context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(type: this);
  }

  @override
  String name(BuildContext context) => context.tr.singleInvoice;

  @override
  String get icon => AppAssets.singleInvoicePNG;

  @override
  String title(BuildContext context) => context.tr.noExpensesYet;

  @override
  String desc(BuildContext context) => context.tr.singleInvoiceDesc;
}

class GroupInvoicesExpense implements ExpenseCategory {
  const GroupInvoicesExpense();

  @override
  void get(BuildContext context) {
    context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(type: this);
  }

  @override
  String name(BuildContext context) => context.tr.groupedInvoices;

  @override
  String get icon => AppAssets.groupInvoicesPNG;

  @override
  String title(BuildContext context) => context.tr.noExpensesYet;

  @override
  String desc(BuildContext context) => context.tr.groupedInvoicesDesc;
}

class PreApprovalExpense implements ExpenseCategory {
  const PreApprovalExpense();

  @override
  void get(BuildContext context) {
    context.read<BranchManagerExpensesHistoryCubit>().loadExpenses(type: this);
  }

  @override
  String name(BuildContext context) => context.tr.preApprovalRequest;

  @override
  String get icon => AppAssets.preApprovalPNG;

  @override
  String title(BuildContext context) => context.tr.noPreApprovalRequestsYet;

  @override
  String desc(BuildContext context) => context.tr.noPreApprovalRequestsYetDesc;
}
