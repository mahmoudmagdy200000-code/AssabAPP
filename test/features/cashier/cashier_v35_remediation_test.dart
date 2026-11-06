import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/theme/app_theme.dart';
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

class FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
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
    List<EndShiftAggregatorModel>? aggregators,
  }) async {
    if (onPreview != null) {
      return onPreview!(
        shiftId: shiftId,
        totalSales: totalSales,
        countedCash: countedCash,
        cardPayments: cardPayments,
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

  group('Cashier Role & Financial Boundaries Tests', () {
    test('CashierUserStrategy resolves correct role key and identity', () {
      final cashierStrategy = CashierUserStrategy();
      expect(cashierStrategy.userType, equals(UserType.cashier));
    });
  });
}
