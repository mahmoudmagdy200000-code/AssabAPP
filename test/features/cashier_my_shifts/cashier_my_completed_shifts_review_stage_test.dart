import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/shift_status/shift_handover_status.dart';
import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/features/cashier_home/data/models/cashier_info_response.dart';
import 'package:assab/features/cashier_home/data/repository/cashier_home_repository.dart';
import 'package:assab/features/cashier_home/presentation/cubit/get_cashier_info/get_cashier_info_cubit.dart';
import 'package:assab/features/cashier_home/presentation/screens/cashier_list_screen.dart';
import 'package:assab/features/cashier_home/presentation/widgets/cashier_grid_view_item.dart';
import 'package:assab/features/cashier_home/presentation/widgets/cashier_home_bottom_section.dart';
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
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/handover_option/end_shift_option_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/shift_details_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/end_shift_options_bottom_sheet.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/manager_approve_button_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/manager_reject_handover_button.dart';
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

  @override
  FutureApiResult approveHandover({
    required String shiftId,
    String? confirmedAmount,
    String? managerComment,
    String? transferAttemptId,
  }) async {
    return ApiResult.success(true);
  }

  @override
  FutureApiResult rejectHandover({
    required String shiftId,
    String? managerComment,
  }) async {
    return ApiResult.success(true);
  }
}

class MockCashierHomeRepository extends Fake implements CashierHomeRepository {
  FutureApiResult<CashierInfoResponse> Function()? onGetCashierInfo;

