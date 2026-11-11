import 'package:assab/core/cubits/data_management/date_management/date_management_cubit.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/cashier_home/presentation/screens/cashier_account_statement_screen.dart';
import 'package:assab/features/cashier_my_shifts/presentation/screens/cashier_ledger_view.dart';
import 'package:assab/features/custody/data/models/custody_personal_balance_response.dart';
import 'package:assab/features/custody/data/repository/custody_repository.dart';
import 'package:assab/features/custody/presentation/cubit/get_personal_balance/get_personal_balance_cubit.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCustodyRepository implements CustodyRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  FutureApiResult<CustodyPersonalBalanceResponse> getPersonalBalance({
    String? month,
    String? year,
  }) async {
    return ApiResult.success(
      CustodyPersonalBalanceResponse(
        totalCashIn: 5000.0,
        totalCashOut: 3500.0,
        currentBalance: 1500.0,
        recentActivity: [
          CustodyPersonalBalanceResponseRecentActivity(
            transactionType: 'تسليم وردية',
            amount: '1500.0',
            dateTime: '2026-11-11 14:00',
            isCashIn: true,
          ),
        ],
      ),
    );
  }
}

Widget buildTestableApp(Widget child, {Locale locale = const Locale('ar')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(extensions: LightTheme.extension),
    home: Scaffold(
      body: Builder(
        builder: (context) {
          AppResponsive.init(context, designWidth: 375, designHeight: 812);
          return child;
        },
      ),
    ),
  );
}

void main() {
  group('MT-27: Cashier Account Statement Real Data Entry Point & Ledger Tab Tests', () {
    testWidgets(
      'CashierAccountStatementScreen renders real non-zero balance and transactions from GetPersonalBalanceCubit',
      (tester) async {
        final mockRepo = MockCustodyRepository();
        final balanceCubit = GetPersonalBalanceCubit(mockRepo);
        final dateCubit = DateManagementCubit();

        await tester.pumpWidget(
          buildTestableApp(
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: balanceCubit),
                BlocProvider.value(value: dateCubit),
              ],
              child: const CashierAccountStatementScreen(),
            ),
            locale: const Locale('ar'),
          ),
        );

        // Allow async cubit getPersonalBalance to resolve
        await tester.pump();
        await tester.pumpAndSettle();

        // Must display the non-zero live balance (1500.00)
        expect(find.text('1500.00'), findsOneWidget);
        expect(find.text('رصيد العهدة الشخصية'), findsOneWidget);

        await balanceCubit.close();
        await dateCubit.close();
      },
    );

    testWidgets(
      'CashierLedgerView does not display false hardcoded 0 or misleading empty activity state',
      (tester) async {
        await tester.pumpWidget(
          buildTestableApp(
            const CashierLedgerView(),
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();

        // Must NOT contain hardcoded "قوائم أعمالي (0)"
        expect(find.textContaining('(0)'), findsNothing);
        // Must NOT contain fake "لا يوجد أي نشاط حتى الآن"
        expect(find.text('لا يوجد أي نشاط حتى الآن'), findsNothing);

        // Must display link/button to authorized Account Statement screen
        expect(find.text('كشف الحساب'), findsWidgets);
      },
    );
  });
}
