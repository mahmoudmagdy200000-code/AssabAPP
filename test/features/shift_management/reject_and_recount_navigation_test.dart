import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/accept_handover_sheet_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/handover_approve_body_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/reject_handover_widgets/reject_handover_modal_sheet_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _ConfigurableMockRemoteDataSource extends Fake
    implements ShiftManagementRemoteDataSource {
  int responseStatusCode = 200;
  String? lastRejectShiftId;
  HandoverApproveAndRejectBodyRequest? lastRejectBody;

  @override
  Future<dynamic> rejectHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  }) async {
    lastRejectShiftId = shiftId;
    lastRejectBody = handoverApproveAndRejectBodyRequest;

    if (responseStatusCode == 200) {
      return {'success': true};
    } else if (responseStatusCode == 409) {
      throw DioException(
        requestOptions: RequestOptions(path: 'shifts/$shiftId/handover/reject'),
        response: Response(
          requestOptions:
              RequestOptions(path: 'shifts/$shiftId/handover/reject'),
          statusCode: 409,
          data: {'message': 'HANDOVER_NOT_CORRECTABLE'},
        ),
        type: DioExceptionType.badResponse,
      );
    } else {
      throw DioException(
        requestOptions: RequestOptions(path: 'shifts/$shiftId/handover/reject'),
        type: DioExceptionType.receiveTimeout,
        message: 'Network connection timeout',
      );
    }
  }
}

