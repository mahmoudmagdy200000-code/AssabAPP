import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/completed/cashier_completed_shifts_response_model.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/in_progress/cashier_in_progress_shifts_data_model.dart';
import 'package:assab/features/cashier_my_shifts/data/model/shifts_models/in_progress/cashier_in_progress_shifts_response_model.dart';
import 'package:assab/features/cashier_my_shifts/data/repository/cashier_my_shifts_repo.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_handover_status_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_reassign_user_type_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/cashier_my_shifts_handover_status.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:assab/features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_cubit.dart';
import 'package:assab/features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_state.dart';
import 'package:assab/features/cashier_my_shifts/presentation/strategies/cashier_my_shifts_cards_strategy/cashier_shifts_status_strategies/cashier_my_completed_shifts_strategy.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/shift_details_cubit.dart';
import 'package:assab/generated/l10n.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCashierMyShiftsRepo implements CashierMyShiftsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  Future<ApiResult<CashierCompletedShiftsResponseModel>> Function({int? page})?
      onGetCompletedShifts;

  @override
  Future<ApiResult<CashierCompletedShiftsResponseModel>> getCashierMyCompletedShifts({
    int? page,
  }) async {
    if (onGetCompletedShifts != null) {
      return onGetCompletedShifts!(page: page);
    }
    return ApiResult.success(
      CashierCompletedShiftsResponseModel(
        success: true,
        message: 'Success',
        data: [],
        meta: MetaModel(
          currentPage: 1,
          lastPage: 1,
          total: 0,
        ),
      ),
    );
  }

  @override
  Future<ApiResult<CashierInProgressShiftsResponseModel>> getCashierMyInProgressShifts({
    int? page,
  }) async {
    return ApiResult.success(
      const CashierInProgressShiftsResponseModel(
        success: true,
        message: 'Success',
        data: CashierInProgressShiftsDataModel(
          shifts: [],
          count: 0,
        ),
      ),
    );
  }
}

class FakeShiftRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockShiftDetailsRepo extends ShiftManagementRepositoryImp {
  MockShiftDetailsRepo() : super(FakeShiftRemoteDataSource());

  Future<ApiResult<ShiftEntity>> Function(String shiftId)? onGetShiftDetails;

  @override
  Future<ApiResult<ShiftEntity>> getShiftDetails(String shiftId) async {
    if (onGetShiftDetails != null) {
      return onGetShiftDetails!(shiftId);
    }
    return super.getShiftDetails(shiftId);
  }
}

class FakeDetailsShiftEntity extends Fake implements ShiftEntity {
  @override
  final String id;
  @override
  final ShiftStatusType status;
  @override
  final HandoverStatusEntity? handoverStatus;

  FakeDetailsShiftEntity({
    required this.id,
    required this.status,
    this.handoverStatus,
  });
}

Widget buildTestWidget(Widget child, {Locale locale = const Locale('ar')}) {
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
          return SingleChildScrollView(child: child);
        },
      ),
    ),
  );
}

