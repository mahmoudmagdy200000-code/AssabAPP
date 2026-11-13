import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/services/image_picker/image_picker_service.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/utils/api_result.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_aggregator_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/choose_employee/choose_employee_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/choose_variance_reason/choose_variance_reason_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/get_cashier/get_cashier_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/aggregator_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/handover/handover_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/end_shift_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/end_shift_with_handover_screen.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

const sampleCandidates = [
  ShortageAllocationCandidate(
    id: '10',
    name: 'علي الكاشير',
    type: 'cashier',
    role: 'كاشير',
  ),
  ShortageAllocationCandidate(
    id: '20',
    name: 'سعد مدير الفرع',
    type: 'branch_manager',
    role: 'مدير فرع',
  ),
];

class FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockShiftManagementRepository extends ShiftManagementRepositoryImp {
  MockShiftManagementRepository() : super(FakeRemoteDataSource());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
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
          'expected_cash': 100.0,
          'counted_cash': countedCash,
          'cash_variance': -30.0,
          'cash_variance_type': 'shortage',
        },
        'shortage_to_allocate': 30.0,
        'allocation_required': true,
      },
    });
  }

  @override
  FutureApiResult<List<ShortageAllocationCandidate>>
  getShortageAllocationCandidates({required String shiftId}) async {
    return ApiResult.success(sampleCandidates);
  }
}

Widget buildResponsiveTestApp({
  required Widget child,
  required Size viewportSize,
  double bottomInset = 0,
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
    home: MediaQuery(
      data: MediaQueryData(
        size: viewportSize,
        viewInsets: EdgeInsets.only(bottom: bottomInset),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Builder(
          builder: (context) {
            AppResponsive.init(
              context,
              designWidth: viewportSize.width,
              designHeight: viewportSize.height,
            );
            return child;
          },
        ),
      ),
    ),
  );
}

