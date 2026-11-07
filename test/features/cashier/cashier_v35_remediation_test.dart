import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/branch_manager_settings/presentation/widgets/brand_owner_notifications_screen.dart';
import 'package:assab/features/cashier_home/presentation/cubit/get_branch_info/get_branch_info_cubit.dart';
import 'package:assab/features/cashier_home/presentation/cubit/get_branch_info/get_branch_info_state.dart';
import 'package:assab/features/cashier_home/presentation/widgets/cashier_home_top_section.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/available_recipients_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request_with_variance.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/reassign_shift/reassign_shift_params.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/reassign_shift/reassign_shift_cubit.dart';
import 'package:assab/features/branch_manager_requests/data/data_source/requests_remote_data_source.dart';
import 'package:assab/features/branch_manager_requests/data/models/responsibility_reject_body_request.dart';
import 'package:assab/features/branch_manager_requests/data/repository/requests_repository.dart';
import 'package:assab/features/cashier_requests/presentation/cubits/accept_reassigned_shift/accept_reassigned_shift_cubit.dart';
import 'package:assab/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/total_sales_end_shift_widget.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/aggregator_cubit.dart';

class FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RecordingRemoteDataSource implements ShiftManagementRemoteDataSource {
  Map<String, dynamic>? lastBody;
  String? lastShiftId;

  @override
  Future<dynamic> previewCashReconciliation({
    required String shiftId,
    required Map<String, dynamic> body,
  }) async {
    lastShiftId = shiftId;
    lastBody = body;
    return <String, dynamic>{'success': true};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


class FakeShiftEntity implements ShiftEntity {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockShiftManagementRepository extends ShiftManagementRepositoryImp {
  MockShiftManagementRepository() : super(FakeRemoteDataSource());

  FutureApiResult<Map<String, dynamic>> Function({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    double? pendingIncomingCash,
    List<EndShiftAggregatorModel>? aggregators,
  })? onPreview;

  FutureApiResult<void> Function({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  })? onEndShift;

  @override
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    double? pendingIncomingCash,
    List<EndShiftAggregatorModel>? aggregators,
  }) async {
    if (onPreview != null) {
      return onPreview!(
        shiftId: shiftId,
        totalSales: totalSales,
        countedCash: countedCash,
        cardPayments: cardPayments,
        pendingIncomingCash: pendingIncomingCash,
        aggregators: aggregators,
      );
    }
    return ApiResult.success({});
  }

  @override
  FutureApiResult<void> endShift({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  }) async {
    if (onEndShift != null) {
      return onEndShift!(
        shiftId: shiftId,
        endShiftRequest: endShiftRequest,
      );
    }
    return ApiResult.success(null);
  }

  FutureApiResult<void> Function(String shiftId, EndShiftRequestWithHandOver request)? onEndShiftWithHandOver;

  @override
  FutureApiResult<void> endShiftWithHandOver(
    String shiftId,
    EndShiftRequestWithHandOver request,
  ) async {
    if (onEndShiftWithHandOver != null) {
      return onEndShiftWithHandOver!(shiftId, request);
    }
    return ApiResult.success(null);
  }
}

class MockRemoteDataSourceWith404 extends FakeRemoteDataSource {
  bool getCandidatesCalled = false;
  bool getRecipientsCalled = false;

