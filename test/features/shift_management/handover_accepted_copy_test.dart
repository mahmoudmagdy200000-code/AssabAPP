import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/handover_accepted_sheet_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildTestApp({required Widget child}) {
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
        home: Scaffold(body: child),
      );
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('F-08: HandoverAcceptedSheetWidget Truthful Copy Tests', () {
    testWidgets('Manager receipt displays custody verification text and does not claim shift start',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));

      await tester.pumpWidget(
        buildTestApp(
          child: const HandoverAcceptedSheetWidget(
            shiftId: 'shift-100',
            isManager: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Custody transfer has been verified and recorded'),
        findsOneWidget,
      );
      expect(
        find.textContaining('recorded under your name'),
        findsNothing,
      );
    });

    testWidgets('Cashier receipt displays shift takeover text', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));

      await tester.pumpWidget(
        buildTestApp(
          child: const HandoverAcceptedSheetWidget(
            shiftId: 'shift-100',
            isManager: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('recorded under your name'),
        findsOneWidget,
      );
    });
  });
}
