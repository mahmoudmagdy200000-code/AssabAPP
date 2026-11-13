import 'package:assab/core/cubits/data_management/date_management/date_management_cubit.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_button.dart';
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

Widget buildTestableApp({
  required Widget child,
  RouteFactory? onGenerateRoute,
  Locale locale = const Locale('ar'),
}) {
  return MaterialApp(
    navigatorKey: NavigationService.I.navigatorKey,
    locale: locale,
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: ThemeData(extensions: LightTheme.extension),
    onGenerateRoute: onGenerateRoute,
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
      'tapping account statement button in CashierLedgerView opens CashierAccountStatementScreen and renders real non-zero balance',
      (tester) async {
        final mockRepo = MockCustodyRepository();
        final balanceCubit = GetPersonalBalanceCubit(mockRepo);
        final dateCubit = DateManagementCubit();

        await tester.pumpWidget(
          buildTestableApp(
            child: const CashierLedgerView(),
            onGenerateRoute: (settings) {
              if (settings.name == AppRouteName.accountStatementScreen) {
                return MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: balanceCubit),
                      BlocProvider.value(value: dateCubit),
                    ],
                    child: const CashierAccountStatementScreen(),
                  ),
                );
              }
              return null;
            },
            locale: const Locale('ar'),
          ),
        );
        await tester.pumpAndSettle();

        // Initially in CashierLedgerView:
        // Must NOT contain hardcoded "قوائم أعمالي (0)"
        expect(find.textContaining('(0)'), findsNothing);
        // Must NOT contain fake "لا يوجد أي نشاط حتى الآن"
        expect(find.text('لا يوجد أي نشاط حتى الآن'), findsNothing);

        // Verify button exists
        final buttonFinder = find.widgetWithText(AppButton, 'كشف الحساب');
        expect(buttonFinder, findsOneWidget);

        // Tap the button to navigate to authorized statement screen
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        // Must now be on CashierAccountStatementScreen showing live non-zero balance and financial activity summary
        expect(find.text('رصيد العهدة الشخصية'), findsOneWidget);
        expect(find.text('1500.00'), findsOneWidget);
        expect(find.text('إجمالي النقد الداخل'), findsOneWidget);
        expect(find.text('5000.00'), findsOneWidget);
        expect(find.text('إجمالي النقد الخارج'), findsOneWidget);
        expect(find.text('3500.00'), findsOneWidget);
        expect(find.text('الأنشطة الأخيرة'), findsOneWidget);

        await balanceCubit.close();
        await dateCubit.close();
      },
    );

    testWidgets(
      'CashierAccountStatementScreen renders real non-zero balance and transactions from GetPersonalBalanceCubit directly',
      (tester) async {
        final mockRepo = MockCustodyRepository();
        final balanceCubit = GetPersonalBalanceCubit(mockRepo);
        final dateCubit = DateManagementCubit();

        await tester.pumpWidget(
          buildTestableApp(
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: balanceCubit),
                BlocProvider.value(value: dateCubit),
              ],
              child: const CashierAccountStatementScreen(),
            ),
            locale: const Locale('ar'),
          ),
        );

        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('1500.00'), findsOneWidget);
        expect(find.text('رصيد العهدة الشخصية'), findsOneWidget);

        await balanceCubit.close();
        await dateCubit.close();
      },
    );
  });
}
