import 'package:assab/core/widgets/app_startup_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppStartupErrorWidget renders error message and triggers retry callback', (tester) async {
    bool retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AppStartupErrorWidget(
          errorMessage: 'مهلة تهيئة خدمات النظام انتهت قبل اكتمال الإقلاع',
          onRetry: () {
            retried = true;
          },
        ),
      ),
    );

    // Verify Arabic titles and error messages
    expect(find.text('تعذر بدء تشغيل التطبيق'), findsOneWidget);
    expect(
      find.text('حدث خطأ أو تأخر أثناء تهيئة خدمات النظام. يرجى التحقق من اتصال الشبكة وإعادة المحاولة.'),
      findsOneWidget,
    );
    expect(find.text('مهلة تهيئة خدمات النظام انتهت قبل اكتمال الإقلاع'), findsOneWidget);

    // Verify retry button exists and triggers callback
    final retryButtonFinder = find.byKey(const Key('btn_retry_startup'));
    expect(retryButtonFinder, findsOneWidget);

    await tester.tap(retryButtonFinder);
    await tester.pump();

    expect(retried, isTrue);
  });
}
