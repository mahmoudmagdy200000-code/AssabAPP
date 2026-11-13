import 'dart:convert';

import 'package:assab/core/responsive/app_responsive.dart';
import 'package:assab/core/theme/light_theme.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/dated_shift_assignment_screen.dart';
import 'package:assab/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dated_shift_assignment_screen_test.dart' show TestHttpAdapter;

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
  test(
    'R5 effective owner resolves periods, timestamps, gaps and future records',
    () {
      final periods = <Map<String, dynamic>>[
        {'cashier_id': 'B', 'effective_from': '2026-11-18T00:00:00.000Z'},
        {
          'cashier_id': 'A',
          'effective_from': '2026-11-15',
          'effective_to': '2026-11-17T00:00:00.000Z',
        },
      ];
      expect(recurringAssignmentForDate(periods, '2026-11-14'), isNull);
      expect(
        recurringAssignmentForDate(periods, '2026-11-15')?['cashier_id'],
        'A',
      );
      expect(
        recurringAssignmentForDate(periods, '2026-11-17')?['cashier_id'],
        'A',
      );
      expect(
        recurringAssignmentForDate(periods, '2026-11-18')?['cashier_id'],
        'B',
      );
      expect(
        recurringAssignmentForDate(
          periods.reversed.toList(),
          '2026-11-19',
        )?['cashier_id'],
        'B',
      );
      expect(recurringAssignmentForDate([periods.first], '2026-11-17'), isNull);
      expect(recurringAssignmentForDate([periods.last], '2026-11-18'), isNull);
      expect(
        recurringAssignmentForDate([
          {
            'cashier_id': 'A',
            'effective_from': '2026-11-01',
            'effective_to': '2026-11-10',
          },
          periods.first,
        ], '2026-11-15'),
        isNull,
      );
    },
  );

  for (final planned in [false, true]) {
    testWidgets(
      'R5 ${planned ? "planned creates actual" : "actual reassigns"} and rereads persisted state',
      (tester) async {
        tester.view.physicalSize = const Size(820, 1180);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var saved = false;
        var failWrite = !planned;
        RequestOptions? write;
        ResponseBody json(dynamic data, [int status = 200]) =>
            ResponseBody.fromString(
              jsonEncode(data),
              status,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
        final adapter = TestHttpAdapter(
          onFetch: (options) async {
            if (options.method == 'POST') {
              write = options;
              if (failWrite) {
                return json({
                  'success': false,
                  'message': 'تغيرت حالة الوردية',
                }, 409);
              }
              saved = true;
              return json({'success': true});
            }
            if (options.path.endsWith('roster-assignments')) {
              return json({
                'data': [
                  {
                    'shift_id': 'tpl',
                    'cashier_id': 'B',
                    'cashier_name': 'موظف ب',
                    'effective_from': '2026-11-18',
                  },
                  {
                    'shift_id': 'tpl',
                    'cashier_id': 'A',
                    'cashier_name': 'موظف أ',
                    'effective_from': '2026-11-15',
                    'effective_to': '2026-11-17',
                  },
                ],
              });
            }
            return json({
              'data': {
                'start_date': '2026-11-18',
                'end_date': '2026-11-18',
                'templates': [
                  {
                    'id': 'tpl',
                    'name': 'وردية واحدة',
                    'start_time': '08:00:00',
                    'end_time': '16:00:00',
                  },
                ],
                'roster': (planned && !saved)
                    ? {}
                    : {
                        '2026-11-18_tpl': {
                          'cashier_shift_id': 'actual-uuid',
                          'cashier_id': saved ? 'B' : 'A',
                          'cashier_name': saved ? 'موظف ب' : 'موظف أ',
                          'status': saved && !planned
                              ? 'reassigned'
                              : 'not_started',
                          'can_swap': !saved || planned,
                        },
                      },
              },
            });
          },
        );
        final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
          ..httpClientAdapter = adapter;
        await tester.pumpWidget(
          _buildTestApp(
            DatedShiftAssignmentScreen(
              dio: dio,
              initialDateRange: '2026-11-18 — 2026-11-18',
              onFetchAvailableCashiers: () async => [
                {'id': 'B', 'name': 'موظف ب'},
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<Text>(find.byKey(const Key('txt_primary_cashier_tpl')))
              .data,
          contains('موظف ب'),
        );
        if (planned) {
          expect(find.textContaining('مخطط فقط'), findsOneWidget);
          expect(find.byKey(const Key('btn_swap_tpl')), findsNothing);
        } else {
          expect(find.text('تعيين فعلي مختلف'), findsOneWidget);
        }
        Future<void> selectB() async {
          final action = find.byKey(
            Key(planned ? 'btn_assign_tpl' : 'btn_assign_edit_tpl'),
          );
          await tester.ensureVisible(action);
          await tester.tap(action);
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key('tile_cashier_B')));
          await tester.pumpAndSettle();
          await tester.tap(
            find.byKey(const Key('btn_confirm_cashier_assignment')),
          );
          await tester.pumpAndSettle();
        }

        await selectB();
        if (!planned) {
          expect(find.textContaining('تغيرت حالة الوردية'), findsOneWidget);
          expect(
            tester
                .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl')))
                .data,
            'موظف أ',
          );
          failWrite = false;
          await selectB();
        }
        expect(
          write!.path,
          planned
              ? 'branch-manager/cashiers/assign-shifts'
              : 'branch-manager/shifts/actual-uuid/reassign',
        );
        expect(write!.data[planned ? 'cashier_id' : 'new_cashier_id'], 'B');
        expect(
          adapter.recordedRequests.where(
            (r) => r.method == 'POST' && r.path.contains('roster-assignments'),
          ),
          isEmpty,
        );
        await tester.tap(find.byKey(const Key('btn_refresh_roster')));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<Text>(find.byKey(const Key('txt_cashier_name_tpl')))
              .data,
          'موظف ب',
        );
        expect(find.textContaining('مخطط فقط'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'R5 recurring read failure blocks edits and retry restores the same period',
    (tester) async {
      tester.view.physicalSize = const Size(820, 1180);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      var fail = true;
      final adapter = TestHttpAdapter(
        onFetch: (options) async {
          final isRecurring = options.path.endsWith('roster-assignments');
          return ResponseBody.fromString(
            jsonEncode(
              isRecurring
                  ? (fail ? {'message': 'unavailable'} : {'data': []})
                  : {
                      'data': {
                        'start_date': '2026-11-18',
                        'end_date': '2026-11-18',
                        'templates': [
                          {
                            'id': 'tpl',
                            'name': 'وردية واحدة',
                            'start_time': '08:00',
                            'end_time': '16:00',
                          },
                        ],
                        'roster': {},
                      },
                    },
            ),
            isRecurring && fail ? 500 : 200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        },
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api/v1/'))
        ..httpClientAdapter = adapter;
      await tester.pumpWidget(
        _buildTestApp(
          DatedShiftAssignmentScreen(
            dio: dio,
            initialDateRange: '2026-11-18 — 2026-11-18',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('تعذر تحميل التعيين الأساسي المتكرر'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('btn_assign_tpl')), findsNothing);
      fail = false;
      await tester.tap(find.byKey(const Key('btn_retry_roster')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('btn_assign_tpl')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('txt_date_range'))).data,
        '2026-11-18 — 2026-11-18',
      );
      fail = true;
      await tester.tap(find.byKey(const Key('btn_refresh_roster')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('btn_assign_tpl')), findsNothing);
      expect(
        adapter.recordedRequests.where((r) => r.method == 'POST'),
        isEmpty,
      );
    },
  );
}