Widget buildTestApp({
  required Widget child,
  required ApproveAndRejectHandoverCubit cubit,
}) {
  return AppResponsiveBuilder(
    designWidth: 375,
    designHeight: 833,
    builder: (context) {
      return MaterialApp(
        navigatorKey: NavigationService.I.navigatorKey,
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: BlocProvider<ApproveAndRejectHandoverCubit>.value(
            value: cubit,
            child: child,
          ),
        ),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('F-02: Reject & Request Recount Navigation & Hardening Tests', () {
    late _ConfigurableMockRemoteDataSource mockDataSource;
    late ShiftManagementRepositoryImp repository;
    late ApproveAndRejectHandoverCubit cubit;

    setUp(() {
      mockDataSource = _ConfigurableMockRemoteDataSource();
      repository = ShiftManagementRepositoryImp(mockDataSource);
      cubit = ApproveAndRejectHandoverCubit(repository);
      UserTypeService.selectedUserType = UserType.branchManager;

      if (getIt.isRegistered<ApproveAndRejectHandoverCubit>()) {
        getIt.unregister<ApproveAndRejectHandoverCubit>();
      }
      getIt.registerFactory<ApproveAndRejectHandoverCubit>(
        () => ApproveAndRejectHandoverCubit(repository),
      );
    });

    testWidgets(
        'Mismatch opens RejectHandoverModalSheetWidget with prefilled comment and fresh active cubit',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));

      await tester.pumpWidget(
        buildTestApp(
          cubit: cubit,
          child: Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () {
                AppBottomSheet.showModal(
                  context,
                  (sheetContext) => BlocProvider.value(
                    value: cubit,
                    child: AcceptHandoverSheetWidget(
                      shiftId: 'shift-recount-1',
                      cashGiven: '200.00',
                      variance: '0.00',
                      cashFrom: 'Cashier Khaled',
                      successFunction: () {},
                    ),
                  ),
                );
              },
              child: const Text('Open Sheet'),
            );
          }),
        ),
      );
      await tester.pumpAndSettle();

      // Tap to open AcceptHandoverSheetWidget
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();
      expect(find.byType(AcceptHandoverSheetWidget), findsOneWidget);

      // Enter mismatched amount: 180.00 vs expected 200.00
      final textFields = find.byType(CustomTextField);
      await tester.enterText(textFields.first, '180.00');
      await tester.pumpAndSettle();

      // CASH-09 warning and Reject & Request Recount button must be visible
      expect(find.text('Reject & Request Recount'), findsOneWidget);
      expect(
          find.textContaining('CASH-09: Receipt Amount Mismatch'), findsOneWidget);

      // Tap Reject & Request Recount
      await tester.tap(find.text('Reject & Request Recount'));
      await tester.pumpAndSettle();

      // RejectHandoverModalSheetWidget is now visible
      expect(find.byType(RejectHandoverModalSheetWidget), findsOneWidget);

      // Comment must be prefilled with CASH-09 mismatch details
      expect(
          find.textContaining(
              'CASH-09: Counted physical cash (180.00 SAR) does not match reported handover (200.00 SAR)'),
          findsOneWidget);

      // Parent screen button remains intact underneath
      expect(find.text('Open Sheet'), findsOneWidget);
    });

    testWidgets(
        'HTTP 200 rejection successfully calls API and presents success bottom sheet without popping parent',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      mockDataSource.responseStatusCode = 200;
      bool successCalled = false;

      await tester.pumpWidget(
        buildTestApp(
          cubit: cubit,
          child: Builder(builder: (context) {
            return Column(
              children: [
                const Text('Parent Workday Screen'),
                ElevatedButton(
                  onPressed: () {
                    AppBottomSheet.showModal(
                      context,
                      (sheetContext) => BlocProvider.value(
                        value: cubit,
                        child: RejectHandoverModalSheetWidget(
                          shiftId: 'shift-200',
                          successFunction: () {
                            successCalled = true;
                          },
                          openedFromModalSheet: false,
                          initialComment: 'CASH-09: Recounting required',
                        ),
                      ),
                    );
                  },
                  child: const Text('Open Reject Sheet'),
                ),
              ],
            );
          }),
        ),
      );
      await tester.pumpAndSettle();

      // Open reject sheet
      await tester.tap(find.text('Open Reject Sheet'));
      await tester.pumpAndSettle();

      expect(find.byType(RejectHandoverModalSheetWidget), findsOneWidget);

      // Tap Reject and Ask for Correction
      final rejectButton = find.widgetWithText(
          AppButton, S.current.rejectAndAskForCorrection);
      await tester.tap(rejectButton);
      await tester.pumpAndSettle();

      // Verify remote data source received correct call
      expect(mockDataSource.lastRejectShiftId, 'shift-200');
      expect(mockDataSource.lastRejectBody?.rejectionReason,
          'CASH-09: Recounting required');
      expect(successCalled, isTrue);

      // Parent screen must still be alive!
      expect(find.text('Parent Workday Screen'), findsOneWidget);
    });

    testWidgets(
        'HTTP 409 conflict gracefully presents error dialog without closing screen or crashing',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      mockDataSource.responseStatusCode = 409;

      await tester.pumpWidget(
        buildTestApp(
          cubit: cubit,
          child: RejectHandoverModalSheetWidget(
            shiftId: 'shift-409',
            successFunction: () {},
            openedFromModalSheet: false,
            initialComment: 'CASH-09: Recounting required',
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rejectButton = find.byType(AppButton);
      await tester.tap(rejectButton);
      await tester.pumpAndSettle();

      // Error dialog must be displayed with 409 message
      expect(find.textContaining('HANDOVER_NOT_CORRECTABLE'), findsOneWidget);

      // Modal sheet itself must remain visible
      expect(find.byType(RejectHandoverModalSheetWidget), findsOneWidget);
    });

    testWidgets(
        'Network error displays connection failure dialog and allows retry',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      mockDataSource.responseStatusCode = 504;

      await tester.pumpWidget(
        buildTestApp(
          cubit: cubit,
          child: RejectHandoverModalSheetWidget(
            shiftId: 'shift-504',
            successFunction: () {},
            openedFromModalSheet: false,
            initialComment: 'CASH-09: Recounting required',
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rejectButton = find.byType(AppButton);
      await tester.tap(rejectButton);
      await tester.pumpAndSettle();

      // Dialog is displayed
      expect(find.byType(AlertDialog), findsOneWidget);

      // Dismiss dialog by tapping OK
      await tester.tap(find.text(S.current.ok));
      await tester.pumpAndSettle();

      // Rejection sheet remains open and ready for user retry
      expect(find.byType(RejectHandoverModalSheetWidget), findsOneWidget);
    });
  });
}
