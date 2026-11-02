import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/choose_user_type/presentation/cubit/choose_user_type/choose_user_type_cubit.dart';
import 'package:assab/features/choose_user_type/presentation/screens/choose_user_type_screen.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final width in [320.0, 800.0]) {
      testWidgets('role choices render in ${locale.languageCode} at $width px', (tester) async {
        tester.view.physicalSize = Size(width, width == 320 ? 700 : 1100);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await getIt.reset();
        getIt.registerSingleton<UserTypeStrategy>(BranchManagerUserStrategy(), instanceName: UserType.branchManager.value);
        getIt.registerSingleton<UserTypeStrategy>(CashierUserStrategy(), instanceName: UserType.cashier.value);
        getIt.registerSingleton<UserTypeStrategy>(SupplierUserStrategy(), instanceName: UserType.supplier.value);
        getIt.registerSingleton<UserTypeStrategy>(BrandOwnerUserStrategy(), instanceName: UserType.brandOwner.value);
        final cubit = ChooseUserTypeCubit();
        addTearDown(() async {
          await cubit.close();
          await getIt.reset();
        });

        await tester.pumpWidget(AppResponsiveBuilder(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: MaterialApp(
              theme: AppTheme.light,
              locale: locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              home: const ChooseUserTypeScreen(),
            ),
          ),
        ));
        await tester.pump(const Duration(milliseconds: 200));

        final strings = S.of(tester.element(find.byType(ChooseUserTypeScreen)));
        for (final label in [strings.branchManager, strings.cashier, strings.supplier, strings.brandOwner]) {
          expect(find.text(label), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}