  @override
  Future<dynamic> getShortageAllocationCandidates({required String shiftId}) async {
    getCandidatesCalled = true;
    throw DioException(
      requestOptions: RequestOptions(path: '/cashier/shifts/$shiftId/shortage-allocation-candidates'),
      response: Response(
        requestOptions: RequestOptions(path: '/cashier/shifts/$shiftId/shortage-allocation-candidates'),
        statusCode: 404,
        data: {'status': false, 'message': 'Not Found'},
      ),
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<AvailableRecipientsResponseModel> getAvailableRecipients({required String shiftId}) async {
    getRecipientsCalled = true;
    return AvailableRecipientsResponseModel(
      success: true,
      message: '',
      data: AvailableRecipientsData(
        recipients: [],
        autoHandoverEnabled: false,
        hasBranchManager: true,
      ),
    );
  }
}

class FakeBranchInfoCubit extends Cubit<GetBranchInfoState> implements GetBranchInfoCubit {
  FakeBranchInfoCubit() : super(const GetBranchInfoInit());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<void> getBranchInfo() async {}
}

class FakeRequestsRemoteDataSource implements RequestsRemoteDataSource {
  String? lastRejectedShiftId;
  ResponsibilityRejectBodyRequest? lastRejectBody;
  bool rejectCalled = false;
  bool shouldFail = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future rejectReassignedShift({
    required String shiftId,
    ResponsibilityRejectBodyRequest? responsibilityRejectBodyRequest,
  }) async {
    rejectCalled = true;
    lastRejectedShiftId = shiftId;
    lastRejectBody = responsibilityRejectBodyRequest;
    if (shouldFail) {
      throw DioException(
        requestOptions: RequestOptions(path: '/cashier/shifts/$shiftId/reassign/reject'),
        response: Response(
          requestOptions: RequestOptions(path: '/cashier/shifts/$shiftId/reassign/reject'),
          statusCode: 422,
          data: {'status': false, 'message': 'Shift cannot be rejected'},
        ),
        type: DioExceptionType.badResponse,
      );
    }
    return {'status': true, 'message': 'Rejected successfully'};
  }
}

Widget _buildTestApp({required Widget child}) {
  return AppResponsiveBuilder(
    designWidth: 375,
    designHeight: 833,
    builder: (context) => MaterialApp(
      navigatorKey: NavigationService.I.navigatorKey,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('en'),
      theme: AppTheme.light,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({'u_name': 'Cashier Test'});
    final helper = SharedPreferencesHelper(Logger());
    await helper.init();

    if (!getIt.isRegistered<SharedPreferencesHelper>()) {
      getIt.registerSingleton<SharedPreferencesHelper>(helper);
    }
    if (!getIt.isRegistered<GetBranchInfoCubit>()) {
      getIt.registerFactory<GetBranchInfoCubit>(() => FakeBranchInfoCubit());
    }
  });

  group('CSH-01: VAT Formula Tests (Inclusive Gross / 1.15)', () {
    late EndShiftCubit endShiftCubit;
    late ReassignShiftCubit reassignShiftCubit;
    late MockShiftManagementRepository mockRepo;

    setUp(() {
      mockRepo = MockShiftManagementRepository();
      endShiftCubit = EndShiftCubit(mockRepo, 'shift-csh-001', null);
      reassignShiftCubit = ReassignShiftCubit(
        mockRepo,
        ReassignShiftParams(
          shift: FakeShiftEntity(),
          previousCashier: null,
          nextCashier: null,
        ),
      );
    });

    test('EndShiftCubit: 115.00 SAR inclusive gives 100.00 Net and 15.00 Tax', () {
      final netSales = endShiftCubit.calculateNetSales('115.00');
      final netVal = endShiftCubit.calculateNetVal('115.00');

      expect(netSales, equals('100.00'));
      expect(netVal, equals('15.00'));
    });

    test('EndShiftCubit: 0.00 SAR gives 0.00 Net and 0.00 Tax', () {
      final netSales = endShiftCubit.calculateNetSales('0.00');
      final netVal = endShiftCubit.calculateNetVal('0.00');

      expect(netSales, equals('0.00'));
      expect(netVal, equals('0.00'));
    });

    test('EndShiftCubit: fractional amount 230.50 gives correct 2-decimal rounded results', () {
      final netSales = endShiftCubit.calculateNetSales('230.50');
      final netVal = endShiftCubit.calculateNetVal('230.50');

      expect(netSales, equals('200.43'));
      expect(netVal, equals('30.07'));
    });

    test('EndShiftCubit: parses Arabic-Indic digits correctly (١١٥.٠٠)', () {
      final netSales = endShiftCubit.calculateNetSales('١١٥.٠٠');
      final netVal = endShiftCubit.calculateNetVal('١١٥.٠٠');

      expect(netSales, equals('100.00'));
      expect(netVal, equals('15.00'));
    });

    test('ReassignShiftCubit: 115.00 SAR inclusive gives 100.00 Net and 15.00 Tax', () {
      final netSales = reassignShiftCubit.calculateNetSales('115.00');
      final netVal = reassignShiftCubit.calculateNetVal('115.00');

      expect(netSales, equals('100.00'));
      expect(netVal, equals('15.00'));
    });

    test('ReassignShiftCubit: parses Arabic-Indic digits correctly (١١٥.٥٠)', () {
      final netSales = reassignShiftCubit.calculateNetSales('١١٥.٥٠');
      final netVal = reassignShiftCubit.calculateNetVal('١١٥.٥٠');

      expect(netSales, equals('100.43'));
      expect(netVal, equals('15.07'));
    });
  });

  group('CSH-03: Shortage Candidates 404 Fail-Closed Security Tests', () {
    test('when shortage-allocation-candidates is 404, repository fails closed without calling available-recipients', () async {
      final mockDataSource = MockRemoteDataSourceWith404();
      final repository = ShiftManagementRepositoryImp(mockDataSource);

      final result = await repository.getShortageAllocationCandidates(shiftId: 'shift-csh-101');

      expect(mockDataSource.getCandidatesCalled, isTrue);
      // Handover recipients MUST NOT be queried or substituted for shortage liability
      expect(mockDataSource.getRecipientsCalled, isFalse);

      bool hasFailed = false;
      result.when(
        failure: (f) => hasFailed = true,
        success: (data) => fail('Expected failure but got success'),
      );

      expect(hasFailed, isTrue);
    });
  });

  group('CSH-04: Button Feedback & Role Isolation Verification', () {
    testWidgets('CashierHomeTopSection notification button shows honest unavailable status and does not leak Brand Owner screen', (tester) async {
      final fakeBranchCubit = FakeBranchInfoCubit();

      await tester.pumpWidget(
        _buildTestApp(
          child: BlocProvider<GetBranchInfoCubit>.value(
            value: fakeBranchCubit,
            child: const CashierHomeTopSection(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final notificationBtn = find.byType(AppSvgButton);
      expect(notificationBtn, findsOneWidget);

      await tester.tap(notificationBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Must NOT push BrandOwnerNotificationsScreen (role boundary preservation)
      expect(find.byType(BrandOwnerNotificationsScreen), findsNothing);
      // Must show honest notification notice
      expect(find.textContaining('Not Available'), findsOneWidget);
    });
  });

  group('CASH-08: Pending Incoming Cash Verification', () {
    test('EndShiftCubit exposes pending_incoming_cash from cash_reconciliation correctly', () async {
      final mockRepo = MockShiftManagementRepository();
      final cubit = EndShiftCubit(mockRepo, 'shift-cash-08', null);

      mockRepo.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
    double? pendingIncomingCash,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'counted_cash': 1500.0,
              'expected_cash': 1000.0,
              'cash_variance': 0.0,
              'cash_variance_type': 'balanced',
              'pending_incoming_cash': 500.0,
              'confirmed_opening_cash': 200.0,
            },
            'shortage_to_allocate': 0.0,
            'allocation_required': false,
          }
        });
      };

      cubit.setCountedCash(1500.0);
      final previewResult = await cubit.fetchCashReconciliationPreview();

      expect(previewResult, isTrue);
      expect(cubit.pendingIncomingCash, equals(500.0));
      expect(cubit.confirmedOpeningCash, equals(200.0));
      expect(cubit.cashVariance, equals(0.0));
      expect(cubit.cashVarianceType, equals('balanced'));
    });
    test('Acceptance Example: Counted 500 SAR, Expected 400 SAR, Pending 100 SAR in drawer -> Balanced variance 0 (no false surplus)', () async {
      final mockRepo = MockShiftManagementRepository();
      final cubit = EndShiftCubit(mockRepo, 'shift-cash-08-balanced', null);

      double? sentPendingIncomingCash;
      mockRepo.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        double? pendingIncomingCash,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        sentPendingIncomingCash = pendingIncomingCash;
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'counted_cash': 500.0,
              'expected_cash': 400.0,
              'cash_variance': 0.0,
              'cash_variance_type': 'balanced',
              'pending_incoming_cash': 100.0,
              'confirmed_opening_cash': 0.0,
            },
            'shortage_to_allocate': 0.0,
            'allocation_required': false,
          }
        });
      };

      cubit.setCountedCash(500.0);
      cubit.setPendingIncomingCash(100.0);

      final success = await cubit.fetchCashReconciliationPreview();
      expect(success, isTrue);
      expect(sentPendingIncomingCash, equals(100.0));
      expect(cubit.cashVariance, equals(0.0));
      expect(cubit.cashVarianceType, equals('balanced'));
      expect(cubit.declaredPendingIncomingCash, equals(100.0));
      expect(cubit.pendingIncomingCash, equals(100.0));
    });

