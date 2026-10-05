import 'package:injectable/injectable.dart';

import '../../../helpers/safe_cubit.dart';
import 'date_management_state.dart';

@injectable
class DateManagementCubit extends SafeCubit<DateManagementState> {
  DateManagementCubit() : super(DateManagementState.initial());

  static const List<String> shortMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static List<int> get years {
    final currentYear = DateTime.now().year;
    return List.generate(currentYear - 2000 + 1, (i) => 2000 + i);
  }

  void selectMonth(String month) {
    emit(state.copyWith(selectedMonth: month));
  }

  void selectYear(int year) {
    emit(state.copyWith(selectedYear: year));
  }

  void reset() {
    emit(DateManagementState.initial());
  }

  int get selectedMonthNumber {
    return shortMonths.indexOf(state.selectedMonth) + 1;
  }

  int get selectedYear {
    return state.selectedYear;
  }
}
