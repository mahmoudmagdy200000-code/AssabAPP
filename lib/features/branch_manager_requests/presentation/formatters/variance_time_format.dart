import 'package:intl/intl.dart';

String formatDateWithTime(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }
  final parsedDate = DateTime.parse(date);

  final day = parsedDate.day;
  final suffix = _getDaySuffix(day);

  final formattedDate = DateFormat("MMM d'$suffix', y").format(parsedDate);

  final formattedTime = DateFormat('h:mm a').format(parsedDate);

  return '$formattedDate $formattedTime';
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) return 'th';

  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
