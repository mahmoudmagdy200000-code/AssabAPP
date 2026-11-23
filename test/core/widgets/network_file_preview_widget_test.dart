import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> showAttachment(WidgetTester tester, String url) async {
  await tester.pumpWidget(
    AppResponsiveBuilder(
      builder: (_) => MaterialApp(
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
          body: NetworkFilePreviewWidget(
            attachmentModel: AttachmentModel(
              id: 'attachment-1',
              fileName: 'receipt.jpg',
              fileType: 'jpg',
              fileSize: 2048,
              url: url,
              uploadedAt: '2026-11-23T00:00:00Z',
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the attachment eye opens an app image preview', (tester) async {
    await showAttachment(tester, 'https://example.test/receipt.jpg');
    expect(find.text('2.0 KB'), findsOneWidget);
    await tester.tap(find.byType(AppGestureDetectorButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byType(CloseButton), findsOneWidget);
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
  });

  testWidgets('an unsupported attachment link shows an error', (tester) async {
    await showAttachment(tester, 'file:///receipt.jpg');
    await tester.tap(find.byType(AppGestureDetectorButton));
    await tester.pumpAndSettle();

    expect(find.byType(InteractiveViewer), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
