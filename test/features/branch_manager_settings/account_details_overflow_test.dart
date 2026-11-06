import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/branch_manager_settings/domain/entities/branch_manager_my_account_details_entity.dart';
import 'package:assab/features/branch_manager_settings/domain/repositories/branch_manager_setting_and_aggregators_repository.dart';
import 'package:assab/features/branch_manager_settings/domain/usecases/branch_manager_setting_and_aggregators_usecases.dart';
import 'package:assab/features/branch_manager_settings/presentation/cubits/branch_manager_my_account_details_cubit.dart';
import 'package:assab/features/branch_manager_settings/presentation/cubits/branch_manager_my_account_details_state.dart';
import 'package:assab/features/branch_manager_settings/presentation/screens/branch_manager_my_account_details_screen.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _UnusedRepository implements BranchManagerSettingAndAggregatorsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('Only the screen rendering is under test');
}

class _FixedDetailsCubit extends BranchManagerMyAccountDetailsCubit {
  _FixedDetailsCubit()
      : super(GetBranchManagerMyAccountDetailsUseCase(_UnusedRepository()));

  @override
  Future<void> loadData() async {
    emit(const BranchManagerMyAccountDetailsLoaded(
      BranchManagerMyAccountDetailsEntity(
        firstName: 'FirstNameWithLongText',
        lastName: 'LastNameWithLongText',
        emailAddress: 'assab-ui-qa-20261102.cashier.long.address@fixture.invalid',
        role: 'Cashier',
        assignedTo: 'Branch [HARNESS]',
        weekdays: 'Sun - Thu',
        workShift: '',
      ),
    ));
  }
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<BranchManagerMyAccountDetailsCubit>(
      _FixedDetailsCubit.new,
    );
  });
  tearDown(() async => getIt.reset());

  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final width in const [320.0, 360.0, 800.0]) {
      testWidgets('account details fits ${locale.languageCode} at ${width.toInt()}px',
          (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(AppResponsiveBuilder(
          builder: (_) => MaterialApp(
            theme: AppTheme.light,
            locale: locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: const BranchManagerMyAccountDetailsScreen(),
          ),
        ));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(
          find.text('assab-ui-qa-20261102.cashier.long.address@fixture.invalid'),
          findsOneWidget,
        );
      });
    }
  }
}
