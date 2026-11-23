import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/custody_preferred_receipt_method.dart';
import 'package:assab/core/enums/custody_requests_status_enum.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/routing/app_router.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/branch_manager_expenses/data/models/all_expense_response_model.dart';
import 'package:assab/features/branch_manager_expenses/data/repository/branch_manager_expenses_repository.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';
import 'package:assab/features/brand_owner_home/data/models/brand_owner_payment_request.dart';
import 'package:assab/features/brand_owner_requests/data/models/brand_owner_requests_models.dart';
import 'package:assab/features/brand_owner_requests/data/repositories/brand_owner_requests_repository.dart';
import 'package:assab/features/brand_owner_requests/presentation/cubits/brand_owner_requests_custody_sales_transfers_cubit.dart';
import 'package:assab/features/brand_owner_requests/presentation/screens/brand_owner_requests_screen.dart';
import 'package:assab/features/brand_owner_tools/presentation/screens/brand_owner_tools_screen.dart';
import 'package:assab/features/custody/data/models/custody_requests_response.dart';
import 'package:assab/features/custody/data/repository/custody_repository.dart';
import 'package:assab/features/custody/presentation/cubit/custody_get_requets/custody_get_requets_cubit.dart';
import 'package:assab/features/custody/presentation/widgets/custody_more_options_bottom_sheet_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeExpensesRepository extends Fake
    implements BranchManagerExpensesRepository {
  int getAllExpensesCalls = 0;

  @override
  FutureApiResult<AllExpenseResponseModel> getAllExpenses({
    required int page,
  }) async {
    getAllExpensesCalls++;
    return ApiResult.success(
      AllExpenseResponseModel(
        data: const [],
        meta: MetaModel(currentPage: 1, lastPage: 1, total: 0),
      ),
    );
  }
}

class _FakeCustodyRepository extends Fake implements CustodyRepository {
  int getRequestsCalls = 0;
  List<CustodyRequestItem> items = const [];

  @override
  FutureApiResult<CustodyRequestsResponse> getRequests({
    required String? status,
    required String? timePeriod,
  }) async {
    getRequestsCalls++;
    return ApiResult.success(
      CustodyRequestsResponse(data: CustodyRequestsData(requests: items)),
    );
  }
}

class _FakeBrandOwnerRequestsRepository extends Fake
    implements BrandOwnerRequestsRepository {
  int getSalesTransfersCalls = 0;
  List<BrandOwnerSalesTransferItemModel> items = const [];

  @override
  FutureApiResult<BrandOwnerRequestsCustodySalesTransfersResponse>
  getBrandOwnerRequestsCustodySalesTransfersView({required int page}) async {
    getSalesTransfersCalls++;
    return ApiResult.success(
      BrandOwnerRequestsCustodySalesTransfersResponse(
        data: items,
        meta: MetaModel(currentPage: 1, lastPage: 1, total: items.length),
      ),
    );
  }
}

Widget _wrapWithApp(Widget child, {RouteFactory? onGenerateRoute}) {
  return AppResponsiveBuilder(
    builder: (_) => MaterialApp(
      navigatorKey: onGenerateRoute == null
          ? null
          : NavigationService.I.navigatorKey,
      onGenerateRoute: onGenerateRoute,
      theme: AppTheme.light,
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: child,
    ),
  );
}

Future<void> _settleFrames(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump();
}

