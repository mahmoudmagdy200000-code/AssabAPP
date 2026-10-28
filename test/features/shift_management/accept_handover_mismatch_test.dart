import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/accept_handover_sheet_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/handover_approve_body_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockShiftRemoteDataSource extends Fake implements ShiftManagementRemoteDataSource {
  String? lastApproveShiftId;
  HandoverApproveAndRejectBodyRequest? lastApproveBody;

  @override
  Future<dynamic> approveHandover({
    required String shiftId,
    HandoverApproveAndRejectBodyRequest? handoverApproveAndRejectBodyRequest,
  }) async {
    lastApproveShiftId = shiftId;
    lastApproveBody = handoverApproveAndRejectBodyRequest;
    return {'success': true};
  }
}

Widget buildTestWidget({
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
            child: SingleChildScrollView(child: child),
          ),
        ),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CASH-09: AcceptHandoverSheetWidget Amount Mismatch Protection Tests', () {
    late _MockShiftRemoteDataSource mockDataSource;
    late ShiftManagementRepositoryImp repository;
    late ApproveAndRejectHandoverCubit cubit;

    setUp(() {
      mockDataSource = _MockShiftRemoteDataSource();
      repository = ShiftManagementRepositoryImp(mockDataSource);
      cubit = ApproveAndRejectHandoverCubit(repository);
      UserTypeService.selectedUserType = UserType.branchManager;
    });

    testWidgets('Entering mismatched amount displays CASH-09 warning and disables confirm button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));

      await tester.pumpWidget(
        buildTestWidget(
          cubit: cubit,
          child: AcceptHandoverSheetWidget(
            shiftId: 'shift-test-1',
            cashGiven: '150.00',
            variance: '0.00',
            cashFrom: 'Cashier Ahmed',
            successFunction: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the confirmed amount text field
      final textFieldFinder = find.byType(CustomTextField).first;
      expect(textFieldFinder, findsOneWidget);

      // Initially empty -> Approve button disabled
      final approveButtonFinder = find.widgetWithText(AppButton, S.current.approveHandover);
      expect(approveButtonFinder, findsOneWidget);
      await tester.ensureVisible(approveButtonFinder);
      AppButton approveBtn = tester.widget<AppButton>(approveButtonFinder);
      expect(approveBtn.enabled, isFalse);

      // Enter mismatched amount: 120.00 vs expected 150.00
      await tester.enterText(textFieldFinder, '120.00');
      await tester.pumpAndSettle();

      // CASH-09 banner must be displayed
      expect(find.text('CASH-09: Receipt Amount Mismatch'), findsOneWidget);
      expect(find.textContaining('Under CASH-09, confirmation is blocked'), findsOneWidget);
      expect(find.text('Reject & Request Recount'), findsOneWidget);

      // Approve button must remain strictly disabled
      await tester.ensureVisible(approveButtonFinder);
      approveBtn = tester.widget<AppButton>(approveButtonFinder);
      expect(approveBtn.enabled, isFalse);

      // Tapping disabled button must not trigger cubit or API call
      await tester.tap(approveButtonFinder, warnIfMissed: false);
      await tester.pump();
      expect(mockDataSource.lastApproveShiftId, isNull);

      // Now enter the exact matching amount: 150.00
      await tester.enterText(textFieldFinder, '150.00');
      await tester.pumpAndSettle();

      // CASH-09 warning banner must disappear
      expect(find.text('CASH-09: Receipt Amount Mismatch'), findsNothing);

      // Approve button must now be enabled
      await tester.ensureVisible(approveButtonFinder);
      approveBtn = tester.widget<AppButton>(approveButtonFinder);
      expect(approveBtn.enabled, isTrue);

      // Tapping enabled approve button dispatches confirmation
      await tester.tap(approveButtonFinder);
      await tester.pump();
      expect(mockDataSource.lastApproveShiftId, equals('shift-test-1'));
      expect(mockDataSource.lastApproveBody?.confirmedAmount, equals('150.00'));
    });
  });
}
