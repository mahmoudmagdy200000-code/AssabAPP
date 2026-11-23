import 'dart:math' as math;

import 'package:assab/core/enums/shift_status/shift_status_type.dart';
import 'package:assab/core/theme/app_theme.dart';
import 'package:assab/core/widgets/app_responsive_builder.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_details/shift_status_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _UnusedManagerShift extends Fake implements CurrentShiftEntity {}

void main() {
  for (final brightness in Brightness.values) {
    testWidgets(
      'Completed shift labels are visible in ${brightness.name} mode',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(size: Size(390, 844)),
            child: AppResponsiveBuilder(
              builder: (_) => MaterialApp(
                theme: brightness == Brightness.light
                    ? AppTheme.light
                    : AppTheme.dark,
                localizationsDelegates: const [S.delegate],
                supportedLocales: S.delegate.supportedLocales,
                home: Scaffold(
                  body: Builder(
                    builder: (context) => Column(
                      children: [
                        ShiftStatusType.completed.managerShiftCardButton(
                          context,
                          currentManagerShift: _UnusedManagerShift(),
                        ),
                        ShiftStatusType.completed.shiftDetailsAppButton(
                          context,
                          shiftId: 'completed-shift',
                          isCashier: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final indicators = find.widgetWithText(
          ElevatedButton,
          S.current.shiftCompleted,
        );
        expect(indicators, findsNWidgets(2));

        for (final indicator in indicators.evaluate()) {
          final button = indicator.widget as ElevatedButton;
          final label = tester.widget<Text>(
            find.descendant(
              of: find.byWidget(button),
              matching: find.text(S.current.shiftCompleted),
            ),
          );
          final foreground = label.style!.color!.computeLuminance();
          final background = button.style!.backgroundColor!.resolve({
            WidgetState.disabled,
          })!.computeLuminance();
          final contrast =
              (math.max(foreground, background) + 0.05) /
              (math.min(foreground, background) + 0.05);

          expect(button.onPressed, isNull);
          expect(contrast, greaterThanOrEqualTo(4.5));
        }
      },
    );
  }
}
