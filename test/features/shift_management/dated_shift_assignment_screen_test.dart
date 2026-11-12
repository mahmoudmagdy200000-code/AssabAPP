import 'dart:convert';
import 'dart:typed_data';

import 'package:assab/core/responsive/app_responsive.dart';
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

      // 2. Verify date range
      expect(find.byKey(const Key('txt_date_range')), findsOneWidget);
      expect(find.text('2026-11-15 — 2026-11-21'), findsOneWidget);

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
      expect(find.text('وردية بدأت بالفعل'), findsOneWidget);
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
          cashierId: 'csh-1',
          cashierName: 'محمد أحمد السعيد',
          status: 'not_started',
        ),
        const DatedTemplateSlot(
          templateId: 'tpl-2',
          templateName: 'وردية المساء الثانية',
          startTime: '16:00',
          endTime: '00:00',
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

    testWidgets('date range navigation buttons update range and trigger reload',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? requestedStart;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            onFetchRoster: (start, end) async {
              requestedStart = start;
              return [];
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(requestedStart, '2026-11-15');

      // Click next week button
      await tester.tap(find.byKey(const Key('btn_next_week')));
      await tester.pumpAndSettle();

      expect(requestedStart, '2026-11-22');
      expect(find.textContaining('2026-11-22'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('API relative paths: Dio request URLs, methods, and parameters match app contract',
        (tester) async {
      tester.view.physicalSize = const Size(390 * 2.0, 844 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

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
                    'cashier_id': 'csh-1',
                    'cashier_name': 'محمد أحمد السعيد',
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-1',
                    'can_swap': true,
                  },
                  '2026-11-15_tpl-2': {
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

        return ResponseBody.fromString('{"success": true}', 200);
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(dio: dio),
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
                    'cashier_id': 'csh-1',
                    'cashier_name': 'كاشير يوم 15 قالب 1',
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-1',
                    'can_swap': true,
                  },
                  '2026-11-15_tpl-2': {
                    'cashier_id': 'csh-2',
                    'cashier_name': 'كاشير يوم 15 قالب 2',
                    'status': 'not_started',
                    'shift_date': '2026-11-15',
                    'shift_id': 'tpl-2',
                    'can_swap': true,
                  },
                  '2026-11-16_tpl-1': {
                    'cashier_id': 'csh-3',
                    'cashier_name': 'كاشير يوم 16 قالب 1',
                    'status': 'not_started',
                    'shift_date': '2026-11-16',
                    'shift_id': 'tpl-1',
                    'can_swap': true,
                  },
                  '2026-11-16_tpl-2': {
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

        return ResponseBody.fromString('{"success": true}', 200);
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(dio: dio),
        ),
      );
      await tester.pumpAndSettle();

      // Verify day chips are rendered for both days
      expect(find.byKey(const Key('chip_day_2026-11-15')), findsOneWidget);
      expect(find.byKey(const Key('chip_day_2026-11-16')), findsOneWidget);

      // Select Day 2 (2026-11-16)
      await tester.ensureVisible(find.byKey(const Key('chip_day_2026-11-16')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('chip_day_2026-11-16')));
      await tester.pumpAndSettle();

      // Verify day 2 cashier names are visible
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

        if (options.path.contains('assign-shifts')) {
          recordedAssignReq = options;
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

        return ResponseBody.fromString('{"success": true}', 200);
      });

      final dio = Dio(BaseOptions(baseUrl: 'https://erp.assab.sa/api/v1/'));
      dio.httpClientAdapter = adapter;

      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
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
          DatedShiftAssignmentScreen(dio: dio),
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

        return ResponseBody.fromString('{"success": true}', 200);
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

      // 1. Both days (Nov 15 and Nov 16) are generated and chips exist
      expect(find.byKey(const Key('chip_day_2026-11-15')), findsOneWidget);
      expect(find.byKey(const Key('chip_day_2026-11-16')), findsOneWidget);

      // Filter to empty day (Nov 16)
      await tester.ensureVisible(find.byKey(const Key('chip_day_2026-11-16')));
      await tester.tap(find.byKey(const Key('chip_day_2026-11-16')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'after filter day');

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
  });
}
