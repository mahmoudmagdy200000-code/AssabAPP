import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_info_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/add_cashier/get_available_cashier_shifts_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/add_cashier/select_working_shifts.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements ShiftManagementRepositoryImp {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Available extends GetAvailableCashierShiftsCubit {
  _Available() : super(_Repository());

  @override
  Future<void> getAvailableCashierShifts({
    required bool resetPagination,
  }) async {
    workShifts = [
      for (final id in ['First', 'Second'])
        ShiftInfoDetailsEntity(
          id: id,
          name: id,
          branchId: 'branch',
          branchName: 'Branch',
          isActive: true,
          startTime: id == 'First' ? '12:00' : '20:00',
          endTime: id == 'First' ? '20:00' : '04:00',
        ),
    ];
    emit(GetAvailableCashierShiftsSuccess(workShifts!));
  }
}

Widget _app(Widget child) => MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => _Available() as GetAvailableCashierShiftsCubit),
    BlocProvider(create: (_) => ChooseItemCubit()),
    BlocProvider(
      create: (_) => ValidationCubit(requiredFields: {'selectedShift'}),
    ),
  ],
  child: MaterialApp(
    theme: ThemeData(extensions: LightTheme.extension),
    locale: const Locale('en'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Builder(
      builder: (context) {
        AppResponsive.init(context, designWidth: 800, designHeight: 600);
        return Scaffold(body: child);
      },
    ),
  ),
);

void main() {
  testWidgets(
    'initial selection can be confirmed and only real API hours appear',
    (tester) async {
      String? selected;
      await tester.pumpWidget(
        _app(
          SelectWorkingShiftWidget(
            initialShiftId: 'First',
            showButton: true,
            onAction: (shift) => selected = shift.id,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Sunday - Thursday'), findsNothing);
      expect(find.textContaining('6:00 AM'), findsNothing);
      expect(find.textContaining('12:00 PM'), findsOneWidget);
      await tester.tap(find.text('Confirm'));
      expect(selected, 'First');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'choosing another shift survives rebuild and confirms that exact identity',
    (tester) async {
      String? selected;
      await tester.pumpWidget(
        _app(
          SelectWorkingShiftWidget(
            initialShiftId: 'First',
            showButton: true,
            onAction: (shift) => selected = shift.id,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Second'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      expect(selected, 'Second');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('confirm stays disabled until a real shift is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(SelectWorkingShiftWidget(showButton: true, onAction: (_) {})),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<AppButton>(find.byType(AppButton)).enabled, isFalse);
  });
}
