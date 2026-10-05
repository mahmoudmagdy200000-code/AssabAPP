import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/generated/l10n.dart';
import 'package:intl/intl.dart';

extension ShiftEntityExtensions on ShiftEntity {
  String get timeDifferenceMessage {
    try {
      final parsedDate = DateTime.tryParse(shiftDateFormatted);
      if (parsedDate == null) return '';

      final parsedTime = DateFormat.Hm().parse(shiftTimeDetails.startTime);
      final start = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      final now = DateTime.now();
      final diff = now.difference(start);

      if (diff.isNegative) {
        final remainingHours = diff.inHours.abs();
        final remainingMinutes = diff.inMinutes.remainder(60).abs();

        if (remainingHours == 0) {
          return S.current.minutesRemaining(remainingMinutes);
        }
        return S.current.hoursRemaining(remainingHours);
      }

      if (diff.inHours <= 6) {
        final remaining = 6 - diff.inHours;
        return S.current.hoursRemaining(remaining);
      }

      return S.current.upcomingShift;
    } catch (e) {
      return '';
    }
  }
}
