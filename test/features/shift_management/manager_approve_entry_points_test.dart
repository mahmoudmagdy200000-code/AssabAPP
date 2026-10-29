import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/accept_handover_sheet_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/handover_approve_body_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/manager_approve_button_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockShiftRemoteDataSource extends Fake
    implements ShiftManagementRemoteDataSource {
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
            child: SingleChildScrollView(child: child),
          ),
        ),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('F-01: Manager Approve Entry Points & Defense-in-depth Tests', () {
    late _MockShiftRemoteDataSource mockDataSource;
    late ShiftManagementRepositoryImp repository;
    late ApproveAndRejectHandoverCubit cubit;

    setUp(() {
      mockDataSource = _MockShiftRemoteDataSource();
      repository = ShiftManagementRepositoryImp(mockDataSource);
      cubit = ApproveAndRejectHandoverCubit(repository);
      UserTypeService.selectedUserType = UserType.branchManager;

      if (!getIt.isRegistered<ApproveAndRejectHandoverCubit>()) {
        getIt.registerFactory<ApproveAndRejectHandoverCubit>(
          () => ApproveAndRejectHandoverCubit(repository),
        );
      }
    });

    test('approveHandover fails closed with 422 when confirmedAmount is null',
        () async {
      await cubit.approveHandover(shiftId: 'shift-100', confirmedAmount: null);

      expect(cubit.state, isA<HandoverActionFailure>());
      final failure = (cubit.state as HandoverActionFailure).failure;
      expect(failure, isA<ValidationFailure>());
      expect(failure.statusCode, 422);
    });

    test(
        'approveHandover fails closed with 422 when confirmedAmount is invalid text',
        () async {
      await cubit.approveHandover(
          shiftId: 'shift-100', confirmedAmount: 'invalid_amount');

      expect(cubit.state, isA<HandoverActionFailure>());
      final failure = (cubit.state as HandoverActionFailure).failure;
      expect(failure, isA<ValidationFailure>());
      expect(failure.statusCode, 422);
    });

    test('confirmHandoverReceipt fails closed with 403 when role is unauthorized',
        () async {
      UserTypeService.selectedUserType = null;

      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-100',
        confirmedAmount: '150.00',
        actorRole: null,
      );

      expect(cubit.state, isA<HandoverActionFailure>());
      final failure = (cubit.state as HandoverActionFailure).failure;
      expect(failure, isA<AuthFailure>());
      expect(failure.statusCode, 403);
    });

    test(
        'confirmHandoverReceipt blocks on CASH-09 mismatch and returns 422 ValidationFailure',
        () async {
      UserTypeService.selectedUserType = UserType.branchManager;

      await cubit.confirmHandoverReceipt(
        shiftId: 'shift-100',
        confirmedAmount: '120.00',
        expectedAmount: 150.00,
        actorRole: UserType.branchManager,
      );

      expect(cubit.state, isA<HandoverActionFailure>());
      final failure = (cubit.state as HandoverActionFailure).failure;
      expect(failure, isA<ValidationFailure>());
      expect(failure.statusCode, 422);
      expect(failure.error.message, contains('CASH-09'));
    });

    testWidgets(
        'ManagerApproveButtonWidget opens AcceptHandoverSheetWidget with required count input',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));

      await tester.pumpWidget(
        buildTestApp(
          cubit: cubit,
          child: ManagerApproveButtonWidget(
            cashierShiftId: 'shift-100',
            cashierName: 'Ahmed Cashier',
            managerName: 'Branch Manager',
            cashFrom: 'Ahmed Cashier',
            cashGiven: 250.0,
            variance: 0.0,
            successFunction: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify button renders
      expect(find.byType(AppButton), findsOneWidget);

      // Tap Approve
      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      // AcceptHandoverSheetWidget must be displayed
      expect(find.byType(AcceptHandoverSheetWidget), findsOneWidget);

      // Must display reported handover amount
      expect(find.text('250.00'), findsWidgets);

      // Must display manager verification audit text (F-08)
      expect(
          find.textContaining(
              'as the responsible manager for custody verification',
              findRichText: true),
          findsOneWidget);
    });
  });
}