  @override
  FutureApiResult<CashierInfoResponse> getCashierInfo() async {
    if (onGetCashierInfo != null) {
      return onGetCashierInfo!();
    }
    return ApiResult.success(
      CashierInfoResponse(
        id: '10',
        name: 'Ali Cashier',
        email: 'ali@example.com',
        phone: '0501234567',
        image: null,
        role: 'كاشير',
        status: 'active',
        statusLabel: 'نشط',
        activity: 'نشط',
        shiftDetails: CashierInfoShiftDetails(
          id: 'shift_101',
          storeBranch: 'Branch 1',
          shiftName: 'Morning Shift',
          startTime: '2026-11-11T08:00:00',
          endTime: '2026-11-11T16:00:00',
          shiftDate: '2026-11-11',
          status: 'completed',
          statusLabel: 'قيد المراجعة',
          workdays: 'السبت - الخميس',
          handsOverTo: CashierInfoHandsOverTo(
            id: '20',
            role: 'مشرف الفرع',
            name: 'Manager Ahmed',
          ),
        ),
      ),
    );
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

Widget buildTestWidget(
  Widget child, {
  Locale locale = const Locale('ar'),
  Size? designSize,
  bool wrapInScaffold = true,
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
    onGenerateRoute: (settings) {
      if (settings.name == AppRouteName.endShiftScreen) {
        return MaterialPageRoute<bool>(
          settings: settings,
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(true);
              }
            });
            return const Scaffold(body: SizedBox());
          },
        );
      }
      return null;
    },
    home: Builder(
      builder: (context) {
        AppResponsive.init(
          context,
          designWidth: designSize?.width ?? 375,
          designHeight: designSize?.height ?? 812,
        );
        return wrapInScaffold
            ? Scaffold(body: SingleChildScrollView(child: child))
            : child;
      },
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
      'production action (EndShiftOptionsBottomSheet) triggers shift refresh from server, preserving canonical ID, "قيد المراجعة" for pending shift, distinct second shift, and updating Home upon return',
      (tester) async {
        tester.view.physicalSize = const Size(750, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        if (!getIt.isRegistered<EndShiftOptionCubit>()) {
          getIt.registerFactory<EndShiftOptionCubit>(() => EndShiftOptionCubit());
        }

        final repo = MockCashierMyShiftsRepo();
        final cubit = CashierMyShiftsCubit(repo);
        final homeRepo = MockCashierHomeRepository();
        final homeCubit = GetCashierInfoCubit(homeRepo);

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
            designSize: const Size(500, 1000),
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cubit),
                BlocProvider.value(value: homeCubit),
              ],
              child: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      AppButton(
                        key: const Key('open_end_shift_sheet_btn'),
                        text: 'إنهاء الوردية',
                        enabled: true,
                        onClick: () {
                          AppBottomSheet.showModal(
                            context,
                            isScrollControlled: true,
                            (sheetContext) => EndShiftOptionsBottomSheet(
                              shiftId: 'shift_101',
                              hasEnded: true,
                              isCashierUserType: true,
                              onSuccessEndedOrReassigned: () {
                                context
                                    .read<CashierMyShiftsCubit>()
                                    .getInProgressShifts();
                                context
                                    .read<CashierMyShiftsCubit>()
                                    .getCompletedShifts();
                              },
                            ),
                          );
                        },
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

        // Step 1: Trigger the end shift flow from the production bottom sheet
        await tester.tap(find.byKey(const Key('open_end_shift_sheet_btn')));
        await tester.pumpAndSettle();

        // Bottom sheet is now open: select "إنهاء الوردية فقط" (withoutHandover)
        final endShiftOnlyOption = find.text(S.current.endShiftOnly).first;
        expect(endShiftOnlyOption, findsOneWidget);
        await tester.tap(endShiftOnlyOption);
        await tester.pumpAndSettle();

        // Tap proceed button inside EndShiftOptionsBottomSheet
        final proceedBtn =
            find.widgetWithText(AppButton, S.current.endShiftOnly);
        expect(proceedBtn, findsOneWidget);
        await tester.tap(proceedBtn);
        // Advance navigation route + the 1500ms delay in EndShiftOptionsBottomSheet
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1600));
        await tester.pumpAndSettle();

        // Shift 101 must render "قيد المراجعة" and NEVER "مكتملة"
        // Shift 102 must render "مكتملة" and NEVER "قيد المراجعة"
        expect(find.text('قيد المراجعة'), findsOneWidget);
        expect(find.text('مكتملة'), findsOneWidget);

        // Step 2: Simulate manager acceptance on server
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

        // Re-trigger from production action flow
        await tester.tap(find.byKey(const Key('open_end_shift_sheet_btn')));
        await tester.pumpAndSettle();
        await tester.tap(find.text(S.current.endShiftOnly).first);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(AppButton, S.current.endShiftOnly));
        await tester.pump();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1600));
        await tester.pumpAndSettle();

        // Both shift_101 and shift_102 now render "مكتملة"
        expect(find.text('مكتملة'), findsNWidgets(2));
        expect(find.text('قيد المراجعة'), findsNothing);

        // Step 3: Return to Home / open CashierListScreen from Home
        await homeCubit.getCashierInfo();
        await tester.pumpWidget(
          buildTestWidget(
            wrapInScaffold: false,
            designSize: const Size(500, 1000),
            MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cubit),
                BlocProvider<PagingCubit>(create: (_) => PagingCubit(totalSteps: 2)),
                BlocProvider<GetCashierInfoCubit>.value(
                  value: homeCubit,
                ),
              ],
              child: const CashierListScreen(),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Verify canonical shift_101 is reflected in Home screen
        expect(find.textContaining('Morning Shift'), findsOneWidget);
        expect(find.text('Branch 1'), findsOneWidget);
        expect(find.text('Ali Cashier'), findsOneWidget);

        await cubit.close();
        await homeCubit.close();
      },
    );

    testWidgets(
      'production action widgets (ManagerApproveButtonWidget & ManagerRejectHandoverButton) trigger ShiftDetailsCubit refresh from server upon receipt decision and rejection',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final repo = MockShiftDetailsRepo();
        if (!getIt.isRegistered<ShiftManagementRepositoryImp>()) {
          getIt.registerSingleton<ShiftManagementRepositoryImp>(repo);
        }
        if (!getIt.isRegistered<ApproveAndRejectHandoverCubit>()) {
          getIt.registerFactory<ApproveAndRejectHandoverCubit>(
            () => ApproveAndRejectHandoverCubit(repo),
          );
        }

        final cubit = ShiftDetailsCubit(repo, 'shift_101', true);
        UserTypeService.setUserType(
          strategy: BranchManagerUserStrategy(),
          userType: UserType.branchManager,
        );

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

        // Initial load
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

        // Mount production ManagerRejectHandoverButton
        await tester.pumpWidget(
          buildTestWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider<ShiftDetailsCubit>.value(value: cubit),
                BlocProvider<ApproveAndRejectHandoverCubit>(
                  create: (_) => getIt<ApproveAndRejectHandoverCubit>(),
                ),
              ],
              child: Builder(
                builder: (context) {
                  return ManagerRejectHandoverButton(
                    shiftId: 'shift_101',
                    openedFromModalSheet: true,
                    successFunction: () {
                      context.read<ShiftDetailsCubit>().getShiftDetails();
                    },
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Click production reject button
        await tester.tap(find.byType(ManagerRejectHandoverButton));
        await tester.pumpAndSettle();

        // Enter rejection comment into the modal sheet
        final commentField = find.byType(TextField);
        expect(commentField, findsOneWidget);
        await tester.enterText(commentField, 'Please adjust card receipts');
        await tester.pumpAndSettle();

        // Tap submit reject button inside RejectHandoverModalSheetWidget
        final submitRejectBtn =
            find.widgetWithText(AppButton, S.current.rejectAndAskForCorrection);
        await tester.tap(submitRejectBtn);
        await tester.pumpAndSettle();

        // Verify successFunction was invoked and ShiftDetailsCubit refreshed from server
        expect(cubit.state, isA<ShiftDetailsLoaded>());
        loaded = (cubit.state as ShiftDetailsLoaded).shift;
        expect(loaded.id, 'shift_101');
        expect(loaded.handoverStatus?.status, HandoverStatus.rejected);
        expect(loaded.handoverStatus?.reviewedBy, 'Manager Ahmed');

        // Dismiss any confirmation modal sheet if present
        while (NavigationService.I.canPop()) {
          NavigationService.I.pop();
          await tester.pumpAndSettle();
        }

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

        // Mount production ManagerApproveButtonWidget
        await tester.pumpWidget(
          buildTestWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider<ShiftDetailsCubit>.value(value: cubit),
                BlocProvider<ApproveAndRejectHandoverCubit>(
                  create: (_) => getIt<ApproveAndRejectHandoverCubit>(),
                ),
              ],
              child: Builder(
                builder: (context) {
                  return ManagerApproveButtonWidget(
                    cashierShiftId: 'shift_101',
                    cashierName: 'Ali Cashier',
                    managerName: 'Manager Ahmed',
                    cashGiven: 100.0,
                    variance: 0.0,
                    openedFromModalSheet: true,
                    successFunction: () {
                      context.read<ShiftDetailsCubit>().getShiftDetails();
                    },
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Click production approve button
        await tester.tap(find.byType(ManagerApproveButtonWidget));
        await tester.pumpAndSettle();

        // Enter confirmed amount equal to cashGiven (100)
        final amountField = find.byType(TextField).first;
        await tester.enterText(amountField, '100');
        await tester.pumpAndSettle();

        // Tap confirm receipt button inside AcceptHandoverSheetWidget
        final submitApproveBtn =
            find.widgetWithText(AppButton, S.current.approveHandover);
        await tester.tap(submitApproveBtn);
        await tester.pumpAndSettle();

        // Verify successFunction was invoked and ShiftDetailsCubit refreshed from server
        expect(cubit.state, isA<ShiftDetailsLoaded>());
        loaded = (cubit.state as ShiftDetailsLoaded).shift;
        expect(loaded.id, 'shift_101');
        expect(loaded.handoverStatus?.status, HandoverStatus.accepted);
        expect(loaded.handoverStatus?.reviewedBy, 'Manager Ahmed');

        await cubit.close();
      },
    );

    testWidgets(
      'reopening cashier list from CashierHomeBottomSection requests getCashierInfo() and displays updated canonical shift info for same shift',
      (tester) async {
        tester.view.physicalSize = const Size(500, 1000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final homeRepo = MockCashierHomeRepository();
        int getCashierInfoCallCount = 0;

        // Initial shift state on server for shift_101
        homeRepo.onGetCashierInfo = () async {
          getCashierInfoCallCount++;
          return ApiResult.success(
            CashierInfoResponse(
              id: '10',
              name: 'Ali Cashier',
              email: 'ali@example.com',
              phone: '0501234567',
              image: null,
              role: 'كاشير',
              status: 'active',
              statusLabel: 'نشط',
              activity: 'نشط',
              shiftDetails: CashierInfoShiftDetails(
                id: 'shift_101',
                storeBranch: 'Branch Initial 101',
                shiftName: 'Morning Initial Shift',
                startTime: '2026-11-11T08:00:00',
                endTime: '2026-11-11T16:00:00',
                shiftDate: '2026-11-11',
                status: 'in_progress',
                statusLabel: 'قيد المراجعة',
                workdays: 'السبت - الخميس',
                handsOverTo: CashierInfoHandsOverTo(
                  id: '20',
                  role: 'مشرف الفرع',
                  name: 'Manager Ahmed',
                ),
              ),
            ),
          );
        };

        if (getIt.isRegistered<GetCashierInfoCubit>()) {
          getIt.unregister<GetCashierInfoCubit>();
        }
        getIt.registerFactory<GetCashierInfoCubit>(
          () => GetCashierInfoCubit(homeRepo),
        );
        addTearDown(() {
          if (getIt.isRegistered<GetCashierInfoCubit>()) {
            getIt.unregister<GetCashierInfoCubit>();
          }
        });

        // 1. Mount CashierHomeBottomSection with PagingCubit
        await tester.pumpWidget(
          buildTestWidget(
            wrapInScaffold: true,
            designSize: const Size(500, 1000),
            BlocProvider<PagingCubit>(
              create: (_) => PagingCubit(totalSteps: 2),
              child: const CashierHomeBottomSection(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 2. Initial state: verify zero calls before clicking entry point
        expect(getCashierInfoCallCount, 0);

        // 3. Open CashierListScreen via production entry point
        await tester.tap(
          find.widgetWithText(CashierGridViewItem, S.current.cashiersList),
        );
        await tester.pumpAndSettle();

        // 4. Verify the application requested data on open
        expect(getCashierInfoCallCount, 1);
        expect(find.byType(CashierListScreen), findsOneWidget);
        expect(find.text('Branch Initial 101'), findsOneWidget);
        expect(find.textContaining('Morning Initial Shift'), findsOneWidget);
        expect(find.text('Ali Cashier'), findsOneWidget);

        // 5. Pop / return to Home (CashierHomeBottomSection)
        final backBtn = find.byType(AppBackButton);
        expect(backBtn, findsOneWidget);
        await tester.tap(backBtn);
        await tester.pumpAndSettle();

        expect(find.byType(CashierListScreen), findsNothing);
        expect(find.byType(CashierHomeBottomSection), findsOneWidget);

        // 6. Mutate shift state on server for the SAME canonical shift (shift_101)
        homeRepo.onGetCashierInfo = () async {
          getCashierInfoCallCount++;
          return ApiResult.success(
            CashierInfoResponse(
              id: '10',
              name: 'Ali Cashier',
              email: 'ali@example.com',
              phone: '0501234567',
              image: null,
              role: 'كاشير',
              status: 'active',
              statusLabel: 'نشط',
              activity: 'مكتمل',
              shiftDetails: CashierInfoShiftDetails(
                id: 'shift_101', // Canonical ID preserved
                storeBranch: 'Branch Updated 101', // Updated distinctive value
                shiftName: 'Morning Updated Shift', // Updated distinctive value
                startTime: '2026-11-11T08:00:00',
                endTime: '2026-11-11T16:00:00',
                shiftDate: '2026-11-11',
                status: 'completed',
                statusLabel: 'مكتملة',
                workdays: 'السبت - الخميس',
                handsOverTo: CashierInfoHandsOverTo(
                  id: '20',
                  role: 'مشرف الفرع',
                  name: 'Manager Ahmed',
                ),
              ),
            ),
          );
        };

        // 7. Re-open Cashier List via production entry point
        await tester.tap(
          find.widgetWithText(CashierGridViewItem, S.current.cashiersList),
        );
        await tester.pumpAndSettle();

        // 8. Verify the application itself invoked getCashierInfo() on re-open
        expect(getCashierInfoCallCount, 2);

        // 9. Verify CashierListScreen renders the updated values for same shift_101
        expect(find.byType(CashierListScreen), findsOneWidget);
        expect(find.text('Branch Updated 101'), findsOneWidget);
        expect(find.textContaining('Morning Updated Shift'), findsOneWidget);
        expect(find.text('Branch Initial 101'), findsNothing);
        expect(find.textContaining('Morning Initial Shift'), findsNothing);
      },
    );
  });
}
