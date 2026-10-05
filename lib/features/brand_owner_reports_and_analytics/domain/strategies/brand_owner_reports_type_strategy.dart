import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../brand_owner_requests/presentation/cubits/brand_owner_payment_log_cubit.dart';
import '../../presentation/cubit/brand_owner_expense_report_details_cubit.dart';
import '../../presentation/screens/brand_owner_custody_report_details_screen.dart';
import '../../presentation/screens/brand_owner_expense_report_details_screen.dart';

abstract class BrandOwnerReportsTypeStrategy {
  static BrandOwnerReportsTypeStrategy strategyForType(String type) {
    switch (type) {
      case 'expenses':
        return ExpensesReportTypeStrategy();
      case 'custody':
        return CustodyReportTypeStrategy();
      default:
        throw Exception('Unknown report type: $type');
    }
  }

  String title(BuildContext context);

  String get icon;

  void onTap(BuildContext context, String id, {VoidCallback? onExportSuccess}) {}
}

class ExpensesReportTypeStrategy extends BrandOwnerReportsTypeStrategy {
  @override
  String get icon => AppAssets.expenseSvg;

  @override
  String title(BuildContext context) {
    return context.tr.expenseReport;
  }

  @override
  void onTap(BuildContext context, String id, {VoidCallback? onExportSuccess}) {
    AppBottomSheet.customPageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<BrandOwnerExpenseReportDetailsCubit>(),
          ),
          BlocProvider(
            create: (context) =>
                getIt<BrandOwnerPaymentLogCubit>()
                  ..getBrandOwnerPaymentLogBranches(),
          ),
          BlocProvider(
            create: (context) => ValidationCubit(
              requiredFields: {'expenseType', 'branch'},
              optionalFields: {'expenseStatus', 'monthNumber', 'year'},
            ),
          ),
        ],
        child: BrandOwnerExpenseReportDetailsScreen(
          reportId: id,
          onExportSuccess: onExportSuccess,
        ),
      ),
    );
  }
}

class CustodyReportTypeStrategy extends BrandOwnerReportsTypeStrategy {
  @override
  String get icon => AppAssets.custody;

  @override
  String title(BuildContext context) {
    return context.tr.custodyReport;
  }

  @override
  void onTap(BuildContext context, String id, {VoidCallback? onExportSuccess}) {
    AppBottomSheet.customPageRoute(
      context,
      (context) => BrandOwnerCustodyReportDetailsScreen(
        onExportSuccess: onExportSuccess,
      ),
    );
  }
}