void main() {
  group('MT-25: Shift State Refresh & Review Stage Preservation', () {
    testWidgets(
      'shift with pending handover status renders review stage label ("قيد المراجعة") and not "مكتملة"',
      (tester) async {
        final reviewShift = CashierShiftEntity(
          id: 'shift_101',
          date: DateTime(2026, 11, 11),
          status: MyShiftStatusType.completed,
          startTime: '08:00',
          endTime: '16:00',
          handoverStatus: const CashierHandoverStatusEntity(
            status: CashierMyShiftsHandoverStatus.pending,
            reviewedBy: null,
          ),
        );

        final strategy = CashierMyCompletedShiftsStrategy();
        final card = strategy.buildCard(reviewShift);

        await tester.pumpWidget(buildTestWidget(card, locale: const Locale('ar')));
        await tester.pumpAndSettle();

        // Must display pending review label, NEVER "مكتملة"
        expect(find.text('قيد المراجعة'), findsOneWidget);
        expect(find.text('مكتملة'), findsNothing);
      },
    );

    testWidgets(
      'shift with accepted handover status renders "مكتملة"',
      (tester) async {
        final acceptedShift = CashierShiftEntity(
          id: 'shift_102',
          date: DateTime(2026, 11, 11),
          status: MyShiftStatusType.completed,
          startTime: '08:00',
          endTime: '16:00',
          handoverStatus: const CashierHandoverStatusEntity(
            status: CashierMyShiftsHandoverStatus.accepted,
            reviewedBy: 'Manager Ahmed',
          ),
        );

        final strategy = CashierMyCompletedShiftsStrategy();
        final card = strategy.buildCard(acceptedShift);

        await tester.pumpWidget(buildTestWidget(card, locale: const Locale('ar')));
        await tester.pumpAndSettle();

        expect(find.text('مكتملة'), findsOneWidget);
        expect(find.text('قيد المراجعة'), findsNothing);
      },
    );

    testWidgets(
      'shift with designated recipient (handoverTo != null) and pending handover renders "قيد المراجعة" (not "مكتملة")',
      (tester) async {
        final pendingShiftWithRecipient = CashierShiftEntity(
          id: 'shift_103',
          date: DateTime(2026, 11, 11),
          status: MyShiftStatusType.completed,
          startTime: '08:00',
          endTime: '16:00',
          closingBalance: 300,
          variance: 0,
          handoverTo: const CashierUserObjectEntity(
            id: 'usr_20',
            name: 'سالم الكاشير المستلم',
          ),
          handoverStatus: const CashierHandoverStatusEntity(
            status: CashierMyShiftsHandoverStatus.pending,
            reviewedBy: null,
          ),
        );

        final strategy = CashierMyCompletedShiftsStrategy();
        final card = strategy.buildCard(pendingShiftWithRecipient);

        await tester.pumpWidget(buildTestWidget(card, locale: const Locale('ar')));
        await tester.pumpAndSettle();

        // Must display pending review label, NEVER "مكتملة" even when handoverTo is set
        expect(find.text('قيد المراجعة'), findsOneWidget);
        expect(find.text('مكتملة'), findsNothing);
        expect(find.text('سالم الكاشير المستلم'), findsOneWidget);
      },
    );

    testWidgets(
      'shift with designated recipient (handoverTo != null) and accepted handover renders "مكتملة"',
      (tester) async {
        final acceptedShiftWithRecipient = CashierShiftEntity(
          id: 'shift_104',
          date: DateTime(2026, 11, 11),
          status: MyShiftStatusType.completed,
          startTime: '08:00',
          endTime: '16:00',
          closingBalance: 300,
          variance: 0,
          handoverTo: const CashierUserObjectEntity(
            id: 'usr_20',
            name: 'سالم الكاشير المستلم',
          ),
          handoverStatus: const CashierHandoverStatusEntity(
            status: CashierMyShiftsHandoverStatus.accepted,
            reviewedBy: 'المدير أحمد',
          ),
        );

        final strategy = CashierMyCompletedShiftsStrategy();
        final card = strategy.buildCard(acceptedShiftWithRecipient);

        await tester.pumpWidget(buildTestWidget(card, locale: const Locale('ar')));
        await tester.pumpAndSettle();

        expect(find.text('مكتملة'), findsOneWidget);
        expect(find.text('قيد المراجعة'), findsNothing);
        expect(find.text('سالم الكاشير المستلم'), findsOneWidget);
      },
    );

    testWidgets(
      'production action callback (onSuccessEndedOrReassigned) triggers shift refresh from server, preserving canonical ID, "قيد المراجعة" for pending shift, and distinct second shift',
      (tester) async {
        final repo = MockCashierMyShiftsRepo();
        final cubit = CashierMyShiftsCubit(repo);

        repo.onGetCompletedShifts = ({int? page}) async {
          return ApiResult.success(
            CashierCompletedShiftsResponseModel.fromJson({
              'success': true,
              'message': 'Success',
              'data': [
                {
                  'id': 'shift_101',
                  'shift_date': '2026-11-11',
                  'shift_name': 'Morning Shift',
                  'start_time': '08:00',
                  'end_time': '16:00',
                  'status': 'completed',
                  'closing_balance': 100,
                  'total_sales': 500,
                  'variance': 0,
                  'variance_type': 'none',
                  'handover_status': {
                    'status': 'pending',
                    'reviewed_by': null,
                  },
                  'branch_name': 'Branch 1',
                  'branch_id': 'b_1',
                },
                {
                  'id': 'shift_102',
                  'shift_date': '2026-11-10',
                  'shift_name': 'Evening Shift',
                  'start_time': '16:00',
                  'end_time': '00:00',
                  'status': 'completed',
                  'closing_balance': 200,
                  'total_sales': 800,
                  'variance': 0,
                  'variance_type': 'none',
                  'handover_status': {
                    'status': 'accepted',
                    'reviewed_by': 'Manager Ahmed',
                  },
                  'branch_name': 'Branch 1',
                  'branch_id': 'b_1',
                },
              ],
              'meta': {
                'current_page': 1,
                'last_page': 1,
                'total': 2,
              },
            }),
          );
        };

        await tester.pumpWidget(
          buildTestWidget(
            BlocProvider.value(
              value: cubit,
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                        key: const Key('action_trigger_btn'),
                        onPressed: () {
                          // The exact production callback executed on action completion
                          // (e.g. EndShiftOptionsBottomSheet / CashierMyInProgressShiftsDefaultCard):
                          context.read<CashierMyShiftsCubit>().getInProgressShifts();
                          context.read<CashierMyShiftsCubit>().getCompletedShifts();
                        },
                        child: const Text('Trigger Action'),
                      ),
                      BlocBuilder<CashierMyShiftsCubit, CashierMyShiftsState>(
                        builder: (context, state) {
                          final strategy = CashierMyCompletedShiftsStrategy();
                          return Column(
                            children: state.completed.items
                                .map((shift) => strategy.buildCard(shift))
                                .toList(),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initially no cards rendered
        expect(find.text('قيد المراجعة'), findsNothing);
        expect(find.text('مكتملة'), findsNothing);

        // Step 1: Execute the production action callback
        await tester.tap(find.byKey(const Key('action_trigger_btn')));
        await tester.pumpAndSettle();

        // Shift 101 must render "قيد المراجعة" and NEVER "مكتملة"
        // Shift 102 must render "مكتملة" and NEVER "قيد المراجعة"
        expect(find.text('قيد المراجعة'), findsOneWidget);
        expect(find.text('مكتملة'), findsOneWidget);

        // Step 2: Simulate server receipt decision (manager accepts handover for shift_101)
        repo.onGetCompletedShifts = ({int? page}) async {
          return ApiResult.success(
            CashierCompletedShiftsResponseModel.fromJson({
              'success': true,
              'message': 'Success',
              'data': [
                {
                  'id': 'shift_101',
                  'shift_date': '2026-11-11',
                  'shift_name': 'Morning Shift',
                  'start_time': '08:00',
                  'end_time': '16:00',
                  'status': 'completed',
                  'closing_balance': 100,
                  'total_sales': 500,
                  'variance': 0,
                  'variance_type': 'none',
                  'handover_status': {
                    'status': 'accepted',
                    'reviewed_by': 'Branch Manager',
                  },
                  'branch_name': 'Branch 1',
                  'branch_id': 'b_1',
                },
                {
                  'id': 'shift_102',
                  'shift_date': '2026-11-10',
                  'shift_name': 'Evening Shift',
                  'start_time': '16:00',
                  'end_time': '00:00',
                  'status': 'completed',
                  'closing_balance': 200,
                  'total_sales': 800,
                  'variance': 0,
                  'variance_type': 'none',
                  'handover_status': {
                    'status': 'accepted',
                    'reviewed_by': 'Manager Ahmed',
                  },
                  'branch_name': 'Branch 1',
                  'branch_id': 'b_1',
                },
              ],
              'meta': {
                'current_page': 1,
                'last_page': 1,
                'total': 2,
              },
            }),
          );
        };

        // Trigger refresh on return / screen re-opening
        await tester.tap(find.byKey(const Key('action_trigger_btn')));
        await tester.pumpAndSettle();

        // Now both shift_101 and shift_102 render "مكتملة"
        expect(find.text('مكتملة'), findsNWidgets(2));
        expect(find.text('قيد المراجعة'), findsNothing);

        await cubit.close();
      },
    );

    test(
      'ShiftDetailsCubit getShiftDetails triggered by action callback refreshes canonical shift from server upon receipt decision and rejection',
      () async {
        final repo = MockShiftDetailsRepo();
        final cubit = ShiftDetailsCubit(repo, 'shift_101', true);

        // Initial state from server: pending handover
        repo.onGetShiftDetails = (shiftId) async {
          expect(shiftId, 'shift_101');
          return ApiResult.success(
            FakeDetailsShiftEntity(
              id: 'shift_101',
              status: ShiftStatusType.completed,
              handoverStatus: const HandoverStatusEntity(
                id: 'h_1',
                status: HandoverStatus.pending,
                reviewedBy: '',
              ),
            ),
          );
        };

        // Production path: successFunction() or screen load triggers getShiftDetails()
        await cubit.getShiftDetails();
        expect(cubit.state, isA<ShiftDetailsLoaded>());
        var loaded = (cubit.state as ShiftDetailsLoaded).shift;
        expect(loaded.id, 'shift_101');
        expect(loaded.handoverStatus?.status, HandoverStatus.pending);

        // Rejection / return decision from server:
        repo.onGetShiftDetails = (shiftId) async {
          expect(shiftId, 'shift_101');
          return ApiResult.success(
            FakeDetailsShiftEntity(
              id: 'shift_101',
              status: ShiftStatusType.completed,
              handoverStatus: const HandoverStatusEntity(
                id: 'h_1',
                status: HandoverStatus.rejected,
                reviewedBy: 'Manager Ahmed',
              ),
            ),
          );
        };

        // Triggered by ManagerRejectHandoverButton.successFunction
        await cubit.getShiftDetails();
        expect(cubit.state, isA<ShiftDetailsLoaded>());
        loaded = (cubit.state as ShiftDetailsLoaded).shift;
        expect(loaded.id, 'shift_101');
        expect(loaded.handoverStatus?.status, HandoverStatus.rejected);

        // Receipt decision approved by manager from server:
        repo.onGetShiftDetails = (shiftId) async {
          expect(shiftId, 'shift_101');
          return ApiResult.success(
            FakeDetailsShiftEntity(
              id: 'shift_101',
              status: ShiftStatusType.completed,
              handoverStatus: const HandoverStatusEntity(
                id: 'h_1',
                status: HandoverStatus.accepted,
                reviewedBy: 'Manager Ahmed',
              ),
            ),
          );
        };

        // Triggered by ManagerApproveButtonWidget.successFunction
        await cubit.getShiftDetails();
        expect(cubit.state, isA<ShiftDetailsLoaded>());
        loaded = (cubit.state as ShiftDetailsLoaded).shift;
        expect(loaded.id, 'shift_101');
        expect(loaded.handoverStatus?.status, HandoverStatus.accepted);
        expect(loaded.handoverStatus?.reviewedBy, 'Manager Ahmed');

        await cubit.close();
      },
    );
  });
}
