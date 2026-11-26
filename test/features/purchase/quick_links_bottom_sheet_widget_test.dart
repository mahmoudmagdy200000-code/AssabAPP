import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/features/purchase/presentation/widgets/quick_links_bottom_sheet_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingObserver extends NavigatorObserver {
  final List<String?> pushed = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route.settings.name);
  }
}

void main() {
  testWidgets(
    'QuickLinksBottomSheetWidget wires all 5 buttons to real routes',
    (tester) async {
      final observer = _RecordingObserver();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: NavigationService.I.navigatorKey,
          navigatorObservers: [observer],
          theme: ThemeData(extensions: LightTheme.extension),
          locale: const Locale('en'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => const Scaffold(body: SizedBox.shrink()),
          ),
          home: Builder(
            builder: (context) {
              AppResponsive.init(context, designWidth: 390, designHeight: 844);
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      Future<void> tapAndCheck(String label, String expectedRoute) async {
        // Push a parent route + bottom sheet so pop(); pop(); pushNamed(); mirrors live flow
        NavigationService.I.pushNamed('/parent');
        await tester.pumpAndSettle();
        NavigationService.I.push(
          MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: SingleChildScrollView(child: QuickLinksBottomSheetWidget()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        observer.pushed.clear();
        await tester.ensureVisible(find.text(label));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(observer.pushed, contains(expectedRoute));
        NavigationService.I.popUntil((r) => r.isFirst);
        await tester.pumpAndSettle();
      }

      await tapAndCheck(S.current.outOfStock, AppRouteName.purchaseScreen);
      await tapAndCheck(
        S.current.pendingOrders,
        AppRouteName.branchManagerMainScreen,
      );
      await tapAndCheck(S.current.receiveGoods, AppRouteName.receiveGoodsScreen);
      await tapAndCheck(
        S.current.returnsManagement,
        AppRouteName.returnsManagementScreen,
      );
      await tapAndCheck(
        S.current.supplierAnalysisAndComparison,
        AppRouteName.branchManagerViewReportsScreen,
      );
    },
  );
}