void main() {
  late _FakeExpensesRepository expensesRepo;
  late _FakeCustodyRepository custodyRepo;
  late _FakeBrandOwnerRequestsRepository ownerRequestsRepo;

  setUp(() async {
    await getIt.reset();
    expensesRepo = _FakeExpensesRepository();
    custodyRepo = _FakeCustodyRepository();
    ownerRequestsRepo = _FakeBrandOwnerRequestsRepository();

    getIt.registerFactory<BranchManagerExpensesHistoryCubit>(
      () => BranchManagerExpensesHistoryCubit(expensesRepo),
    );
    getIt.registerFactory<CustodyGetRequetsCubit>(
      () => CustodyGetRequetsCubit(custodyRepo),
    );
    getIt.registerFactory<BrandOwnerRequestsCustodySalesTransfersCubit>(
      () => BrandOwnerRequestsCustodySalesTransfersCubit(ownerRequestsRepo),
    );
  });

  tearDown(() async => getIt.reset());

  testWidgets(
    'owner tools select the payment method and open custody requests',
    (tester) async {
      final paymentMethods = <Object?>[];
      await tester.pumpWidget(
        _wrapWithApp(
          const Scaffold(body: BrandOwnerToolsScreen()),
          onGenerateRoute: (settings) {
            if (settings.name == AppRouteName.brandOwnerPaymentScreen) {
              paymentMethods.add(settings.arguments);
              return MaterialPageRoute<void>(builder: (_) => const Scaffold());
            }
            return AppRouter.generateRoute(settings);
          },
        ),
      );
      await _settleFrames(tester);
      for (final label in ['Cash Handover', 'Transfer to Branch']) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        NavigationService.I.pop();
        await tester.pumpAndSettle();
      }
      expect(paymentMethods, [
        CustodyPreferredReceiptMethod.cashHandover,
        CustodyPreferredReceiptMethod.bankTransfer,
      ]);
      final custody = find.text('Custody Management');
      await tester.ensureVisible(custody);
      await tester.tap(custody);
      await _settleFrames(tester);
      expect(custodyRepo.getRequestsCalls, 1);
      expect(expensesRepo.getAllExpensesCalls, 0);
      expect(ownerRequestsRepo.getSalesTransfersCalls, 0);
      expect(find.byType(BackButton), findsOneWidget);
    },
  );

  test('owner payment sends the date for the selected receipt method', () {
    for (final method in CustodyPreferredReceiptMethod.values) {
      const date = '2026-11-23';
      final request = BrandOwnerPaymentRequest(
        branchId: 'manager-1',
        amount: 50,
        paymentMethod: method.value,
        transferDate: date,
        purpose: null,
        handoverDate: date,
        receiptImage: null,
        note: 'Branch funding',
      );
      final fields = Map<String, String>.fromEntries(
        request.toFormData().fields,
      );
      expect(fields['preferredReceiptMethod'], method.value);
      expect(fields['note'], 'Branch funding');
      if (method == CustodyPreferredReceiptMethod.bankTransfer) {
        expect(fields['transferDate'], date);
        expect(fields['handoverDate'], isNull);
      } else {
        expect(fields['handoverDate'], date);
        expect(fields['transferDate'], isNull);
      }
    }
  });

  testWidgets(
    'refreshes active sub-tab only on tab activation and sub-tab switch, and updates AppBar counts including salesTransfersCount',
    (tester) async {
      custodyRepo.items = [
        CustodyRequestItem(
          id: 'cust-1',
          type: 'Custody Request',
          submittedBy: 'Mohamed Manager',
          dateTime: '2026-11-23T01:00:00Z',
          status: CustodyRequestsStatusEnum.pending,
          amount: 500,
          preferredReceiptMethod: 'Bank Transfer',
          purpose: 'Branch Float',
        ),
      ];
      ownerRequestsRepo.items = [
        const BrandOwnerSalesTransferItemModel(
          id: 'xfer-1',
          submittedBy: 'Mohamed Manager',
          amount: 300,
          dateTime: '2026-11-23T01:05:00Z',
          status: CustodyRequestsStatusEnum.pending,
        ),
        const BrandOwnerSalesTransferItemModel(
          id: 'xfer-2',
          submittedBy: 'Mohamed Manager',
          amount: 150,
          dateTime: '2026-11-23T01:10:00Z',
          status: CustodyRequestsStatusEnum.pending,
        ),
      ];

      final innerPagingCubit = PagingCubit(totalSteps: 3);
      addTearDown(innerPagingCubit.close);
      final validationCubit = ValidationCubit(requiredFields: {});
      addTearDown(validationCubit.close);
      final activeNotifier = ValueNotifier<bool>(false);
      addTearDown(activeNotifier.dispose);

      await tester.pumpWidget(
        _wrapWithApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: innerPagingCubit),
              BlocProvider.value(value: validationCubit),
            ],
            child: ValueListenableBuilder<bool>(
              valueListenable: activeNotifier,
              builder: (context, isActive, _) =>
                  BrandOwnerRequestsScreen(isActiveTab: isActive),
            ),
          ),
        ),
      );
      await _settleFrames(tester);

      // Must NOT fetch anything while BrandOwnerRequestsScreen is an inactive IndexedStack tab.
      expect(expensesRepo.getAllExpensesCalls, 0);
      expect(custodyRepo.getRequestsCalls, 0);
      expect(ownerRequestsRepo.getSalesTransfersCalls, 0);

      // Entering Requests tab triggers immediate fetch for the active sub-tab (Expenses = 0).
      activeNotifier.value = true;
      await _settleFrames(tester);
      expect(expensesRepo.getAllExpensesCalls, 1);
      expect(find.textContaining('(0)'), findsOneWidget);

      // Switching to Custody Requests sub-tab (index 1) fetches custody requests and updates count.
      final context = tester.element(find.byType(BrandOwnerRequestsScreen));
      final strings = S.of(context);
      await tester.tap(find.text(strings.custodyRequests));
      await _settleFrames(tester);
      expect(custodyRepo.getRequestsCalls, 1);
      expect(find.text('Mohamed Manager'), findsWidgets);
      expect(find.text('${strings.pending} (1)'), findsOneWidget);

      // Switching to Cash Sales Transfers sub-tab (index 2) fetches sales transfers and updates count.
      await tester.ensureVisible(find.text(strings.cashSalesTransfers));
      await tester.pump();
      await tester.tap(find.text(strings.cashSalesTransfers));
      await _settleFrames(tester);
      expect(ownerRequestsRepo.getSalesTransfersCalls, 1);
      expect(find.text('${strings.pending} (2)'), findsOneWidget);

      // Switching back to Custody Requests triggers another fresh fetch (never stale).
      await tester.ensureVisible(find.text(strings.custodyRequests));
      await tester.pump();
      await tester.tap(find.text(strings.custodyRequests));
      await _settleFrames(tester);
      expect(custodyRepo.getRequestsCalls, 2);

      // Deactivating and re-activating Requests tab refreshes the currently selected sub-tab.
      activeNotifier.value = false;
      await _settleFrames(tester);
      activeNotifier.value = true;
      await _settleFrames(tester);
      expect(custodyRepo.getRequestsCalls, 3);

      expect(tester.takeException(), isNull);
    },
  );

  test(
    'BrandOwnerSalesTransferItemModel.fromJson handles null submittedBy and dateTime safely',
    () {
      final model = BrandOwnerSalesTransferItemModel.fromJson(const {
        'id': 'xfer-null',
        'submittedBy': null,
        'amount': 420.5,
        'dateTime': null,
        'status': null,
      });

      expect(model.id, 'xfer-null');
      expect(model.submittedBy, '-');
      expect(model.dateTime, '');
      expect(model.amount, 420.5);
      expect(model.status, CustodyRequestsStatusEnum.pending);
    },
  );

  testWidgets(
    'CustodyMoreOptionsBottomSheetWidget distinguishes Cash Transfer to Custody from Cash Handover',
    (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const Scaffold(
            body: SingleChildScrollView(
              child: CustodyMoreOptionsBottomSheetWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(
        find.byType(CustodyMoreOptionsBottomSheetWidget),
      );
      final strings = S.of(context);

      expect(find.text(strings.cashTransferToCustody), findsOneWidget);
      expect(
        find.text(strings.transferFromYourPersonalCustodyToTheBranchCustodyTo),
        findsOneWidget,
      );
      expect(find.text(strings.cashHandover), findsOneWidget);
      expect(
        find.text(strings.confirmWhoWillReceiveTheCashAndAmount),
        findsOneWidget,
      );
      expect(find.text(strings.handoverToCustodyowner), findsNothing);
      expect(find.text(strings.handoverToCashier), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
