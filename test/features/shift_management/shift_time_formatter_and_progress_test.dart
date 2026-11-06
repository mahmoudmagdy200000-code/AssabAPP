import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/utils/shift_time_formatter.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/available_recipients_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/shift_progress_indicator_widget.dart';
import 'package:assab/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Widget _buildTestApp({
  required Widget child,
  double screenWidth = 360,
  double screenHeight = 640,
  Locale locale = const Locale('ar'),
}) {
  return MediaQuery(
    data: MediaQueryData(size: Size(screenWidth, screenHeight)),
    child: AppResponsiveBuilder(
      designWidth: 375,
      designHeight: 812,
      builder: (context) {
        return MaterialApp(
          navigatorKey: NavigationService.I.navigatorKey,
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: screenWidth - 32,
                child: child,
              ),
            ),
          ),
        );
      },
    ),
  );
}

class FakeRemoteDataSource implements ShiftManagementRemoteDataSource {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockRemoteDataSourceWithFallback extends FakeRemoteDataSource {
  bool getCandidatesCalled = false;
  bool getRecipientsCalled = false;

  @override
  Future<dynamic> getShortageAllocationCandidates({required String shiftId}) async {
    getCandidatesCalled = true;
    // Simulate live staging server 404 route not found
    throw DioException(
      requestOptions: RequestOptions(path: '/api/v1/branch-manager/shifts/$shiftId/shortage-allocation-candidates'),
      response: Response(
        statusCode: 404,
        data: {'message': 'The route api/v1/branch-manager/shifts/$shiftId/shortage-allocation-candidates could not be found.'},
        requestOptions: RequestOptions(path: '/api/v1/branch-manager/shifts/$shiftId/shortage-allocation-candidates'),
      ),
      type: DioExceptionType.badResponse,
    );
  }

