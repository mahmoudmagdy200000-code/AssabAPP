import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/routing/app_router.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/dated_shift_assignment_screen.dart';
import 'package:assab/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test HTTP adapter to record raw HTTP requests and verify URL resolution
class TestHttpAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options)? onFetch;
  final List<RequestOptions> recordedRequests = [];

  TestHttpAdapter({this.onFetch});

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    recordedRequests.add(options);
    if (onFetch != null) {
      return onFetch!(options);
    }
    return ResponseBody.fromString(
      jsonEncode({
        'success': true,
        'message': 'OK',
        'data': {
          'branch_id': 'branch-1',
          'start_date': '2026-11-15',
          'end_date': '2026-11-21',
          'templates': [],
          'roster': {},
        },
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Widget _buildTestApp(Widget child, {Locale locale = const Locale('ar')}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: LightTheme.extension,
      primaryColor: const Color(0xFF1E88E5),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    ),
    locale: locale,
    supportedLocales: S.delegate.supportedLocales,
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Builder(
      builder: (context) {
        AppResponsive.init(context, designWidth: 390, designHeight: 844);
        return child;
      },
    ),
  );
}

const List<DatedTemplateSlot> kTestTemplates = [
  DatedTemplateSlot(
    templateId: 'tpl-1',
    templateName: 'الوردية الصباحية - كاشير 1',
    startTime: '08:00',
    endTime: '16:00',
    cashierShiftId: 'actual-1',
    cashierId: 'csh-1',
    cashierName: 'محمد أحمد السعيد',
    status: 'not_started',
    shiftDate: '2026-11-15',
    hasFinancialEvidence: false,
  ),
  DatedTemplateSlot(
    templateId: 'tpl-2',
    templateName: 'الوردية المسائية - كاشير 2',
    startTime: '16:00',
    endTime: '00:00',
    cashierShiftId: 'actual-2',
    cashierId: 'csh-2',
    cashierName: 'عبدالله إبراهيم محمود',
    status: 'not_started',
    shiftDate: '2026-11-15',
    hasFinancialEvidence: false,
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('P4a — DatedShiftAssignmentScreen Widget & Usability Tests', () {
    testWidgets('renders dated assignment screen with accountant policy and templates (390px mobile)',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildTestApp(
          const DatedShiftAssignmentScreen(
            initialTemplates: kTestTemplates,
            initialDateRange: '2026-11-15 — 2026-11-21',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify title and accountant governance banner
      expect(find.byKey(const Key('txt_screen_title')), findsOneWidget);
      expect(find.text('تعيين مؤرّخ'), findsOneWidget);
      expect(
        find.byKey(const Key('txt_accountant_governance_notice')),
        findsOneWidget,
      );
      expect(
        find.text('إعداد القوالب والمواعيد يظل ضمن صلاحيات المحاسب'),
        findsOneWidget,
      );

      // 2. Verify single-day calendar header (no legacy All/day chip strip)
      expect(find.byKey(const Key('txt_selected_date')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-15'),
      );
      expect(find.byKey(const Key('btn_prev_day')), findsOneWidget);
      expect(find.byKey(const Key('btn_next_day')), findsOneWidget);
      expect(find.byKey(const Key('chip_day_all')), findsNothing);

      // 3. Verify templates rendered with cashiers and hours
      expect(find.byKey(const Key('card_template_tpl-1')), findsOneWidget);
      expect(find.byKey(const Key('card_template_tpl-2')), findsOneWidget);
      expect(find.text('محمد أحمد السعيد'), findsOneWidget);
      expect(find.text('عبدالله إبراهيم محمود'), findsOneWidget);
      expect(find.text('08:00 - 16:00'), findsOneWidget);
      expect(find.text('16:00 - 00:00'), findsOneWidget);

      // 4. Verify no RenderFlex overflow
      expect(tester.takeException(), isNull);
    });

    testWidgets('executes atomic cashier swap between two templates successfully',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? swappedA;
      String? swappedB;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            initialTemplates: kTestTemplates,
            initialDateRange: '2026-11-15 — 2026-11-21',
            onExecuteSwap: (cA, sA, cB, sB, d, f) async {
              swappedA = sA;
              swappedB = sB;
            },
            onSwapCompleted: (a, b) {
              swappedA = a;
              swappedB = b;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('txt_cashier_name_tpl-1')), findsOneWidget);
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'محمد أحمد السعيد',
      );
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-2')))
            .data,
        'عبدالله إبراهيم محمود',
      );

      // Tap swap on template 1
      await tester.tap(find.byKey(const Key('btn_swap_tpl-1')));
      await tester.pumpAndSettle();

      expect(find.text('إلغاء'), findsOneWidget);

      // Scroll to ensure template 2 is in view
      await tester.scrollUntilVisible(
        find.byKey(const Key('btn_swap_tpl-2')),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('إتمام التبديل'), findsOneWidget);

      // Tap swap on template 2 to complete swap
      await tester.tap(find.byKey(const Key('btn_swap_tpl-2')));
      await tester.pumpAndSettle();

      // Drag back up to bring template 1 into view
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 300));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'عبدالله إبراهيم محمود',
      );

      // Drag down to bring template 2 into view
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-2')))
            .data,
        'محمد أحمد السعيد',
      );

      expect(swappedA, 'tpl-1');
      expect(swappedB, 'tpl-2');
      expect(find.textContaining('تم تبديل الكاشيرين بنجاح'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('preserves protection when shift has financial evidence or is in progress',
        (tester) async {
      tester.view.physicalSize = const Size(360 * 2.0, 800 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      const protectedTemplates = [
        DatedTemplateSlot(
          templateId: 'tpl-protected-1',
          templateName: 'وردية الصباح المحمية',
          startTime: '08:00',
          endTime: '16:00',
          cashierId: 'csh-p1',
          cashierName: 'كاشير نشط في الوردية',
          status: 'in_progress',
          hasFinancialEvidence: false,
        ),
        DatedTemplateSlot(
          templateId: 'tpl-protected-2',
          templateName: 'وردية المساء ذات القيود المالية',
          startTime: '16:00',
          endTime: '00:00',
          cashierId: 'csh-p2',
          cashierName: 'كاشير لديه مبيعات ومتحصلات',
          status: 'not_started',
          hasFinancialEvidence: true,
        ),
      ];

      await tester.pumpWidget(
        _buildTestApp(
          const DatedShiftAssignmentScreen(
            initialTemplates: protectedTemplates,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Protected shifts should NOT have swap button
      expect(find.byKey(const Key('btn_swap_tpl-protected-1')), findsNothing);
      expect(find.byKey(const Key('btn_swap_tpl-protected-2')), findsNothing);

      // Protected badge labels visible
      expect(find.text('وردية بدأت أو انتهت'), findsOneWidget);
      expect(find.text('محمي بدليل مالي'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('server rejection (422) displays error and does not swap UI state',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool swapCalled = false;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            initialTemplates: kTestTemplates,
            initialDateRange: '2026-11-15 — 2026-11-21',
            onExecuteSwap: (cashierAId, shiftAId, cashierBId, shiftBId, date, forFullWeek) async {
              swapCalled = true;
              throw Exception('تعذر التبديل: إحدى الورديات نشطة أو تحتوي على قيود مالية محمية.');
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap swap on template 1
      await tester.tap(find.byKey(const Key('btn_swap_tpl-1')));
      await tester.pumpAndSettle();

      // Tap swap on template 2 (triggering rejected execution)
      await tester.tap(find.byKey(const Key('btn_swap_tpl-2')));
      await tester.pumpAndSettle();

      expect(swapCalled, isTrue);

      // Verify server rejection message is displayed
      expect(
        find.textContaining('تعذر التبديل: إحدى الورديات نشطة أو تحتوي على قيود مالية محمية.'),
        findsOneWidget,
      );

      // Verify NO false success message
      expect(find.textContaining('تم تبديل الكاشيرين بنجاح'), findsNothing);

      // Verify UI state was NOT swapped
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'محمد أحمد السعيد',
      );
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-2')))
            .data,
        'عبدالله إبراهيم محمود',
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('screen retains persisted state from backend across reopening/refreshing',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      List<DatedTemplateSlot> backendRoster = [
        const DatedTemplateSlot(
          templateId: 'tpl-1',
          templateName: 'وردية الصباح الأولى',
          startTime: '08:00',
          endTime: '16:00',
          cashierShiftId: 'actual-1',
    cashierId: 'csh-1',
          cashierName: 'محمد أحمد السعيد',
          status: 'not_started',
        ),
        const DatedTemplateSlot(
          templateId: 'tpl-2',
          templateName: 'وردية المساء الثانية',
          startTime: '16:00',
          endTime: '00:00',
          cashierShiftId: 'actual-2',
    cashierId: 'csh-2',
          cashierName: 'عبدالله إبراهيم محمود',
          status: 'not_started',
        ),
      ];

      Future<List<DatedTemplateSlot>> fetchRoster(String start, String end) async {
        return List.from(backendRoster);
      }

      Future<void> executeSwap(
        String cA,
        String sA,
        String cB,
        String sB,
        String date,
        bool fullWeek,
      ) async {
        final idxA = backendRoster.indexWhere((t) => t.templateId == sA);
        final idxB = backendRoster.indexWhere((t) => t.templateId == sB);
        final itemA = backendRoster[idxA];
        final itemB = backendRoster[idxB];

        backendRoster[idxA] = itemA.copyWith(
          cashierId: itemB.cashierId,
          cashierName: itemB.cashierName,
        );
        backendRoster[idxB] = itemB.copyWith(
          cashierId: itemA.cashierId,
          cashierName: itemA.cashierName,
        );
      }

      // 1. Initial screen opening
      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onFetchRoster: fetchRoster,
            onExecuteSwap: executeSwap,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'محمد أحمد السعيد',
      );

      // 2. Perform atomic swap
      await tester.tap(find.byKey(const Key('btn_swap_tpl-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_swap_tpl-2')));
      await tester.pumpAndSettle();

      expect(find.textContaining('تم تبديل الكاشيرين بنجاح'), findsOneWidget);
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'عبدالله إبراهيم محمود',
      );

      // 3. Reopen screen
      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onFetchRoster: fetchRoster,
            onExecuteSwap: executeSwap,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // State is retained from backend
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-1')))
            .data,
        'عبدالله إبراهيم محمود',
      );
      expect(
        tester
            .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl-2')))
            .data,
        'محمد أحمد السعيد',
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('day navigation buttons switch days and reload when crossing week boundary',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? requestedStart;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            initialDateRange: '2026-11-15 — 2026-11-21',
            onFetchRoster: (start, end) async {
              requestedStart = start;
              return [];
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(requestedStart, '2026-11-15');

      // Step backward from Sunday 2026-11-15 -> Saturday 2026-11-14 triggers previous week load
      await tester.tap(find.byKey(const Key('btn_prev_day')));
      await tester.pumpAndSettle();

      expect(requestedStart, '2026-11-08');
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-14'),
      );

      // Step forward back into 2026-11-15 triggers reload for next week
      await tester.tap(find.byKey(const Key('btn_next_day')));
      await tester.pumpAndSettle();

      expect(requestedStart, '2026-11-15');
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-15'),
      );

      // Step through remaining 6 days of the week (16..21) + 1 more -> crosses to 2026-11-22
      for (var i = 0; i < 7; i++) {
        await tester.tap(find.byKey(const Key('btn_next_day')));
        await tester.pumpAndSettle();
      }

      expect(requestedStart, '2026-11-22');
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-22'),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('API relative paths: Dio request URLs, methods, and parameters match app contract',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final adapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (options.path.contains('dated-roster')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'branch_id': 'branch-1',
                'start_date': '2026-11-15',
                'end_date': '2026-11-21',
                'templates': [
                  {
                    'id': 'tpl-1',
                    'name': 'وردية الصباح الأولى',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                  {
                    'id': 'tpl-2',
                    'name': 'وردية المساء الثانية',
                    'start_time': '16:00:00',
                    'end_time': '00:00:00',
                  },
                ],
                'roster': {
                  '2026-11-15_tpl-1': {
                    'cashier_shift_id': 'actual-csh-1',
                    'cashier_id': 'csh-1',
                    'cashier_name': 'محمد أحمد السعيد',
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-1',
                    'can_swap': true,
                  },
                  '2026-11-15_tpl-2': {
                    'cashier_shift_id': 'actual-csh-2',
                    'cashier_id': 'csh-2',
                    'cashier_name': 'عبدالله إبراهيم محمود',
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-2',
                    'can_swap': true,
                  },
                },
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        if (options.path.contains('swap-shifts')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'تم تبديل الكاشيرين بنجاح وحفظ السجل المؤرّخ ذرياً.',
              'data': {},
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        return ResponseBody.fromString('{"success": true, "data": []}', 200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
            initialDateRange: '2026-11-15 — 2026-11-21',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify GET dated-roster was called with clean relative path and query parameters
      expect(adapter.recordedRequests.isNotEmpty, isTrue);
      final getReq = adapter.recordedRequests.first;
      expect(getReq.method, 'GET');
      expect(
        getReq.uri.toString(),
        'https://erp.assab.sa/api/v1/branch-manager/cashiers/dated-roster?start_date=2026-11-15&end_date=2026-11-21',
      );
      expect(getReq.path, 'branch-manager/cashiers/dated-roster');
      expect(getReq.queryParameters['start_date'], '2026-11-15');
      expect(getReq.queryParameters['end_date'], '2026-11-21');

      // Now perform swap between tpl-1 and tpl-2
      await tester.tap(find.byKey(const Key('btn_swap_tpl-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_swap_tpl-2')));
      await tester.pumpAndSettle();

      // Verify POST swap-shifts was called with clean relative path
      final swapReq = adapter.recordedRequests.firstWhere(
        (r) => r.path.contains('swap-shifts'),
      );
      expect(swapReq.method, 'POST');
      expect(
        swapReq.uri.toString(),
        'https://erp.assab.sa/api/v1/branch-manager/cashiers/swap-shifts',
      );
      expect(swapReq.data['cashier_a_id'], 'csh-1');
      expect(swapReq.data['shift_a_id'], 'tpl-1');
      expect(swapReq.data['cashier_b_id'], 'csh-2');
      expect(swapReq.data['shift_b_id'], 'tpl-2');
      expect(swapReq.data['shift_date'], '2026-11-15');

      expect(tester.takeException(), isNull);
    });

    testWidgets('multi-day period: displays distinct dates and action on day 2 sends day 2 date',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? capturedDate;

      final adapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (options.path.contains('dated-roster')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'branch_id': 'branch-1',
                'start_date': '2026-11-15',
                'end_date': '2026-11-21',
                'templates': [
                  {
                    'id': 'tpl-1',
                    'name': 'وردية الصباح الأولى',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                  {
                    'id': 'tpl-2',
                    'name': 'وردية المساء الثانية',
                    'start_time': '16:00:00',
                    'end_time': '00:00:00',
                  },
                ],
                'roster': {
                  '2026-11-15_tpl-1': {
                    'cashier_shift_id': 'actual-csh-1',
                    'cashier_id': 'csh-1',
                    'cashier_name': 'كاشير يوم 15 قالب 1',
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-1',
                    'can_swap': true,
                  },
                  '2026-11-15_tpl-2': {
                    'cashier_shift_id': 'actual-csh-2',
                    'cashier_id': 'csh-2',
                    'cashier_name': 'كاشير يوم 15 قالب 2',
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-2',
                    'can_swap': true,
                  },
                  '2026-11-16_tpl-1': {
                    'cashier_shift_id': 'actual-csh-3',
                    'cashier_id': 'csh-3',
                    'cashier_name': 'كاشير يوم 16 قالب 1',
                    'status': 'not_started',
                    'shift_date': '2026-11-16',
                    'shift_id': 'tpl-1',
                    'can_swap': true,
                  },
                  '2026-11-16_tpl-2': {
                    'cashier_shift_id': 'actual-csh-4',
                    'cashier_id': 'csh-4',
                    'cashier_name': 'كاشير يوم 16 قالب 2',
                    'status': 'not_started',
                    'shift_date': '2026-11-16',
                    'shift_id': 'tpl-2',
                    'can_swap': true,
                  },
                },
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        if (options.path.contains('swap-shifts')) {
          capturedDate = options.data['shift_date']?.toString();
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'تم تبديل الكاشيرين بنجاح وحفظ السجل المؤرّخ ذرياً.',
              'data': {},
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        return ResponseBody.fromString('{"success": true, "data": []}', 200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
            initialDateRange: '2026-11-15 — 2026-11-21',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Default view shows only Day 1 (2026-11-15), without legacy All/day chip strip
      expect(find.byKey(const Key('chip_day_all')), findsNothing);
      expect(find.byKey(const Key('chip_day_2026-11-15')), findsNothing);
      expect(find.byKey(const Key('chip_day_2026-11-16')), findsNothing);
      expect(find.text('كاشير يوم 15 قالب 1'), findsOneWidget);
      expect(find.text('كاشير يوم 16 قالب 1'), findsNothing);

      // Navigate to Day 2 (2026-11-16) via next-day button
      await tester.tap(find.byKey(const Key('btn_next_day')));
      await tester.pumpAndSettle();

      // Verify day 2 cashier names are visible and day 1 is hidden
      expect(find.text('كاشير يوم 15 قالب 1'), findsNothing);
      expect(find.text('كاشير يوم 16 قالب 1'), findsOneWidget);
      expect(find.text('كاشير يوم 16 قالب 2'), findsOneWidget);

      // Execute swap on day 2
      await tester.tap(find.byKey(const Key('btn_swap_tpl-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_swap_tpl-2')));
      await tester.pumpAndSettle();

      // Assert request sent day 2 date
      expect(capturedDate, '2026-11-16');

      expect(tester.takeException(), isNull);
    });

    testWidgets('MT-21: manager assigns authorized cashier to unassigned template via assign-shifts',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      RequestOptions? recordedAssignReq;
      bool assignmentSaved = false;

      final adapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (options.path.contains('dated-roster')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'branch_id': 'branch-1',
                'start_date': '2026-11-15',
                'end_date': '2026-11-21',
                'templates': [
                  {
                    'id': 'tpl-unassigned',
                    'name': 'وردية شاغرة بلا كاشير',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                ],
                'roster': {
                  '2026-11-15_tpl-unassigned': {
                    'cashier_shift_id': assignmentSaved ? 'actual-new' : null,
                    'cashier_id': assignmentSaved ? 'csh-authorized' : null,
                    'cashier_name': assignmentSaved ? 'عبدالمحسن فهد التميمي' : null,
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-unassigned',
                    'can_swap': assignmentSaved,
                  },
                },
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        if (options.path.contains('assign-shifts')) {
          recordedAssignReq = options;
          assignmentSaved = true;
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'تم تعيين الكاشير للقالب بنجاح.',
              'data': {},
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        return ResponseBody.fromString('{"success": true, "data": []}', 200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
            initialDateRange: '2026-11-15 — 2026-11-21',
            onFetchAvailableCashiers: () async {
              return [
                {'id': 'csh-99', 'name': 'عبدالمحسن فهد التميمي'},
              ];
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify template displays 'غير معيّن' and 'تعيين كاشير' button
      expect(find.text('غير معيّن'), findsWidgets);
      expect(find.byKey(const Key('btn_assign_tpl-unassigned')), findsWidgets);

      // Tap 'تعيين كاشير'
      await tester.tap(find.byKey(const Key('btn_assign_tpl-unassigned')).first);
      await tester.pumpAndSettle();

      // Bottom sheet is visible
      expect(find.byKey(const Key('txt_dialog_assign_title')), findsOneWidget);
      expect(find.byKey(const Key('tile_cashier_csh-99')), findsOneWidget);

      // Select single-day exception
      await tester.tap(find.byKey(const Key('radio_single_day_exception')));
      await tester.pumpAndSettle();

      // Select cashier
      await tester.tap(find.byKey(const Key('tile_cashier_csh-99')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_confirm_cashier_assignment')));
      await tester.pumpAndSettle();

      // Verify assign-shifts was called via Dio
      expect(recordedAssignReq, isNotNull);
      expect(recordedAssignReq!.method, 'POST');
      expect(
        recordedAssignReq!.uri.toString(),
        'https://erp.assab.sa/api/v1/branch-manager/cashiers/assign-shifts',
      );
      expect(recordedAssignReq!.data['cashier_id'], 'csh-99');
      expect(recordedAssignReq!.data['shift_ids'], ['tpl-unassigned']);
      expect(recordedAssignReq!.data['shift_date'], '2026-11-15');

      // Verify UI updated
      expect(find.text('عبدالمحسن فهد التميمي'), findsOneWidget);
      expect(find.text('جاهز للتعيين / التبديل'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('empty roster response displays clean empty state without falling back to mock fixtures',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final adapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'message': 'OK',
            'data': {
              'branch_id': 'branch-1',
              'start_date': '2026-11-15',
              'end_date': '2026-11-21',
              'templates': [],
              'roster': {},
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
            initialDateRange: '2026-11-15 — 2026-11-21',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify empty state is displayed
      expect(find.byKey(const Key('empty_roster_state')), findsOneWidget);
      expect(find.text('لا توجد قوالب أو ورديات في هذه الفترة'), findsOneWidget);

      // Verify no mock fixtures are rendered
      expect(find.byKey(const Key('card_template_tpl-1')), findsNothing);
      expect(find.byKey(const Key('card_template_tpl-2')), findsNothing);

      expect(tester.takeException(), isNull);
    });

    testWidgets('responsive verification on 820px tablet with zero RenderFlex overflow',
        (tester) async {
      tester.view.physicalSize = const Size(820 * 2.0, 1180 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildTestApp(
          const DatedShiftAssignmentScreen(
            initialTemplates: kTestTemplates,
            initialDateRange: '2026-11-15 — 2026-11-21',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('txt_screen_title')), findsOneWidget);
      expect(find.byKey(const Key('card_template_tpl-1')), findsOneWidget);
      expect(find.byKey(const Key('card_template_tpl-2')), findsOneWidget);

      // Zero RenderFlex overflow on 820px tablet
      expect(tester.takeException(), isNull);
    });

    Future<void> runComprehensiveDatedAssignmentJourney(
      WidgetTester tester, {
      required double width,
      required double height,
    }) async {
      tester.view.physicalSize = Size(width * 2.0, height * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool simulateAvailableError = true;
      bool isPersistedOnServer = false;
      RequestOptions? recordedAssignReq;
      RequestOptions? recordedAvailableReq;

      final adapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (options.path.contains('dated-roster')) {
          final rosterData = <String, dynamic>{
            '2026-11-15_tpl-1': {
              'cashier_shift_id': 'cs-101',
              'cashier_id': 'csh-alpha',
              'cashier_name': 'خالد المنصور',
              'status': 'not_started',
              'can_swap': true,
              'has_financial_evidence': false,
            },
          };
          if (isPersistedOnServer) {
            rosterData['2026-11-16_tpl-1'] = {
              'cashier_shift_id': 'cs-102',
              'cashier_id': 'csh-free',
              'cashier_name': 'سلمان الراشد',
              'status': 'not_started',
              'can_swap': true,
              'has_financial_evidence': false,
            };
          }

          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'branch_id': 'branch-1',
                'start_date': '2026-11-15',
                'end_date': '2026-11-16',
                'templates': [
                  {
                    'id': 'tpl-1',
                    'name': 'وردية الصباح الأولى',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                  {
                    'id': 'tpl-2',
                    'name': 'وردية المساء الثانية',
                    'start_time': '16:00:00',
                    'end_time': '00:00:00',
                  },
                ],
                'roster': rosterData,
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        if (options.path.contains('available-cashiers')) {
          recordedAvailableReq = options;
          if (simulateAvailableError) {
            return ResponseBody.fromString(
              jsonEncode({
                'success': false,
                'message': 'Database connection timeout',
              }),
              500,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }

          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'Available cashiers retrieved successfully',
              'data': [
                {
                  'id': 'csh-busy',
                  'name': 'ياسر القحطاني',
                  'email': 'yasser@example.com',
                  'is_available': false,
                  'disabled': true,
                  'reason_disabled': 'Already assigned to this shift',
                },
                {
                  'id': 'csh-free',
                  'name': 'سلمان الراشد',
                  'email': 'salman@example.com',
                  'is_available': true,
                  'disabled': false,
                  'reason_disabled': null,
                },
              ],
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        if (options.path.contains('assign-shifts')) {
          recordedAssignReq = options;
          isPersistedOnServer = true;
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'Shifts assigned successfully',
              'data': {},
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        return ResponseBody.fromString('{"success": true, "data": []}', 200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
            initialDateRange: '2026-11-15 — 2026-11-16',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after pump');

      // 1. Default view shows only Day 1 (Nov 15) without All/day chips strip
      expect(find.byKey(const Key('chip_day_all')), findsNothing);
      expect(find.byKey(const Key('chip_day_2026-11-15')), findsNothing);
      expect(find.byKey(const Key('chip_day_2026-11-16')), findsNothing);

      // Navigate to empty day (Nov 16) via next-day arrow
      await tester.tap(find.byKey(const Key('btn_next_day')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-16'),
      );
      expect(tester.takeException(), isNull, reason: 'after navigate to next day');

      // On Nov 16, both templates exist with 'غير معيّن' and 'تعيين كاشير'
      expect(find.byKey(const Key('btn_assign_tpl-1')), findsOneWidget);
      expect(find.byKey(const Key('btn_assign_tpl-2')), findsOneWidget);

      // Open unassigned slot for tpl-1
      await tester.ensureVisible(find.byKey(const Key('btn_assign_tpl-1')));
      await tester.tap(find.byKey(const Key('btn_assign_tpl-1')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after open bottom sheet');

      // Bottom sheet is visible
      expect(find.byKey(const Key('txt_dialog_assign_title')), findsOneWidget);

      // Verify query params sent to available-cashiers
      expect(recordedAvailableReq, isNotNull);
      expect(recordedAvailableReq!.queryParameters['template_id'], 'tpl-1');
      expect(recordedAvailableReq!.queryParameters['shift_date'], '2026-11-16');

      // 3. Step 3: Verify error state on failure, retry button, and zero mock fixtures
      expect(
        find.byKey(const Key('txt_error_available_cashiers')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('btn_retry_available_cashiers')),
        findsOneWidget,
      );
      expect(find.text('سعد ناصر الدوسري'), findsNothing);
      expect(find.text('فهد عبدالمحسن العتيبي'), findsNothing);

      // Now disable error and retry
      simulateAvailableError = false;
      await tester.tap(find.byKey(const Key('btn_retry_available_cashiers')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after retry available cashiers');

      // Verify cashier list is scrollable and confirm button is accessible
      expect(find.byKey(const Key('list_available_cashiers')), findsOneWidget);
      expect(
        find.byKey(const Key('btn_confirm_cashier_assignment')),
        findsOneWidget,
      );

      // 2. Step 2: Verify unavailable cashier cannot be selected
      expect(find.byKey(const Key('tile_cashier_csh-busy')), findsOneWidget);
      expect(find.byKey(const Key('tag_unavailable_csh-busy')), findsOneWidget);

      // Tapping busy cashier does not enable confirm button
      await tester.tap(find.byKey(const Key('tile_cashier_csh-busy')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after tap busy cashier');

      final confirmBtnFinder =
          find.byKey(const Key('btn_confirm_cashier_assignment'));
      final confirmBtnWidget = tester.widget<ElevatedButton>(confirmBtnFinder);
      expect(confirmBtnWidget.onPressed, isNull); // disabled!

      // Select single-day exception
      await tester.tap(find.byKey(const Key('radio_single_day_exception')));
      await tester.pumpAndSettle();

      // Select available cashier
      await tester.tap(find.byKey(const Key('tile_cashier_csh-free')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after select available cashier');

      final confirmBtnAfterSelect =
          tester.widget<ElevatedButton>(confirmBtnFinder);
      expect(confirmBtnAfterSelect.onPressed, isNotNull); // enabled!

      // Tap confirm assignment
      await tester.tap(confirmBtnFinder);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after confirm assignment');

      // Verify assign-shifts request was executed
      expect(recordedAssignReq, isNotNull);
      expect(recordedAssignReq!.data['cashier_id'], 'csh-free');
      expect(recordedAssignReq!.data['shift_ids'], ['tpl-1']);
      expect(recordedAssignReq!.data['shift_date'], '2026-11-16');

      // Verify immediate UI update
      expect(find.text('سلمان الراشد'), findsOneWidget);

      // Reload screen via refresh button
      await tester.tap(find.byKey(const Key('btn_refresh_roster')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after refresh roster');

      // Verify persisted state: Salman Al-Rashed still shown on Nov 16 for tpl-1
      expect(find.text('سلمان الراشد'), findsOneWidget);

      // Zero RenderFlex overflow during the entire flow
      expect(tester.takeException(), isNull);
    }

    testWidgets(
      'G4 responsive full user journey: 390px Mobile (empty days, unavailable guard, retry recovery, persistence)',
      (tester) async {
        await runComprehensiveDatedAssignmentJourney(
          tester,
          width: 390,
          height: 844,
        );
      },
    );

    testWidgets(
      'G4 responsive full user journey: 820px Tablet (empty days, unavailable guard, retry recovery, persistence)',
      (tester) async {
        await runComprehensiveDatedAssignmentJourney(
          tester,
          width: 820,
          height: 1180,
        );
      },
    );

    testWidgets('R1 contract: roster as empty array [] parses safely without type error',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final adapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'message': 'OK',
            'data': {
              'branch_id': 'branch-1',
              'start_date': '2026-11-15',
              'end_date': '2026-11-21',
              'templates': [],
              'roster': [], // Array [] from legacy/live endpoint
            },
          }),
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
            initialDateRange: '2026-11-15 — 2026-11-21',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty_roster_state')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('R5: branch manager sets recurring primary cashier with effective date calling roster-assignments',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      RequestOptions? recordedRosterAssignReq;
      Map<String, dynamic>? persistedRosterAssignment;

      final adapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.contains('dated-roster')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'branch_id': 'branch-1',
                'start_date': '2026-11-15',
                'end_date': '2026-11-21',
                'templates': [
                  {
                    'id': 'tpl-unassigned',
                    'name': 'وردية شاغرة بلا كاشير',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                ],
                'roster': {
                  '2026-11-15_tpl-unassigned': {
                    'cashier_id': null,
                    'cashier_name': null,
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-unassigned',
                    'can_swap': false,
                  },
                },
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        if (options.path.contains('roster-assignments')) {
          if (options.method == 'POST') {
            recordedRosterAssignReq = options;
            persistedRosterAssignment = {
              'id': 'ra-1',
              'shift_id': 'tpl-unassigned',
              'cashier_id': 'csh-primary-1',
              'cashier_name': 'الكاشير الأساسي المعتمد',
              'effective_from': '2026-11-15',
            };
            return ResponseBody.fromString(
              jsonEncode({
                'success': true,
                'message': 'تم حفظ التعيين المتكرر بنجاح.',
                'data': persistedRosterAssignment,
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          } else {
            return ResponseBody.fromString(
              jsonEncode({
                'success': true,
                'message': 'OK',
                'data': persistedRosterAssignment != null ? [persistedRosterAssignment] : [],
              }),
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
        }

        return ResponseBody.fromString('{"success": true, "data": []}', 200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
            initialDateRange: '2026-11-15 — 2026-11-21',
            onFetchAvailableCashiers: () async {
              return [
                {'id': 'csh-primary-1', 'name': 'الكاشير الأساسي المعتمد'},
              ];
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap assign cashier button
      await tester.tap(find.byKey(const Key('btn_assign_tpl-unassigned')).first);
      await tester.pumpAndSettle();

      // Recurrence is explicitly selected; the default assigns the dated slot.
      expect(find.byKey(const Key('radio_recurring_assignment')), findsOneWidget);
      await tester.tap(find.byKey(const Key('radio_recurring_assignment')));
      await tester.pumpAndSettle();

      // Select cashier
      await tester.tap(find.byKey(const Key('tile_cashier_csh-primary-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_confirm_cashier_assignment')));
      await tester.pumpAndSettle();

      // Verify POST roster-assignments was called with shift_id, cashier_id, effective_from
      expect(recordedRosterAssignReq, isNotNull);
      expect(recordedRosterAssignReq!.method, 'POST');
      expect(
        recordedRosterAssignReq!.uri.toString(),
        'https://erp.assab.sa/api/v1/branch-manager/cashiers/roster-assignments',
      );
      final assignments = recordedRosterAssignReq!.data['assignments'] as List;
      final firstAssign = assignments.first as Map;
      expect(firstAssign['shift_id'], 'tpl-unassigned');
      expect(firstAssign['cashier_id'], 'csh-primary-1');
      expect(firstAssign['effective_from'], '2026-11-15');

      // Verify UI updated with primary cashier and recurring badge
      expect(find.textContaining('الكاشير الأساسي المعتمد'), findsWidgets);
      expect(find.text('أساسي'), findsNothing);
      expect(find.textContaining('مخطط فقط'), findsWidgets);

      expect(tester.takeException(), isNull);
    });

    testWidgets('R6: default date range derived dynamically from current week when initialDateRange is omitted',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? queriedStart;
      String? queriedEnd;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onFetchRoster: (start, end) async {
              queriedStart = start;
              queriedEnd = end;
              return [];
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final riyadhNow = DateTime.now().toUtc().add(const Duration(hours: 3));
      final expectedSunday = DateTime(
        riyadhNow.year,
        riyadhNow.month,
        riyadhNow.day,
      ).subtract(Duration(days: riyadhNow.weekday % 7));
      final expectedSaturday = expectedSunday.add(const Duration(days: 6));
      final expectedStartStr =
          "${expectedSunday.year}-${expectedSunday.month.toString().padLeft(2, '0')}-${expectedSunday.day.toString().padLeft(2, '0')}";
      final expectedEndStr =
          "${expectedSaturday.year}-${expectedSaturday.month.toString().padLeft(2, '0')}-${expectedSaturday.day.toString().padLeft(2, '0')}";
      final expectedTodayStr =
          "${riyadhNow.year}-${riyadhNow.month.toString().padLeft(2, '0')}-${riyadhNow.day.toString().padLeft(2, '0')}";

      expect(queriedStart, expectedStartStr);
      expect(queriedEnd, expectedEndStr);
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains(expectedTodayStr),
      );
      expect(find.byKey(const Key('badge_today')), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('R7: missing Dio and callbacks displays explicit error and rejects fake local mutations',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        _buildTestApp(
          const DatedShiftAssignmentScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Explicit error banner displayed
      expect(
        find.textContaining('تعذر الاتصال: لم يتم العثور على مزود خدمة API.'),
        findsOneWidget,
      );

      // Empty state rendered - no fake mock templates in production path
      expect(find.byKey(const Key('empty_roster_state')), findsOneWidget);
      expect(find.byKey(const Key('card_template_tpl-1')), findsNothing);

      expect(tester.takeException(), isNull);
    });

    testWidgets('R6 Acceptance 1: Screen opened from manager button adopts server-driven scheduling calendar even with differing device timezone',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      Map<String, dynamic>? capturedQueryParams;
      final dio = Dio();
      dio.httpClientAdapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (options.path.contains('dated-roster')) {
          capturedQueryParams = options.queryParameters;
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'branch_id': 'branch-1',
                'start_date': '2026-11-15',
                'end_date': '2026-11-21',
                'scheduling_calendar': {
                  'today': '2026-11-15',
                  'timezone': 'Asia/Riyadh',
                  'week_start': 0,
                  'default_start_date': '2026-11-15',
                  'default_end_date': '2026-11-21',
                },
                'templates': [
                  {
                    'id': 'tpl-1',
                    'name': 'وردية الصباح الأولى',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                ],
                'roster': {},
              },
            }),
            200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }
        return ResponseBody.fromString(
          jsonEncode({'success': true, 'data': []}),
          200,
          headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
        );
      });

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(dio: dio),
        ),
      );
      await tester.pumpAndSettle();

      expect(capturedQueryParams, isEmpty);
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-15'),
      );
      expect(find.byKey(const Key('badge_today')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('R6 Acceptance 2: Week start and year boundary transitions follow server calendar across 2026-12-27 -> 2027-01-03',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final List<String> loadedRanges = [];

      // Start on week covering year boundary: 2026-12-27 (Sunday) to 2027-01-02 (Saturday)
      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            initialDateRange: '2026-12-27 — 2027-01-02',
            onFetchRoster: (start, end) async {
              loadedRanges.add('$start — $end');
              return [];
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(loadedRanges.first, '2026-12-27 — 2027-01-02');
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-12-27'),
      );

      // Step backwards across boundary into 2026-12-26 (loads 2026-12-20 — 2026-12-26)
      await tester.tap(find.byKey(const Key('btn_prev_day')));
      await tester.pumpAndSettle();
      expect(loadedRanges.last, '2026-12-20 — 2026-12-26');
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-12-26'),
      );

      // Step forward back to 2026-12-27, then 7 more days across year boundary into 2027-01-03
      for (var i = 0; i < 8; i++) {
        await tester.tap(find.byKey(const Key('btn_next_day')));
        await tester.pumpAndSettle();
      }

      expect(loadedRanges.last, '2027-01-03 — 2027-01-09');
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2027-01-03'),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('R6 Acceptance 3: Open shift from Saturday remains in its day while scheduling screen opens on current week',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRouteName.datedShiftAssignmentScreen),
      );
      expect(route, isA<MaterialPageRoute>());
      final widget = (route as MaterialPageRoute).builder(_FakeBuildContext()) as DatedShiftAssignmentScreen;
      expect(widget.branchBusinessDate, isNull);

      final dio = Dio();
      dio.httpClientAdapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (options.path.contains('dated-roster')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'branch_id': 'branch-1',
                'start_date': '2026-11-15',
                'end_date': '2026-11-21',
                'scheduling_calendar': {
                  'today': '2026-11-15',
                  'timezone': 'Asia/Riyadh',
                  'week_start': 0,
                  'default_start_date': '2026-11-15',
                  'default_end_date': '2026-11-21',
                },
                'templates': [
                  {
                    'id': 'tpl-1',
                    'name': 'وردية الصباح الأولى',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                ],
                'roster': {},
              },
            }),
            200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }
        return ResponseBody.fromString(
          jsonEncode({'success': true, 'data': []}),
          200,
          headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
        );
      });

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(dio: dio),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-15'),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('R6 Acceptance 4: Manual week selection preserved across refresh, and retry succeeds after network restoration',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool simulateFailure = false;
      final List<Map<String, dynamic>> requestedQueries = [];

      final dio = Dio();
      dio.httpClientAdapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (options.path.contains('dated-roster')) {
          requestedQueries.add(Map<String, dynamic>.from(options.queryParameters));
          if (simulateFailure) {
            return ResponseBody.fromString(
              jsonEncode({'success': false, 'message': 'Network timeout'}),
              500,
              headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
            );
          }
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'message': 'OK',
              'data': {
                'branch_id': 'branch-1',
                'start_date': options.queryParameters['start_date'] ?? '2026-11-15',
                'end_date': options.queryParameters['end_date'] ?? '2026-11-21',
                'scheduling_calendar': {
                  'today': '2026-11-21',
                  'timezone': 'Asia/Riyadh',
                  'week_start': 0,
                  'default_start_date': '2026-11-15',
                  'default_end_date': '2026-11-21',
                },
                'templates': [
                  {
                    'id': 'tpl-1',
                    'name': 'وردية الصباح الأولى',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                ],
                'roster': {},
              },
            }),
            200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }
        return ResponseBody.fromString(
          jsonEncode({'success': true, 'data': []}),
          200,
          headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
        );
      });

      // 1. Initial load opens cleanly on server Today (2026-11-21)
      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(dio: dio),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-21'),
      );

      // 2. Manager steps to next day (2026-11-22), crossing into next week (2026-11-22 — 2026-11-28)
      await tester.tap(find.byKey(const Key('btn_next_day')));
      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-22'),
      );
      expect(requestedQueries.last['start_date'], '2026-11-22');
      expect(requestedQueries.last['end_date'], '2026-11-28');

      // 3. Network fails during refresh
      simulateFailure = true;
      await tester.tap(find.byKey(const Key('btn_refresh_roster')));
      await tester.pumpAndSettle();

      // Selection is preserved even on error
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-22'),
      );
      expect(find.textContaining('تعذر تحميل التعيينات من الخادم'), findsOneWidget);
      // Crucial: Error state and Retry button are shown, NOT the empty templates state
      expect(find.byKey(const Key('error_roster_state')), findsOneWidget);
      expect(find.byKey(const Key('btn_retry_roster')), findsOneWidget);
      expect(find.byKey(const Key('empty_roster_state')), findsNothing);

      // 4. Network restored and manager taps the Retry button directly
      simulateFailure = false;
      await tester.tap(find.byKey(const Key('btn_retry_roster')));
      await tester.pumpAndSettle();

      // Verified reload succeeded with the exact preserved dates
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
        contains('2026-11-22'),
      );
      expect(requestedQueries.last['start_date'], '2026-11-22');
      expect(requestedQueries.last['end_date'], '2026-11-28');
      expect(find.textContaining('تعذر تحميل التعيينات من الخادم'), findsNothing);
      expect(find.byKey(const Key('error_roster_state')), findsNothing);

      expect(tester.takeException(), isNull);
    });

    testWidgets('R6 Acceptance 5: Empty state displayed ONLY after successful and empty response, never during error',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      bool simulateFailure = false;

      final dio = Dio(BaseOptions(baseUrl: 'https://test.assab.com/api/v1/'));
      dio.httpClientAdapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (simulateFailure) {
          return ResponseBody.fromString(
            jsonEncode({'message': 'Server down'}),
            500,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }
        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'data': {
              'start_date': '2026-11-15',
              'end_date': '2026-11-21',
              'templates': [], // Empty templates
              'roster': {},
            },
          }),
          200,
          headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
        );
      });

      // 1. Successful response with empty templates -> empty_roster_state MUST be visible
      await tester.pumpWidget(_buildTestApp(DatedShiftAssignmentScreen(dio: dio)));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty_roster_state')), findsOneWidget);
      expect(find.text('لا توجد قوالب أو ورديات في هذه الفترة'), findsOneWidget);
      expect(find.byKey(const Key('error_roster_state')), findsNothing);

      // 2. Failure occurs -> error_roster_state MUST be visible, empty_roster_state MUST be hidden
      simulateFailure = true;
      await tester.tap(find.byKey(const Key('btn_refresh_roster')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('error_roster_state')), findsOneWidget);
      expect(find.byKey(const Key('btn_retry_roster')), findsOneWidget);
      expect(find.byKey(const Key('empty_roster_state')), findsNothing);
      expect(find.text('لا توجد قوالب أو ورديات في هذه الفترة'), findsNothing);

      expect(tester.takeException(), isNull);
    });

    testWidgets('R6 Acceptance 6: Backward compatibility fallback with older backend requiring start_date and end_date (HTTP 422)',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final List<RequestOptions> recordedRequests = [];

      final dio = Dio(BaseOptions(baseUrl: 'https://test.assab.com/api/v1/'));
      dio.httpClientAdapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        recordedRequests.add(options);

        // Older backend rejects empty params on dated-roster with 422
        if (options.path.contains('dated-roster') && options.queryParameters.isEmpty) {
          return ResponseBody.fromString(
            jsonEncode({
              'message': 'The start date field is required. (and 1 more error)',
              'errors': {
                'start_date': ['The start date field is required.'],
                'end_date': ['The end date field is required.'],
              },
            }),
            422,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }

        // When retried with start_date & end_date, it succeeds
        return ResponseBody.fromString(
          jsonEncode({
            'success': true,
            'data': {
              'start_date': options.queryParameters['start_date'],
              'end_date': options.queryParameters['end_date'],
              'templates': [
                {
                  'id': 'tpl-compat-1',
                  'name': 'قالب توافقي',
                  'start_time': '08:00:00',
                  'end_time': '16:00:00',
                },
              ],
              'roster': {},
            },
          }),
          200,
          headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
        );
      });

      await tester.pumpWidget(_buildTestApp(DatedShiftAssignmentScreen(dio: dio)));
      await tester.pumpAndSettle();

      final rosterRequests = recordedRequests.where((r) => r.path.contains('dated-roster')).toList();
      // Verified: 2 dated-roster queries were sent: 1st empty, 2nd with start_date/end_date fallback
      expect(rosterRequests.length, 2);
      expect(rosterRequests[0].queryParameters.isEmpty, isTrue);
      expect(rosterRequests[1].queryParameters.containsKey('start_date'), isTrue);
      expect(rosterRequests[1].queryParameters.containsKey('end_date'), isTrue);

      // Successfully rendered template from fallback without error
      expect(find.text('قالب توافقي'), findsWidgets);
      expect(find.byKey(const Key('error_roster_state')), findsNothing);

      expect(tester.takeException(), isNull);
    });

    testWidgets('Session 7 Acceptance: Schedule source metadata displays origin in governance notice', (WidgetTester tester) async {
      final dio = Dio();
      dio.httpClientAdapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.endsWith('roster-assignments')) {
          return ResponseBody.fromString('{"data": []}', 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
        }

        if (options.path.contains('dated-roster')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'data': {
                'branch_id': 'branch-malqa',
                'branch_name': 'فرع الملقا – الرياض',
                'start_date': '2026-11-15',
                'end_date': '2026-11-21',
                'schedule_source': {
                  'has_own_config': true,
                  'type': 'branch',
                  'label_ar': 'إعداد خاص بالفرع',
                  'owner_name': 'فرع الملقا – الرياض',
                },
                'templates': [
                  {
                    'id': 'tpl-1',
                    'name': 'الوردية الأولى',
                    'start_time': '08:00:00',
                    'end_time': '10:00:00',
                  },
                ],
                'roster': {},
              },
            }),
            200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }
        return ResponseBody.fromString(jsonEncode({'success': true, 'data': []}), 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
      });

      await tester.pumpWidget(_buildTestApp(DatedShiftAssignmentScreen(dio: dio)));
      await tester.pumpAndSettle();

      // Verified: Governance notice includes the schedule source origin
      expect(find.text('إعداد القوالب والمواعيد يظل ضمن صلاحيات المحاسب (إعداد خاص بالفرع (فرع الملقا – الرياض))'), findsOneWidget);
    });

    testWidgets('Session 7 Acceptance: Recurring roster assignment handles 500 error envelope safely without generic network error', (WidgetTester tester) async {
      final dio = Dio();
      dio.httpClientAdapter = TestHttpAdapter(onFetch: (options) async {
        if (options.path.contains('roster-assignments') && options.method == 'POST') {
          return ResponseBody.fromString(
            jsonEncode({
              'error': {
                'code': 'SERVER_ERROR',
                'message': 'Table branch_shift_roster_assignments does not exist',
                'messageAr': 'جدول التعيينات المتكررة غير مرحل على قاعدة البيانات. يرجى تطبيق الترحيل البرمجي على الخادم.',
              },
            }),
            500,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }
        if (options.path.contains('dated-roster')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'data': {
                'start_date': '2026-11-15',
                'end_date': '2026-11-21',
                'templates': [
                  {
                    'id': 'tpl-rec-1',
                    'name': 'الوردية الأولى',
                    'start_time': '08:00:00',
                    'end_time': '10:00:00',
                  },
                ],
                'roster': {},
              },
            }),
            200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }
        if (options.path.contains('available-cashiers')) {
          return ResponseBody.fromString(
            jsonEncode({
              'success': true,
              'data': [
                {'id': 'c-1', 'name': 'يوسف الدوسري'},
              ],
            }),
            200,
            headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
          );
        }
        return ResponseBody.fromString(jsonEncode({'success': true, 'data': []}), 200, headers: {Headers.contentTypeHeader: [Headers.jsonContentType]});
      });

      await tester.pumpWidget(_buildTestApp(DatedShiftAssignmentScreen(dio: dio)));
      await tester.pumpAndSettle();

      // Open assign dialog
      final assignBtn = find.byKey(const Key('btn_assign_tpl-rec-1')).first;
      expect(assignBtn, findsOneWidget);
      await tester.tap(assignBtn);
      await tester.pumpAndSettle();

      // Select cashier
      final cashierTile = find.byKey(const Key('tile_cashier_c-1'));
      expect(cashierTile, findsOneWidget);
      await tester.tap(cashierTile);
      await tester.pumpAndSettle();

      // Tap confirm button
      await tester.tap(find.byKey(const Key('radio_recurring_assignment')));
      await tester.pumpAndSettle();
      final confirmBtn = find.byKey(const Key('btn_confirm_cashier_assignment'));
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      // Verified: Error message extracted from server envelope instead of generic connection error
      expect(find.textContaining('جدول التعيينات المتكررة غير مرحل على قاعدة البيانات'), findsOneWidget);
      expect(find.text('تعذر حفظ التعيين المتكرر: خطأ في الاتصال بالخادم.'), findsNothing);
    });

    testWidgets(
      'Branch manager appears at top of assign modal via /cashiers/all and can self-assign single day',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        RequestOptions? recordedAssignReq;
        bool managerAssigned = false;

        final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
        dio.httpClientAdapter = TestHttpAdapter(
          onFetch: (options) async {
            if (options.path.endsWith('roster-assignments')) {
              return ResponseBody.fromString(
                jsonEncode({'success': true, 'data': []}),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            if (options.path.contains('dated-roster')) {
              return ResponseBody.fromString(
                jsonEncode({
                  'success': true,
                  'data': {
                    'branch_id': 'branch-1',
                    'start_date': '2026-11-15',
                    'end_date': '2026-11-15',
                    'templates': [
                      {
                        'id': 'tpl-self-1',
                        'name': 'وردية الصباح',
                        'start_time': '08:00:00',
                        'end_time': '16:00:00',
                      },
                    ],
                    'roster': managerAssigned
                        ? {
                            '2026-11-15_tpl-self-1': {
                              'cashier_shift_id': 'shift-self-1',
                              'cashier_id': 'bm-self-1',
                              'cashier_name': 'طارق المنصور',
                              'status': 'not_started',
                              'shift_date': '2026-11-15',
                              'shift_id': 'tpl-self-1',
                              'can_swap': true,
                            },
                          }
                        : {},
                  },
                }),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            if (options.path.contains('available-cashiers')) {
              return ResponseBody.fromString(
                jsonEncode({
                  'success': true,
                  'data': [
                    {'id': 'c-1', 'name': 'يوسف الدوسري'},
                  ],
                }),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            if (options.path.endsWith('cashiers/all')) {
              return ResponseBody.fromString(
                jsonEncode({
                  'success': true,
                  'data': {
                    'branch_managers': [
                      {
                        'id': 'bm-self-1',
                        'name': 'طارق المنصور',
                        'phone': '0550001122',
                      },
                    ],
                    'cashiers': [
                      {'id': 'c-1', 'name': 'يوسف الدوسري'},
                    ],
                  },
                }),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            if (options.path.contains('assign-shifts')) {
              recordedAssignReq = options;
              managerAssigned = true;
              return ResponseBody.fromString(
                jsonEncode({'success': true, 'data': {}}),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            return ResponseBody.fromString(
              jsonEncode({'success': true, 'data': []}),
              200,
              headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
            );
          },
        );

        await tester.pumpWidget(
          _buildTestApp(
            DatedShiftAssignmentScreen(
              dio: dio,
              initialDateRange: '2026-11-15 — 2026-11-15',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('btn_assign_tpl-self-1')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('tile_cashier_bm-self-1')), findsOneWidget);
        expect(find.byKey(const Key('tag_branch_manager_bm-self-1')), findsOneWidget);
        expect(find.text('طارق المنصور (مدير الفرع)'), findsOneWidget);
        expect(find.byKey(const Key('tile_cashier_c-1')), findsOneWidget);

        await tester.tap(find.byKey(const Key('tile_cashier_bm-self-1')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('btn_confirm_cashier_assignment')));
        await tester.pumpAndSettle();

        expect(recordedAssignReq, isNotNull);
        expect(recordedAssignReq!.data['cashier_id'], 'bm-self-1');
        expect(recordedAssignReq!.data['shift_ids'], ['tpl-self-1']);
        expect(recordedAssignReq!.data['shift_date'], '2026-11-15');
        expect(find.text('طارق المنصور'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Branch manager from available-cashiers meta.branch_manager can be selected for recurring roster assignment',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);

        RequestOptions? recordedRosterPost;

        final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
        dio.httpClientAdapter = TestHttpAdapter(
          onFetch: (options) async {
            if (options.path.endsWith('roster-assignments') &&
                options.method == 'POST') {
              recordedRosterPost = options;
              return ResponseBody.fromString(
                jsonEncode({'success': true, 'data': []}),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            if (options.path.endsWith('roster-assignments')) {
              return ResponseBody.fromString(
                jsonEncode({'success': true, 'data': []}),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            if (options.path.contains('dated-roster')) {
              return ResponseBody.fromString(
                jsonEncode({
                  'success': true,
                  'data': {
                    'branch_id': 'branch-1',
                    'start_date': '2026-11-15',
                    'end_date': '2026-11-15',
                    'templates': [
                      {
                        'id': 'tpl-self-rec',
                        'name': 'وردية المساء',
                        'start_time': '16:00:00',
                        'end_time': '00:00:00',
                      },
                    ],
                    'roster': {},
                  },
                }),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            if (options.path.contains('available-cashiers')) {
              return ResponseBody.fromString(
                jsonEncode({
                  'success': true,
                  'data': [
                    {'id': 'c-1', 'name': 'يوسف الدوسري'},
                  ],
                  'meta': {
                    'branch_manager': {
                      'id': 'bm-meta-1',
                      'name': 'فهد مدير الفرع',
                      'is_available': true,
                      'disabled': false,
                      'is_branch_manager': true,
                    },
                  },
                }),
                200,
                headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
              );
            }
            return ResponseBody.fromString(
              jsonEncode({'success': true, 'data': []}),
              200,
              headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
            );
          },
        );

        await tester.pumpWidget(
          _buildTestApp(
            DatedShiftAssignmentScreen(
              dio: dio,
              initialDateRange: '2026-11-15 — 2026-11-15',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('btn_assign_tpl-self-rec')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('tile_cashier_bm-meta-1')), findsOneWidget);
        expect(find.byKey(const Key('tag_branch_manager_bm-meta-1')), findsOneWidget);

        await tester.tap(find.byKey(const Key('radio_recurring_assignment')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('tile_cashier_bm-meta-1')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('btn_confirm_cashier_assignment')));
        await tester.pumpAndSettle();

        expect(recordedRosterPost, isNotNull);
        final assignments = recordedRosterPost!.data['assignments'] as List;
        expect(assignments.first['cashier_id'], 'bm-meta-1');
        expect(assignments.first['shift_id'], 'tpl-self-rec');
        expect(tester.takeException(), isNull);
      },
    );

    for (final shiftCount in [2, 3]) {
      testWidgets(
        'UX Default Today Only ($shiftCount shifts): opens directly on today without All or day tabs, supports day stepping and jump to today',
        (WidgetTester tester) async {
          tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);

          final templates = List.generate(
            shiftCount,
            (i) => {
              'id': 'tpl-${i + 1}',
              'name': i == 0
                  ? 'الصباحية'
                  : (i == 1 ? 'المسائية' : 'الليلية'),
              'start_time': i == 0
                  ? '08:00:00'
                  : (i == 1 ? '16:00:00' : '00:00:00'),
              'end_time': i == 0
                  ? '16:00:00'
                  : (i == 1 ? '00:00:00' : '08:00:00'),
            },
          );

          final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
          dio.httpClientAdapter = TestHttpAdapter(
            onFetch: (options) async {
              if (options.path.endsWith('roster-assignments')) {
                return ResponseBody.fromString(
                  jsonEncode({'success': true, 'data': []}),
                  200,
                  headers: {
                    Headers.contentTypeHeader: [Headers.jsonContentType],
                  },
                );
              }
              if (options.path.contains('dated-roster')) {
                return ResponseBody.fromString(
                  jsonEncode({
                    'success': true,
                    'data': {
                      'branch_id': 'branch-1',
                      'start_date': '2026-11-15',
                      'end_date': '2026-11-21',
                      'scheduling_calendar': {
                        'today': '2026-11-20',
                        'timezone': 'Asia/Riyadh',
                        'week_start': 0,
                        'default_start_date': '2026-11-15',
                        'default_end_date': '2026-11-21',
                      },
                      'templates': templates,
                      'roster': {
                        '2026-11-20_tpl-1': {
                          'cashier_shift_id': 'cs-today-1',
                          'cashier_id': 'c-today',
                          'cashier_name': 'كاشير اليوم 20',
                          'status': 'not_started',
                          'can_swap': true,
                        },
                        '2026-11-21_tpl-1': {
                          'cashier_shift_id': 'cs-tom-1',
                          'cashier_id': 'c-tom',
                          'cashier_name': 'كاشير الغد 21',
                          'status': 'not_started',
                          'can_swap': true,
                        },
                      },
                    },
                  }),
                  200,
                  headers: {
                    Headers.contentTypeHeader: [Headers.jsonContentType],
                  },
                );
              }
              return ResponseBody.fromString(
                jsonEncode({'success': true, 'data': []}),
                200,
                headers: {
                  Headers.contentTypeHeader: [Headers.jsonContentType],
                },
              );
            },
          );

          await tester.pumpWidget(
            _buildTestApp(DatedShiftAssignmentScreen(dio: dio)),
          );
          await tester.pumpAndSettle();

          // No legacy All chip or horizontal day filter tabs
          expect(find.byKey(const Key('chip_day_all')), findsNothing);
          expect(find.byKey(const Key('chip_day_2026-11-15')), findsNothing);
          expect(find.byKey(const Key('chip_day_2026-11-20')), findsNothing);

          // Opens directly on Today (2026-11-20, Friday) with Today badge
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
            'الجمعة، 2026-11-20',
          );
          expect(find.byKey(const Key('badge_today')), findsOneWidget);
          expect(find.byKey(const Key('btn_jump_today')), findsNothing);
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_day_shift_count'))).data,
            shiftCount == 2 ? 'ورديتان' : '3 ورديات',
          );

          // Shows ONLY Today's 2 or 3 shift cards (no Nov 21 cards mixed in)
          expect(find.byKey(const Key('card_template_tpl-1')), findsOneWidget);
          expect(find.byKey(const Key('card_template_tpl-2')), findsOneWidget);
          if (shiftCount == 3) {
            expect(find.byKey(const Key('card_template_tpl-3')), findsOneWidget);
          }
          expect(find.text('كاشير اليوم 20'), findsOneWidget);
          expect(find.text('كاشير الغد 21'), findsNothing);

          // Navigate to tomorrow (2026-11-21)
          await tester.tap(find.byKey(const Key('btn_next_day')));
          await tester.pumpAndSettle();
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
            'السبت، 2026-11-21',
          );
          expect(find.byKey(const Key('badge_today')), findsNothing);
          expect(find.byKey(const Key('btn_jump_today')), findsOneWidget);
          expect(find.text('كاشير اليوم 20'), findsNothing);
          expect(find.text('كاشير الغد 21'), findsOneWidget);

          // Jump straight back to Today
          await tester.tap(find.byKey(const Key('btn_jump_today')));
          await tester.pumpAndSettle();
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_selected_date'))).data,
            'الجمعة، 2026-11-20',
          );
          expect(find.byKey(const Key('badge_today')), findsOneWidget);
          expect(find.text('كاشير اليوم 20'), findsOneWidget);

          expect(tester.takeException(), isNull);
        },
      );
    }

    for (final width in [360.0, 390.0, 820.0]) {
      testWidgets(
        'UX Modal Recurring Calendar (${width.toInt()}px): date pickers, presets, clear button, bounded vs open payload, and zero overflow',
        (WidgetTester tester) async {
          tester.view.physicalSize = Size(width * 2.0, (width == 820.0 ? 1180.0 : 800.0) * 2.0);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);

          final List<Map<String, dynamic>> postedAssignments = [];
          List<Map<String, dynamic>> persistedRecurring = [];

          final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
          dio.httpClientAdapter = TestHttpAdapter(
            onFetch: (options) async {
              if (options.path.endsWith('roster-assignments') &&
                  options.method == 'POST') {
                final list = List<Map<String, dynamic>>.from(
                  (options.data['assignments'] as List).map(
                    (e) => Map<String, dynamic>.from(e as Map),
                  ),
                );
                postedAssignments.addAll(list);
                persistedRecurring = list
                    .map(
                      (a) => {
                        'shift_id': a['shift_id'],
                        'cashier_id': a['cashier_id'],
                        'cashier_name': 'سعد العتيبي',
                        'effective_from': a['effective_from'],
                        if (a.containsKey('effective_to'))
                          'effective_to': a['effective_to'],
                      },
                    )
                    .toList();
                return ResponseBody.fromString(
                  jsonEncode({'success': true, 'data': persistedRecurring}),
                  200,
                  headers: {
                    Headers.contentTypeHeader: [Headers.jsonContentType],
                  },
                );
              }
              if (options.path.endsWith('roster-assignments')) {
                return ResponseBody.fromString(
                  jsonEncode({'success': true, 'data': persistedRecurring}),
                  200,
                  headers: {
                    Headers.contentTypeHeader: [Headers.jsonContentType],
                  },
                );
              }
              if (options.path.contains('dated-roster')) {
                return ResponseBody.fromString(
                  jsonEncode({
                    'success': true,
                    'data': {
                      'branch_id': 'branch-1',
                      'start_date': '2026-11-20',
                      'end_date': '2026-11-26',
                      'templates': [
                        {
                          'id': 'tpl-cal-1',
                          'name': 'الوردية الأولى',
                          'start_time': '08:00:00',
                          'end_time': '16:00:00',
                        },
                      ],
                      'roster': {},
                    },
                  }),
                  200,
                  headers: {
                    Headers.contentTypeHeader: [Headers.jsonContentType],
                  },
                );
              }
              if (options.path.contains('available-cashiers')) {
                return ResponseBody.fromString(
                  jsonEncode({
                    'success': true,
                    'data': [
                      {'id': 'c-cal-1', 'name': 'سعد العتيبي'},
                    ],
                  }),
                  200,
                  headers: {
                    Headers.contentTypeHeader: [Headers.jsonContentType],
                  },
                );
              }
              return ResponseBody.fromString(
                jsonEncode({'success': true, 'data': []}),
                200,
                headers: {
                  Headers.contentTypeHeader: [Headers.jsonContentType],
                },
              );
            },
          );

          await tester.pumpWidget(
            _buildTestApp(
              DatedShiftAssignmentScreen(
                dio: dio,
                initialDateRange: '2026-11-20 — 2026-11-26',
              ),
            ),
          );
          await tester.pumpAndSettle();

          // 1. Open assignment modal
          await tester.tap(find.byKey(const Key('btn_assign_tpl-cal-1')));
          await tester.pumpAndSettle();
          expect(find.byKey(const Key('btn_pick_effective_from')), findsNothing);

          // 2. Switch to recurring assignment -> calendar panel renders with zero overflow
          await tester.tap(find.byKey(const Key('radio_recurring_assignment')));
          await tester.pumpAndSettle();

          expect(find.byKey(const Key('btn_pick_effective_from')), findsOneWidget);
          expect(find.byKey(const Key('btn_pick_effective_to')), findsOneWidget);
          expect(find.byKey(const Key('chip_recurring_open')), findsOneWidget);
          expect(find.byKey(const Key('chip_recurring_week')), findsOneWidget);
          expect(find.byKey(const Key('chip_recurring_two_weeks')), findsOneWidget);
          expect(find.byKey(const Key('chip_recurring_month')), findsOneWidget);
          expect(find.byKey(const Key('btn_pick_recurring_range')), findsOneWidget);
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_effective_from_value'))).data,
            '2026-11-20',
          );
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_effective_to_value'))).data,
            'مفتوح (مستمر)',
          );
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_recurring_summary'))).data,
            'سارٍ تلقائياً من 2026-11-20 (مستمر بدون تاريخ نهاية)',
          );

          // 3. Change start date via showDatePicker to 2026-11-22
          await tester.tap(find.byKey(const Key('btn_pick_effective_from')));
          await tester.pumpAndSettle();
          expect(find.byType(DatePickerDialog), findsOneWidget);
          await tester.tap(find.text('22').last);
          final okLabel = MaterialLocalizations.of(
            tester.element(find.byType(DatePickerDialog)),
          ).okButtonLabel;
          await tester.tap(find.text(okLabel).last);
          await tester.pumpAndSettle();
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_effective_from_value'))).data,
            '2026-11-22',
          );

          // 4. Tap "أسبوع" quick preset -> 2026-11-22 .. 2026-11-28 (7 أيام)
          await tester.ensureVisible(find.byKey(const Key('chip_recurring_week')));
          await tester.tap(find.byKey(const Key('chip_recurring_week')));
          await tester.pumpAndSettle();
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_effective_to_value'))).data,
            '2026-11-28',
          );
          expect(find.byKey(const Key('btn_clear_effective_to')), findsOneWidget);
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_recurring_summary'))).data,
            'سارٍ تلقائياً من 2026-11-22 حتى 2026-11-28 (7 أيام)',
          );

          // 5. Clear button resets to open-ended, then pick custom end date via showDatePicker (25 -> 2026-11-25)
          await tester.tap(find.byKey(const Key('btn_clear_effective_to')));
          await tester.pumpAndSettle();
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_effective_to_value'))).data,
            'مفتوح (مستمر)',
          );
          await tester.tap(find.byKey(const Key('btn_pick_effective_to')));
          await tester.pumpAndSettle();
          expect(find.byType(DatePickerDialog), findsOneWidget);
          await tester.tap(find.text('25').last);
          final okToLabel = MaterialLocalizations.of(
            tester.element(find.byType(DatePickerDialog)),
          ).okButtonLabel;
          await tester.tap(find.text(okToLabel).last);
          await tester.pumpAndSettle();
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_effective_to_value'))).data,
            '2026-11-25',
          );
          expect(
            tester.widget<Text>(find.byKey(const Key('txt_recurring_summary'))).data,
            'سارٍ تلقائياً من 2026-11-22 حتى 2026-11-25 (4 أيام)',
          );

          // 6. Select cashier & confirm bounded recurring assignment
          await tester.ensureVisible(find.byKey(const Key('tile_cashier_c-cal-1')));
          await tester.tap(find.byKey(const Key('tile_cashier_c-cal-1')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('btn_confirm_cashier_assignment')));
          await tester.pumpAndSettle();

          expect(postedAssignments.last['effective_from'], '2026-11-22');
          expect(postedAssignments.last['effective_to'], '2026-11-25');

          // Navigate to 2026-11-22 to see primary range rendered on card
          await tester.tap(find.byKey(const Key('btn_next_day')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('btn_next_day')));
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<Text>(find.byKey(const Key('txt_primary_cashier_tpl-cal-1')))
                .data,
            'سعد العتيبي (من 2026-11-22 إلى 2026-11-25)',
          );

          // 7. Reopen modal, switch to recurring, select "مفتوح" preset -> omits effective_to
          await tester.tap(find.byKey(const Key('btn_assign_tpl-cal-1')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('radio_recurring_assignment')));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byKey(const Key('chip_recurring_week')));
          await tester.tap(find.byKey(const Key('chip_recurring_week')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('chip_recurring_open')));
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.byKey(const Key('tile_cashier_c-cal-1')));
          await tester.tap(find.byKey(const Key('tile_cashier_c-cal-1')));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('btn_confirm_cashier_assignment')));
          await tester.pumpAndSettle();

          expect(postedAssignments.last['effective_from'], '2026-11-22');
          expect(postedAssignments.last.containsKey('effective_to'), isFalse);
          expect(tester.takeException(), isNull);
        },
      );
    }
  });
}

class _FakeBuildContext implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
