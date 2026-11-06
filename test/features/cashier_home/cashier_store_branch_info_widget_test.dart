import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/cashier_home/data/datasources/cashier_home_remote_data_source.dart';
import 'package:assab/features/cashier_home/data/models/cashier_branch_info_response.dart';
import 'package:assab/features/cashier_home/data/repository/cashier_home_repository.dart';
import 'package:assab/features/cashier_home/presentation/cubit/get_branch_info/get_branch_info_cubit.dart';
import 'package:assab/features/cashier_home/presentation/widgets/cashier_store_branch_info_bottom_sheet_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _nullableBackendFixture = <String, dynamic>{
  'data': <String, dynamic>{
    'id': '00000000-0000-0000-0000-000000000001',
    'name': 'Branch [HARNESS]',
    'image': null,
    'location': null,
    'lat': null,
    'lng': null,
    'opening_hours': null,
    'closing_hours': null,
    'google_maps_url': null,
    'branch_manager': null,
  },
};

class _FixtureRemoteSource implements CashierHomeRemoteDataSource {
  @override
  Future<CashierBranchInfoResponse> getBranchInfo() async =>
      CashierBranchInfoResponse.fromJson(_nullableBackendFixture);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('Only branch info is under test');
}

void main() {
  for (final locale in const [Locale('ar'), Locale('en')]) {
    for (final width in const [320.0, 800.0]) {
      testWidgets('branch info accepts nullable API data in ${locale.languageCode} at ${width.toInt()}px',
          (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final cubit = GetBranchInfoCubit(
          CashierHomeRepository(_FixtureRemoteSource()),
        );
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
              home: const Scaffold(
                body: CashierStoreBranchInfoBottomSheetWidget(),
              ),
            ),
          ),
        ));
        await cubit.getBranchInfo();
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Branch [HARNESS]'), findsOneWidget);
        expect(find.byIcon(Icons.storefront_outlined), findsOneWidget);
        expect(find.text('null'), findsNothing);
        await cubit.close();
      });
    }
  }
}