  @override
  Future<AvailableRecipientsResponseModel> getAvailableRecipients({required String shiftId}) async {
    getRecipientsCalled = true;
    return AvailableRecipientsResponseModel(
      success: true,
      message: 'Available cashiers retrieved successfully',
      data: AvailableRecipientsData(
        recipients: [
          RecipientItemModel(
            id: 'cashier-uuid-1',
            name: 'Ahmed Cashier',
            type: 'cashier',
            isAvailable: true,
            disabled: false,
            isSuggested: true,
          ),
          RecipientItemModel(
            id: 'manager-uuid-1',
            name: 'Youssef Manager (Branch Manager)',
            type: 'branch_manager',
            isAvailable: true,
            disabled: false,
            isSuggested: false,
          ),
          RecipientItemModel(
            id: 'inactive-cashier-uuid',
            name: 'Inactive Cashier',
            type: 'cashier',
            isAvailable: false,
            disabled: true,
            isSuggested: false,
          ),
        ],
        autoHandoverEnabled: false,
        hasBranchManager: true,
      ),
    );
  }
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar');
    await initializeDateFormatting('ar_EG');
    await initializeDateFormatting('en');
  });

  group('ShiftTimeFormatter unit tests', () {
    test('parses standard and single-digit clock strings safely under Egyptian Arabic', () {
      Intl.defaultLocale = 'ar_EG';

      final t1455 = ShiftTimeFormatter.parseApiTime('14:55');
      expect(t1455?.hour, 14);
      expect(t1455?.minute, 55);

      final t0800 = ShiftTimeFormatter.parseApiTime('08:00');
      expect(t0800?.hour, 8);
      expect(t0800?.minute, 0);

      final tSec = ShiftTimeFormatter.parseApiTime('14:55:30');
      expect(tSec?.hour, 14);
      expect(tSec?.minute, 55);
      expect(tSec?.second, 30);

      final tSingle = ShiftTimeFormatter.parseApiTime('8:00');
      expect(tSingle?.hour, 8);
      expect(tSingle?.minute, 0);

      Intl.defaultLocale = null;
    });

    test('formats times accurately under English and Arabic locales', () {
      // English formatting
      Intl.defaultLocale = 'en';
      expect(ShiftTimeFormatter.format('14:55'), '02:55 PM');
      expect(ShiftTimeFormatter.format('08:00'), '08:00 AM');
      expect(ShiftTimeFormatter.format('23:59'), '11:59 PM');
      expect(ShiftTimeFormatter.format('00:00'), '12:00 AM');

      // Arabic formatting
      Intl.defaultLocale = 'ar';
      expect(ShiftTimeFormatter.format('14:55'), contains('02:55'));
      expect(ShiftTimeFormatter.format('14:55'), contains('م'));
      expect(ShiftTimeFormatter.format('08:00'), contains('08:00'));
      expect(ShiftTimeFormatter.format('08:00'), contains('ص'));

      Intl.defaultLocale = null;
    });

    test('calculates plannedMinutes for regular and overnight shifts crossing midnight', () {
      // Regular shift: 08:00 to 16:00 = 8 hours (480 min)
      expect(ShiftTimeFormatter.plannedMinutes('08:00', '16:00'), 480);

      // Shift from screenshot 1: 14:55 to 23:59 = 544 min (9.06 hrs ~ 9.1 hrs)
      expect(ShiftTimeFormatter.plannedMinutes('14:55', '23:59'), 544);

      // Overnight shift: 22:00 to 06:00 = 8 hours (480 min)
      expect(ShiftTimeFormatter.plannedMinutes('22:00', '06:00'), 480);

      // Overnight shift: 20:00 to 04:00 = 8 hours (480 min)
      expect(ShiftTimeFormatter.plannedMinutes('20:00', '04:00'), 480);
    });

    test('gracefully handles missing, empty, or invalid inputs without crashing', () {
      expect(ShiftTimeFormatter.parseApiTime(null), isNull);
      expect(ShiftTimeFormatter.parseApiTime(''), isNull);
      expect(ShiftTimeFormatter.parseApiTime('invalid-time'), isNull);
      expect(ShiftTimeFormatter.parseApiTime('25:99'), isNull);

      expect(ShiftTimeFormatter.format(null), '—');
      expect(ShiftTimeFormatter.format(''), '—');
      expect(ShiftTimeFormatter.format('not-a-clock'), '—');

      expect(ShiftTimeFormatter.plannedMinutes(null, '08:00'), 0);
      expect(ShiftTimeFormatter.plannedMinutes('08:00', null), 0);
      expect(ShiftTimeFormatter.plannedMinutes('invalid', '08:00'), 0);
    });
  });

  group('ShiftProgressIndicator widget tests', () {
    testWidgets('renders in Arabic RTL with 14:55 without FormatException (fixes Image 1 crash)', (tester) async {
      Intl.defaultLocale = 'ar_EG';

      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const ShiftProgressIndicator(
            startTime: '14:55',
            endTime: '23:59',
            actualStart: '2026-11-06T14:55:00',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Must not have red error box
      expect(tester.takeException(), isNull);
      expect(find.byType(ShiftProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      Intl.defaultLocale = null;
    });

    testWidgets('renders in Arabic RTL with 08:00 without FormatException (fixes Image 3 crash)', (tester) async {
      Intl.defaultLocale = 'ar_EG';

      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const ShiftProgressIndicator(
            startTime: '08:00',
            endTime: '16:00',
            actualStart: '2026-11-06T08:00:00',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ShiftProgressIndicator), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      Intl.defaultLocale = null;
    });

    testWidgets('renders in English LTR with AM/PM formatting matching Image 2', (tester) async {
      Intl.defaultLocale = 'en';

      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('en'),
          child: const ShiftProgressIndicator(
            startTime: '14:55',
            endTime: '23:59',
            actualStart: '2026-11-06T14:55:00',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('02:55 PM'), findsOneWidget);
      expect(find.text('11:59 PM'), findsOneWidget);

      Intl.defaultLocale = null;
    });

    testWidgets('overnight shift crossing midnight calculates total hours and renders on tablet', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          screenWidth: 820,
          screenHeight: 1180,
          locale: const Locale('ar'),
          child: const ShiftProgressIndicator(
            startTime: '22:00',
            endTime: '06:00',
            actualStart: '2026-11-06T22:00:00',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ShiftProgressIndicator), findsOneWidget);
    });

    testWidgets('gracefully renders safe state when shift times are invalid without crashing', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          locale: const Locale('ar'),
          child: const ShiftProgressIndicator(
            startTime: 'invalid',
            endTime: '',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ShiftProgressIndicator), findsOneWidget);
      expect(find.text('—'), findsNWidgets(2));
    });
  });

  group('Shortage Candidates 404 Fail-Closed Security tests', () {
    test('when shortage-allocation-candidates is 404, repository fails closed without falling back to available-recipients', () async {
      final mockDataSource = MockRemoteDataSourceWithFallback();
      final repository = ShiftManagementRepositoryImp(mockDataSource);

      final result = await repository.getShortageAllocationCandidates(shiftId: 'shift-123');

      expect(mockDataSource.getCandidatesCalled, isTrue);
      expect(mockDataSource.getRecipientsCalled, isFalse);

      bool hasFailed = false;
      result.when(
        failure: (f) => hasFailed = true,
        success: (data) => fail('Expected failure but got success'),
      );

      expect(hasFailed, isTrue);
    });
  });
}