void main() {
  late MockShiftManagementRepository mockRepo;

  setUp(() {
    mockRepo = MockShiftManagementRepository();

    if (!getIt.isRegistered<ChooseVarianceReasonCubit>()) {
      getIt.registerFactory<ChooseVarianceReasonCubit>(
        () => ChooseVarianceReasonCubit(),
      );
    }
    if (!getIt.isRegistered<GetCashierCubit>()) {
      getIt.registerFactory<GetCashierCubit>(
        () => GetCashierCubit(mockRepo),
      );
    }
    if (!getIt.isRegistered<MediaCubit>()) {
      getIt.registerFactory<MediaCubit>(
        () => MediaCubit(ImagePickerService(ImagePicker())),
      );
    }
    if (!getIt.isRegistered<AggregatorCubit>()) {
      getIt.registerFactory<AggregatorCubit>(
        () => AggregatorCubit(mockRepo),
      );
    }
    if (!getIt.isRegistered<ChooseItemCubit>()) {
      getIt.registerFactory<ChooseItemCubit>(
        () => ChooseItemCubit(),
      );
    }
    if (!getIt.isRegistered<HandoverCubit>()) {
      getIt.registerFactoryParam<HandoverCubit, String, dynamic>(
        (shiftId, _) => HandoverCubit(mockRepo, shiftId),
      );
    }
  });

  group('MT-26: Small Screens (320x640 & 360x740) & Keyboard Insets Overflow Tests on Production Screens', () {
    testWidgets(
      'EndShiftScreen at 320x640 with 280px keyboard open: can scroll, select candidate, enter amount, and add without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(320 * 2, 640 * 2);
        tester.view.devicePixelRatio = 2.0;
        tester.view.viewInsets = const FakeViewPadding(bottom: 280 * 2);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.view.resetViewInsets();
        });

        final endShiftCubit = EndShiftCubit(mockRepo, 'shift_mt26_1', null);
        endShiftCubit.setCountedCash(70.0);
        await endShiftCubit.fetchCashReconciliationPreview();
        await endShiftCubit.fetchShortageCandidates();

        final pagingCubit = PagingCubit(totalSteps: 2)..nextStep(); // Step 1: Summary & Shortage Allocation

        await tester.pumpWidget(
          buildResponsiveTestApp(
            viewportSize: const Size(320, 640),
            bottomInset: 280,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: pagingCubit),
                BlocProvider(create: (_) => ValidationCubit(requiredFields: {'totalSales'})),
                BlocProvider.value(value: endShiftCubit),
                BlocProvider(create: (_) => ChooseEmployeeCubit()),
                BlocProvider(create: (_) => getIt<AggregatorCubit>()),
                BlocProvider(create: (_) => getIt<MediaCubit>()),
              ],
              child: const EndShiftScreen(
                isNavigatedFromCashier: true,
                isOpenedFromShiftDetailsScreen: false,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Must find the title inside the actual EndShiftScreen
        expect(find.text('توزيع العجز النقدي'), findsOneWidget);

        // Scroll down in the allocation scrollable
        final allocScrollable = find.byType(Scrollable).last;
        await tester.scrollUntilVisible(
          find.text('اختر المسؤول (الاسم ومعرف النظام)'),
          100.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Select candidate
        await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(find.text('علي الكاشير (ID: 10)').last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Scroll to amount input
        await tester.scrollUntilVisible(
          find.byType(TextField).first,
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Enter amount
        await tester.enterText(find.byType(TextField).first, '30.0');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Scroll to Add button
        await tester.scrollUntilVisible(
          find.text('أضف'),
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Tap Add
        await tester.tap(find.text('أضف'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(endShiftCubit.shortageAllocations.length, 1);
        expect(endShiftCubit.shortageAllocations.first.responsibleId, '10');
        expect(endShiftCubit.shortageAllocations.first.amount, 30.0);
        expect(find.text('مكتملة'), findsOneWidget);

        expect(tester.takeException(), isNull, reason: 'Expected no RenderFlex overflow or error on EndShiftScreen 320x640 with keyboard');

        await endShiftCubit.close();
        await pagingCubit.close();
      },
    );

    testWidgets(
      'EndShiftScreen at 360x740 with 280px keyboard open: can scroll, select candidate, enter amount, and add without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(360 * 2, 740 * 2);
        tester.view.devicePixelRatio = 2.0;
        tester.view.viewInsets = const FakeViewPadding(bottom: 280 * 2);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.view.resetViewInsets();
        });

        final endShiftCubit = EndShiftCubit(mockRepo, 'shift_mt26_2', null);
        endShiftCubit.setCountedCash(70.0);
        await endShiftCubit.fetchCashReconciliationPreview();
        await endShiftCubit.fetchShortageCandidates();

        final pagingCubit = PagingCubit(totalSteps: 2)..nextStep();

        await tester.pumpWidget(
          buildResponsiveTestApp(
            viewportSize: const Size(360, 740),
            bottomInset: 280,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: pagingCubit),
                BlocProvider(create: (_) => ValidationCubit(requiredFields: {'totalSales'})),
                BlocProvider.value(value: endShiftCubit),
                BlocProvider(create: (_) => ChooseEmployeeCubit()),
                BlocProvider(create: (_) => getIt<AggregatorCubit>()),
                BlocProvider(create: (_) => getIt<MediaCubit>()),
              ],
              child: const EndShiftScreen(
                isNavigatedFromCashier: true,
                isOpenedFromShiftDetailsScreen: false,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('توزيع العجز النقدي'), findsOneWidget);

        final allocScrollable = find.byType(Scrollable).last;
        await tester.scrollUntilVisible(
          find.text('اختر المسؤول (الاسم ومعرف النظام)'),
          100.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(find.text('علي الكاشير (ID: 10)').last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.scrollUntilVisible(
          find.byType(TextField).first,
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.enterText(find.byType(TextField).first, '30.0');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.text('أضف'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(endShiftCubit.shortageAllocations.length, 1);
        expect(endShiftCubit.shortageAllocations.first.responsibleId, '10');
        expect(endShiftCubit.shortageAllocations.first.amount, 30.0);
        expect(find.text('مكتملة'), findsOneWidget);

        expect(tester.takeException(), isNull, reason: 'Expected no RenderFlex overflow on EndShiftScreen 360x740 with keyboard');

        await endShiftCubit.close();
        await pagingCubit.close();
      },
    );

    testWidgets(
      'EndShiftWithHandoverScreen at 320x640 with 280px keyboard open: can scroll, select candidate, enter amount, and add without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(320 * 2, 640 * 2);
        tester.view.devicePixelRatio = 2.0;
        tester.view.viewInsets = const FakeViewPadding(bottom: 280 * 2);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.view.resetViewInsets();
        });

        final endShiftCubit = EndShiftCubit(mockRepo, 'shift_mt26_3', null);
        endShiftCubit.setCountedCash(70.0);
        await endShiftCubit.fetchCashReconciliationPreview();
        await endShiftCubit.fetchShortageCandidates();

        final pagingCubit = PagingCubit(totalSteps: 3)..nextStep()..nextStep(); // Step 2: Summary & Shortage Allocation

        await tester.pumpWidget(
          buildResponsiveTestApp(
            viewportSize: const Size(320, 640),
            bottomInset: 280,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: pagingCubit),
                BlocProvider(create: (_) => ValidationCubit(requiredFields: {'totalSales', 'responsibilityType'})),
                BlocProvider.value(value: endShiftCubit),
                BlocProvider(create: (_) => ChooseEmployeeCubit()),
                BlocProvider(create: (_) => getIt<AggregatorCubit>()),
                BlocProvider(create: (_) => getIt<MediaCubit>()),
              ],
              child: const EndShiftWithHandoverScreen(
                isNavigatedFromCashier: true,
                isOpenedFromShiftDetailsScreen: false,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('توزيع العجز النقدي'), findsOneWidget);

        final allocScrollable = find.byType(Scrollable).last;
        await tester.scrollUntilVisible(
          find.text('اختر المسؤول (الاسم ومعرف النظام)'),
          100.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(find.text('علي الكاشير (ID: 10)').last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.scrollUntilVisible(
          find.byType(TextField).first,
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.enterText(find.byType(TextField).first, '30.0');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.scrollUntilVisible(
          find.text('أضف'),
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.text('أضف'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(endShiftCubit.shortageAllocations.length, 1);
        expect(endShiftCubit.shortageAllocations.first.responsibleId, '10');
        expect(endShiftCubit.shortageAllocations.first.responsibleType, 'cashier');
        expect(endShiftCubit.shortageAllocations.first.amount, 30.0);
        expect(find.text('مكتملة'), findsOneWidget);

        expect(tester.takeException(), isNull, reason: 'Expected no RenderFlex overflow on EndShiftWithHandoverScreen 320x640 with keyboard');

        await endShiftCubit.close();
        await pagingCubit.close();
      },
    );

    testWidgets(
      'EndShiftWithHandoverScreen at 360x740 with 280px keyboard open: can scroll, select candidate, enter amount, and add without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(360 * 2, 740 * 2);
        tester.view.devicePixelRatio = 2.0;
        tester.view.viewInsets = const FakeViewPadding(bottom: 280 * 2);

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          tester.view.resetViewInsets();
        });

        final endShiftCubit = EndShiftCubit(mockRepo, 'shift_mt26_4', null);
        endShiftCubit.setCountedCash(70.0);
        await endShiftCubit.fetchCashReconciliationPreview();
        await endShiftCubit.fetchShortageCandidates();

        final pagingCubit = PagingCubit(totalSteps: 3)..nextStep()..nextStep();

        await tester.pumpWidget(
          buildResponsiveTestApp(
            viewportSize: const Size(360, 740),
            bottomInset: 280,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: pagingCubit),
                BlocProvider(create: (_) => ValidationCubit(requiredFields: {'totalSales', 'responsibilityType'})),
                BlocProvider.value(value: endShiftCubit),
                BlocProvider(create: (_) => ChooseEmployeeCubit()),
                BlocProvider(create: (_) => getIt<AggregatorCubit>()),
                BlocProvider(create: (_) => getIt<MediaCubit>()),
              ],
              child: const EndShiftWithHandoverScreen(
                isNavigatedFromCashier: true,
                isOpenedFromShiftDetailsScreen: false,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('توزيع العجز النقدي'), findsOneWidget);

        final allocScrollable = find.byType(Scrollable).last;
        await tester.scrollUntilVisible(
          find.text('اختر المسؤول (الاسم ومعرف النظام)'),
          100.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.text('اختر المسؤول (الاسم ومعرف النظام)'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
        await tester.tap(find.text('علي الكاشير (ID: 10)').last);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.scrollUntilVisible(
          find.byType(TextField).first,
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.enterText(find.byType(TextField).first, '30.0');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.scrollUntilVisible(
          find.text('أضف'),
          50.0,
          scrollable: allocScrollable,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        await tester.tap(find.text('أضف'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(endShiftCubit.shortageAllocations.length, 1);
        expect(endShiftCubit.shortageAllocations.first.responsibleId, '10');
        expect(endShiftCubit.shortageAllocations.first.responsibleType, 'cashier');
        expect(endShiftCubit.shortageAllocations.first.amount, 30.0);
        expect(find.text('مكتملة'), findsOneWidget);

        expect(tester.takeException(), isNull, reason: 'Expected no RenderFlex overflow on EndShiftWithHandoverScreen 360x740 with keyboard');

        await endShiftCubit.close();
        await pagingCubit.close();
      },
    );
  });
}