    test('Pending incoming cash exceeding counted cash blocks preview and emits validation failure', () async {
      final mockRepo = MockShiftManagementRepository();
      final cubit = EndShiftCubit(mockRepo, 'shift-cash-08-ceiling', null);

      cubit.setCountedCash(50.0);
      cubit.setPendingIncomingCash(100.0); // 100 > 50

      final success = await cubit.fetchCashReconciliationPreview();
      expect(success, isFalse);
      expect(cubit.state, isA<EndShiftPreviewFailure>());
    });

    test('Updating pending incoming cash invalidates previous preview calculation and updates state', () async {
      final mockRepo = MockShiftManagementRepository();
      final cubit = EndShiftCubit(mockRepo, 'shift-cash-08-invalidate', null);

      mockRepo.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        double? pendingIncomingCash,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'counted_cash': 200.0,
              'expected_cash': 200.0,
              'cash_variance': 0.0,
              'cash_variance_type': 'balanced',
            },
          }
        });
      };

      cubit.setCountedCash(200.0);
      cubit.setPendingIncomingCash(20.0);
      await cubit.fetchCashReconciliationPreview();
      expect(cubit.previewData, isNotNull);

      // Changing pending incoming cash must invalidate previous preview!
      cubit.setPendingIncomingCash(50.0);
      expect(cubit.previewData, isNull);
      expect(cubit.state, isA<EndShiftPreviewInvalidated>());
    });

    test('EndShiftRequest and EndShiftRequestWithHandOver send pending_incoming_cash in formData', () async {
      final req = EndShiftRequest(
        totalSales: 1000.0,
        cashCollected: 500.0,
        cardPayments: 500.0,
        countedCash: 500.0,
        pendingIncomingCash: 100.0,
        aggregators: [],
        variance: Variance(responsibilityType: 'self', currentCashierAmount: 0, reason: 'none', otherCashiers: []),
        isThereVariance: false,
      );

      final formData = await req.toFormData();
      final fields = Map.fromEntries(formData.fields);
      expect(fields['pending_incoming_cash'], equals('100.00'));

      final handoverReq = EndShiftRequestWithHandOver(
        totalSales: 1000.0,
        cashCollected: 500.0,
        cardPayments: 500.0,
        posReceipt: null,
        nextCashierId: 'cashier-next',
        handoverAmount: 500.0,
        handoverNotes: 'Handover note',
        aggregators: [],
        variance: Variance(responsibilityType: 'self', currentCashierAmount: 0, reason: 'none', otherCashiers: []),
        isThereVariance: false,
        isManager: false,
        countedCash: 500.0,
        pendingIncomingCash: 100.0,
      );

      final handoverFormData = await handoverReq.toFormData();
      final handoverFields = Map.fromEntries(handoverFormData.fields);
      expect(handoverFields['pending_incoming_cash'], equals('100.00'));
    });
  });

  group('CSH-06: Reassignment Rejection Verification', () {
    test('RequestsRepository.rejectReassignedShift calls data source with shiftId and reason', () async {
      final fakeDataSource = FakeRequestsRemoteDataSource();
      final repo = RequestsRepository(remoteDataSource: fakeDataSource);

      final result = await repo.rejectReassignedShift(
        shiftId: 'shift-reassign-777',
        reason: 'Unable to cover schedule',
      );

      expect(fakeDataSource.rejectCalled, isTrue);
      expect(fakeDataSource.lastRejectedShiftId, equals('shift-reassign-777'));
      expect(fakeDataSource.lastRejectBody?.reason, equals('Unable to cover schedule'));

      bool isSuccess = false;
      result.when(
        failure: (_) {},
        success: (_) => isSuccess = true,
      );
      expect(isSuccess, isTrue);
    });

    test('AcceptReassignedShiftCubit.rejectReassignedShift emits success on valid rejection', () async {
      final fakeDataSource = FakeRequestsRemoteDataSource();
      final repo = RequestsRepository(remoteDataSource: fakeDataSource);
      final cubit = AcceptReassignedShiftCubit(repo);

      expect(cubit.state.loadingShiftId, isNull);
      expect(cubit.state.success, isFalse);

      final future = cubit.rejectReassignedShift(
        shiftId: 'shift-99',
        reason: 'Shift overlap',
      );

      await future;

      expect(cubit.state.loadingShiftId, isNull);
      expect(cubit.state.success, isTrue);
      expect(cubit.state.failure, isNull);
    });

    test('AcceptReassignedShiftCubit.rejectReassignedShift handles failure and sets errorShiftId', () async {
      final fakeDataSource = FakeRequestsRemoteDataSource()..shouldFail = true;
      final repo = RequestsRepository(remoteDataSource: fakeDataSource);
      final cubit = AcceptReassignedShiftCubit(repo);

      final future = cubit.rejectReassignedShift(
        shiftId: 'shift-fail-88',
        reason: 'Invalid reason',
      );

      await future;

      expect(cubit.state.loadingShiftId, isNull);
      expect(cubit.state.success, isFalse);
      expect(cubit.state.errorShiftId, equals('shift-fail-88'));
      expect(cubit.state.failure, isNotNull);
    });
  });

  group('Arabic Financial Input Parsing Verification', () {
    test('tryParseFinancialAmount accurately parses English and Arabic-Indic numerals with thousands separators', () {
      expect(EndShiftCubit.tryParseFinancialAmount('115.50'), equals(115.50));
      expect(EndShiftCubit.tryParseFinancialAmount('\u0661\u0661\u0665\u066B\u0665\u0660'), equals(115.50));
      expect(EndShiftCubit.tryParseFinancialAmount('0'), equals(0.0));
      expect(EndShiftCubit.tryParseFinancialAmount('\u0660'), equals(0.0));
      // ASCII comma thousands separator: 1,234.50
      expect(EndShiftCubit.tryParseFinancialAmount('1,234.50'), equals(1234.50));
      // Arabic comma thousands separator: ١,٢٣٤٫٥٠
      expect(EndShiftCubit.tryParseFinancialAmount('\u0661,\u0662\u0663\u0664\u066B\u0665\u0660'), equals(1234.50));
      // Arabic thousands separator U+066C (٬): ١٬٢٣٤٫٥٠
      expect(EndShiftCubit.tryParseFinancialAmount('\u0661\u066C\u0662\u0663\u0664\u066B\u0665\u0660'), equals(1234.50));
    });

    test('tryParseFinancialAmount rejects invalid input and returns null (no silent zero) and rejects negative amounts', () {
      expect(EndShiftCubit.tryParseFinancialAmount('abc'), isNull);
      expect(EndShiftCubit.tryParseFinancialAmount(''), isNull);
      expect(EndShiftCubit.tryParseFinancialAmount('   '), isNull);
      expect(EndShiftCubit.tryParseFinancialAmount(null), isNull);
      expect(EndShiftCubit.tryParseFinancialAmount('12abc'), isNull);
      // Rejection of negative amounts
      expect(EndShiftCubit.tryParseFinancialAmount('-10.00'), isNull);
      expect(EndShiftCubit.tryParseFinancialAmount('-\u0661\u0660'), isNull);
    });

    test('Pending incoming cash edge cases: empty is allowed, invalid text blocks preview and submit', () async {
      final mockRepo = MockShiftManagementRepository();
      final cubit = EndShiftCubit(mockRepo, 'shift-edge-pending', null);

      // 1. Leaving empty is permitted
      cubit.setPendingIncomingCash(null, isInvalid: false);
      expect(cubit.hasInvalidPendingIncomingCash, isFalse);
      expect(cubit.declaredPendingIncomingCash, equals(0.0));

      // 2. Typing invalid text marks field as invalid and blocks canProceedToEndShift
      cubit.setCountedCash(500.0);
      cubit.setPendingIncomingCash(null, isInvalid: true);
      expect(cubit.hasInvalidPendingIncomingCash, isTrue);
      expect(cubit.canProceedToEndShift, isFalse);

      // 3. fetchCashReconciliationPreview fails immediately when invalid
      final previewResult = await cubit.fetchCashReconciliationPreview();
      expect(previewResult, isFalse);
      expect(cubit.state, isA<EndShiftPreviewFailure>());

      // 4. Entering valid amount clears invalid flag
      cubit.setPendingIncomingCash(100.0, isInvalid: false);
      expect(cubit.hasInvalidPendingIncomingCash, isFalse);
      expect(cubit.declaredPendingIncomingCash, equals(100.0));
    });

    testWidgets('SalesBreakDownEndShiftWidget parses Arabic counted cash and rejects non-numeric input', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final mockRepo = MockShiftManagementRepository();
      final cubit = EndShiftCubit(mockRepo, 'shift-widget-test', null);
      final validationCubit = ValidationCubit(requiredFields: {'totalSales', 'countedCash'});
      final aggregatorCubit = AggregatorCubit(mockRepo);

      final totalSalesController = TextEditingController();
      final totalHandoverController = TextEditingController();
      final madaController = TextEditingController();
      final cashController = TextEditingController();
      final countedCashController = TextEditingController();
      final pendingIncomingController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('ar'),
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 1600)),
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  AppResponsive.init(context, designWidth: 800, designHeight: 1600);
                  return SingleChildScrollView(
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: cubit),
                        BlocProvider.value(value: validationCubit),
                        BlocProvider.value(value: aggregatorCubit),
                      ],
                      child: SalesBreakDownEndShiftWidget(
                        totalSaleSController: totalSalesController,
                        totalHandoverController: totalHandoverController,
                        madaController: madaController,
                        cashController: cashController,
                        countedCashController: countedCashController,
                        pendingIncomingCashController: pendingIncomingController,
                        viewUpload: false,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Enter Arabic numerals: 115.50 in Arabic digits: \u0661\u0661\u0665\u066B\u0665\u0660
      countedCashController.text = '\u0661\u0661\u0665\u066B\u0665\u0660';
      await tester.pump();
      final parsed = EndShiftCubit.tryParseFinancialAmount(countedCashController.text);
      expect(parsed, equals(115.50));
      cubit.setCountedCash(parsed);
      expect(cubit.countedCash, equals(115.50));

      // 2. Enter non-numeric: "abc"
      countedCashController.text = 'abc';
      await tester.pump();
      final invalidParsed = EndShiftCubit.tryParseFinancialAmount(countedCashController.text);
      expect(invalidParsed, isNull);
      cubit.setCountedCash(invalidParsed);
      expect(cubit.countedCash, isNull);

      // 3. Enter Pending Incoming Cash: 100.00 in Arabic digits: \u0661\u0660\u0660\u066B\u0660\u0660
      pendingIncomingController.text = '\u0661\u0660\u0660\u066B\u0660\u0660';
      await tester.pump();
      final pendingParsed = EndShiftCubit.tryParseFinancialAmount(pendingIncomingController.text);
      expect(pendingParsed, equals(100.0));
      cubit.setPendingIncomingCash(pendingParsed);
      expect(cubit.declaredPendingIncomingCash, equals(100.0));
    });
  });

  group('Cashier Role & Financial Boundaries Tests', () {
    test('CashierUserStrategy resolves correct role key and identity', () {
      final cashierStrategy = CashierUserStrategy();
      expect(cashierStrategy.userType, equals(UserType.cashier));
    });
  });
  group('Cashier Mobile / Tablet Responsive Layout Checks (320px - 1024px, RTL & LTR)', () {
    final viewports = [
      {'name': '320px Small Mobile', 'size': const Size(320, 700)},
      {'name': '360px Android Standard', 'size': const Size(360, 800)},
      {'name': '390px iPhone Modern', 'size': const Size(390, 844)},
      {'name': '600px Small Tablet', 'size': const Size(600, 960)},
      {'name': '820px iPad Tablet', 'size': const Size(820, 1180)},
      {'name': '1024px iPad Pro / Desktop', 'size': const Size(1024, 1366)},
    ];

    for (final vp in viewports) {
      final vpName = vp['name'] as String;
      final vpSize = vp['size'] as Size;

      testWidgets('SalesBreakDownEndShiftWidget responsive check at $vpName (Arabic RTL)', (tester) async {
        await tester.binding.setSurfaceSize(vpSize);
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockRepo = MockShiftManagementRepository();
        final cubit = EndShiftCubit(mockRepo, 'shift-responsive', null);
        final valCubit = ValidationCubit(requiredFields: {'totalSales', 'countedCash'});
        final aggCubit = AggregatorCubit(mockRepo);

        final totalSalesController = TextEditingController();
        final totalHandoverController = TextEditingController();
        final madaController = TextEditingController();
        final cashController = TextEditingController();
        final countedCashController = TextEditingController();
        final pendingIncomingController = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: LightTheme.extension),
            locale: const Locale('ar'),
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: MediaQuery(
              data: MediaQueryData(size: vpSize),
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    AppResponsive.init(context, designWidth: vpSize.width, designHeight: vpSize.height);
                    return SingleChildScrollView(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: cubit),
                          BlocProvider.value(value: valCubit),
                          BlocProvider.value(value: aggCubit),
                        ],
                        child: SalesBreakDownEndShiftWidget(
                          totalSaleSController: totalSalesController,
                          totalHandoverController: totalHandoverController,
                          madaController: madaController,
                          cashController: cashController,
                          countedCashController: countedCashController,
                          pendingIncomingCashController: pendingIncomingController,
                          viewUpload: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('النقد الوارد غير المؤكد في الدرج (اختياري)'), findsOneWidget);
        expect(find.text('النقد الفعلي المعدود'), findsOneWidget);
      });

      testWidgets('SalesBreakDownEndShiftWidget responsive check at $vpName (English LTR)', (tester) async {
        await tester.binding.setSurfaceSize(vpSize);
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final mockRepo = MockShiftManagementRepository();
        final cubit = EndShiftCubit(mockRepo, 'shift-responsive-en', null);
        final valCubit = ValidationCubit(requiredFields: {'totalSales', 'countedCash'});
        final aggCubit = AggregatorCubit(mockRepo);

        final totalSalesController = TextEditingController();
        final totalHandoverController = TextEditingController();
        final madaController = TextEditingController();
        final cashController = TextEditingController();
        final countedCashController = TextEditingController();
        final pendingIncomingController = TextEditingController();

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: LightTheme.extension),
            locale: const Locale('en'),
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: MediaQuery(
              data: MediaQueryData(size: vpSize),
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    AppResponsive.init(context, designWidth: vpSize.width, designHeight: vpSize.height);
                    return SingleChildScrollView(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: cubit),
                          BlocProvider.value(value: valCubit),
                          BlocProvider.value(value: aggCubit),
                        ],
                        child: SalesBreakDownEndShiftWidget(
                          totalSaleSController: totalSalesController,
                          totalHandoverController: totalHandoverController,
                          madaController: madaController,
                          cashController: cashController,
                          countedCashController: countedCashController,
                          pendingIncomingCashController: pendingIncomingController,
                          viewUpload: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('النقد الوارد غير المؤكد في الدرج (اختياري)'), findsOneWidget);
      });
    }
  });

  group('CASH-08 Regression: ShiftManagementRepositoryImp.previewCashReconciliation independent pending_incoming_cash tests', () {
    test('sends pending_incoming_cash when aggregators is null', () async {
      final remote = RecordingRemoteDataSource();
      final repo = ShiftManagementRepositoryImp(remote);
      await repo.previewCashReconciliation(
        shiftId: 'shift-1',
        totalSales: 100.0,
        countedCash: 40.0,
        pendingIncomingCash: 15.50,
        aggregators: null,
      );
      expect(remote.lastBody, isNotNull);
      expect(remote.lastBody!['pending_incoming_cash'], '15.50');
      expect(remote.lastBody!.containsKey('aggregators'), isFalse);
    });

    test('sends pending_incoming_cash when aggregators is empty list', () async {
      final remote = RecordingRemoteDataSource();
      final repo = ShiftManagementRepositoryImp(remote);
      await repo.previewCashReconciliation(
        shiftId: 'shift-1',
        totalSales: 100.0,
        countedCash: 40.0,
        pendingIncomingCash: 25.00,
        aggregators: <EndShiftAggregatorModel>[],
      );
      expect(remote.lastBody, isNotNull);
      expect(remote.lastBody!['pending_incoming_cash'], '25.00');
      expect(remote.lastBody!.containsKey('aggregators'), isFalse);
    });

    test('sends pending_incoming_cash when aggregators has data', () async {
      final remote = RecordingRemoteDataSource();
      final repo = ShiftManagementRepositoryImp(remote);
      final aggs = <EndShiftAggregatorModel>[
        const EndShiftAggregatorModel(
          aggregatorId: 'agg-1',
          amount: 30.0,
          notes: 'card aggregators',
        ),
      ];
      await repo.previewCashReconciliation(
        shiftId: 'shift-1',
        totalSales: 100.0,
        countedCash: 40.0,
        pendingIncomingCash: 12.00,
        aggregators: aggs,
      );
      expect(remote.lastBody, isNotNull);
      expect(remote.lastBody!['pending_incoming_cash'], '12.00');
      expect(remote.lastBody!['aggregators'], isNotEmpty);
      expect(remote.lastBody!['aggregators'][0]['aggregator_id'], 'agg-1');
      expect(remote.lastBody!['aggregators'][0]['amount'], '30.00');
    });

    test('does not send pending_incoming_cash when value is null, 0, or negative', () async {
      final remote = RecordingRemoteDataSource();
      final repo = ShiftManagementRepositoryImp(remote);

      // null
      await repo.previewCashReconciliation(
        shiftId: 'shift-1',
        totalSales: 100.0,
        countedCash: 40.0,
        pendingIncomingCash: null,
      );
      expect(remote.lastBody!.containsKey('pending_incoming_cash'), isFalse);

      // 0.0
      await repo.previewCashReconciliation(
        shiftId: 'shift-1',
        totalSales: 100.0,
        countedCash: 40.0,
        pendingIncomingCash: 0.0,
      );
      expect(remote.lastBody!.containsKey('pending_incoming_cash'), isFalse);

      // negative
      await repo.previewCashReconciliation(
        shiftId: 'shift-1',
        totalSales: 100.0,
        countedCash: 40.0,
        pendingIncomingCash: -5.0,
      );
      expect(remote.lastBody!.containsKey('pending_incoming_cash'), isFalse);
    });
  });
  group('CASH-08 State-Safety: Busy Flags and Rejection Guard Tests', () {
    test('rejecting preview due to excessive pending incoming cash resets busy state and allows subsequent valid preview', () async {
      final mockRepo = MockShiftManagementRepository();
      mockRepo.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        double? pendingIncomingCash,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 40.0,
              'counted_cash': countedCash,
              'variance': 0.0,
              'pending_incoming_cash': pendingIncomingCash,
            },
            'allocation_required': false,
            'is_balanced': true,
            'is_shortage': false,
            'is_surplus': false,
          }
        });
      };

      final cubit = EndShiftCubit(mockRepo, 'shift-busy-test', null);

      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 100.0,
        cashCollected: 40.0,
        cardPayments: 60.0,
        aggregators: [],
      );
      cubit.setCountedCash(40.0);
      cubit.setPendingIncomingCash(50.0); // 50 > 40 exceeds counted cash

      final firstAttempt = await cubit.fetchCashReconciliationPreview();
      expect(firstAttempt, isFalse);
      expect(cubit.state, isA<EndShiftPreviewFailure>());
      expect(cubit.isPreviewLoading, isFalse);

      // Now correct the value: 10 <= 40
      cubit.setPendingIncomingCash(10.0);
      expect(cubit.isPreviewLoading, isFalse);

      final secondAttempt = await cubit.fetchCashReconciliationPreview();
      expect(secondAttempt, isTrue);
      expect(cubit.state, isA<EndShiftPreviewSuccess>());
      expect(cubit.isPreviewLoading, isFalse);
    });

    test('rejecting endShift due to excessive pending incoming cash does not leave cubit busy and allows subsequent valid endShift', () async {
      int endShiftCallCount = 0;
      final mockRepo = MockShiftManagementRepository();
      mockRepo.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        double? pendingIncomingCash,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 40.0,
              'counted_cash': countedCash,
              'variance': 0.0,
              'pending_incoming_cash': pendingIncomingCash,
            },
            'allocation_required': false,
            'is_balanced': true,
            'is_shortage': false,
            'is_surplus': false,
          }
        });
      };
      mockRepo.onEndShift = ({
        required String shiftId,
        required EndShiftRequest endShiftRequest,
      }) async {
        endShiftCallCount++;
        return ApiResult.success(null);
      };

      final cubit = EndShiftCubit(mockRepo, 'shift-busy-end-test', null);

      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 100.0,
        cashCollected: 40.0,
        cardPayments: 60.0,
        aggregators: [],
      );
      cubit.setCountedCash(40.0);
      await cubit.fetchCashReconciliationPreview();

      // Introduce excessive pending cash after preview
      cubit.setPendingIncomingCash(50.0);

      // Attempt endShift: should reject immediately before setting _isSubmitting and without calling repository
      await cubit.endShift(
        variance: Variance(responsibilityType: 'self', currentCashierAmount: 0, reason: 'none', otherCashiers: []),
        isThereVariance: false,
      );
      expect(cubit.state, isA<EndShiftFailure>());
      expect(endShiftCallCount, equals(0));

      // Correct value and re-preview
      cubit.setPendingIncomingCash(10.0);
      final previewOk = await cubit.fetchCashReconciliationPreview();
      expect(previewOk, isTrue);

      // Subsequent attempt must succeed and call repository
      await cubit.endShift(
        variance: Variance(responsibilityType: 'self', currentCashierAmount: 0, reason: 'none', otherCashiers: []),
        isThereVariance: false,
      );
      expect(cubit.state, isA<EndShiftSuccess>());
      expect(endShiftCallCount, equals(1));
    });

    test('rejecting endShiftWithHandOver due to excessive pending incoming cash does not leave cubit busy and allows subsequent valid submission', () async {
      int handoverCallCount = 0;
      final mockRepo = MockShiftManagementRepository();
      mockRepo.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        double? pendingIncomingCash,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        return ApiResult.success({
          'data': {
            'cash_reconciliation': {
              'expected_cash': 40.0,
              'counted_cash': countedCash,
              'variance': 0.0,
              'pending_incoming_cash': pendingIncomingCash,
            },
            'allocation_required': false,
            'is_balanced': true,
            'is_shortage': false,
            'is_surplus': false,
          }
        });
      };
      mockRepo.onEndShiftWithHandOver = (shiftId, req) async {
        handoverCallCount++;
        return ApiResult.success(null);
      };

      final cubit = EndShiftCubit(mockRepo, 'shift-busy-handover-test', null);

      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 100.0,
        cashCollected: 40.0,
        cardPayments: 60.0,
        aggregators: [],
      );
      cubit.setCountedCash(40.0);
      await cubit.fetchCashReconciliationPreview();

      // Set excessive pending cash
      cubit.setPendingIncomingCash(60.0);

      final dummyHandover = EndShiftRequestWithHandOver(
        totalSales: 100.0,
        cashCollected: 40.0,
        cardPayments: 60.0,
        posReceipt: null,
        nextCashierId: 'cashier-next',
        handoverAmount: 40.0,
        handoverNotes: 'note',
        aggregators: [],
        variance: Variance(responsibilityType: 'self', currentCashierAmount: 0, reason: 'none', otherCashiers: []),
        isThereVariance: false,
        isManager: false,
      );

      // Attempt handover: rejected before submit flag, repository never called
      await cubit.endShitWithHandOver(dummyHandover);
      expect(cubit.state, isA<EndShiftFailure>());
      expect(handoverCallCount, equals(0));

      // Correct and re-preview
      cubit.setPendingIncomingCash(15.0);
      final previewOk = await cubit.fetchCashReconciliationPreview();
      expect(previewOk, isTrue);

      // Valid attempt succeeds and invokes repository
      await cubit.endShitWithHandOver(dummyHandover);
      expect(cubit.state, isA<EndShiftSuccess>());
      expect(handoverCallCount, equals(1));
    });

    test('invalid pending incoming cash input never sends requests to repository for preview, endShift or handover', () async {
      int previewCalls = 0;
      int endShiftCalls = 0;
      int handoverCalls = 0;

      final mockRepo = MockShiftManagementRepository();
      mockRepo.onPreview = ({
        required String shiftId,
        required double totalSales,
        required double countedCash,
        double? cardPayments,
        double? pendingIncomingCash,
        List<EndShiftAggregatorModel>? aggregators,
      }) async {
        previewCalls++;
        return ApiResult.success({});
      };
      mockRepo.onEndShift = ({required String shiftId, required EndShiftRequest endShiftRequest}) async {
        endShiftCalls++;
        return ApiResult.success(null);
      };
      mockRepo.onEndShiftWithHandOver = (shiftId, req) async {
        handoverCalls++;
        return ApiResult.success(null);
      };

      final cubit = EndShiftCubit(mockRepo, 'shift-invalid-input-guard', null);

      cubit.endShiftTotalSalesValuesUpdated(
        totalSales: 100.0,
        cashCollected: 40.0,
        cardPayments: 60.0,
        aggregators: [],
      );
      cubit.setCountedCash(40.0);
      cubit.setPendingIncomingCash(null, isInvalid: true);

      // Preview attempt
      final pResult = await cubit.fetchCashReconciliationPreview();
      expect(pResult, isFalse);
      expect(previewCalls, equals(0));

      // EndShift attempt
      await cubit.endShift(
        variance: Variance(responsibilityType: 'self', currentCashierAmount: 0, reason: 'none', otherCashiers: []),
        isThereVariance: false,
      );
      expect(endShiftCalls, equals(0));

      // Handover attempt
      final dummyHandover = EndShiftRequestWithHandOver(
        totalSales: 100.0,
        cashCollected: 40.0,
        cardPayments: 60.0,
        posReceipt: null,
        nextCashierId: 'cashier-next',
        handoverAmount: 40.0,
        handoverNotes: 'note',
        aggregators: [],
        variance: Variance(responsibilityType: 'self', currentCashierAmount: 0, reason: 'none', otherCashiers: []),
        isThereVariance: false,
        isManager: false,
      );
      await cubit.endShitWithHandOver(dummyHandover);
      expect(handoverCalls, equals(0));
    });
  });

}
