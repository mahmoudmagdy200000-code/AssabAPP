import 'package:injectable/injectable.dart';

import '../../helpers/safe_cubit.dart';
import 'calendar_cubit_state.dart';

@injectable
class CalendarCubit extends SafeCubit<CalendarState> {
  CalendarCubit() : super(CalendarState.initial(DateTime.now()));

  void changeMonth(int month) {
    emit(
      state.copyWith(
        selectedMonth: month,
        displayedDate: DateTime(state.selectedYear, month),
      ),
    );
  }

  void changeYear(int year) {
    emit(
      state.copyWith(
        selectedYear: year,
        displayedDate: DateTime(year, state.selectedMonth),
      ),
    );
  }

  void selectDate(DateTime date) {
    emit(
      state.copyWith(
        selectedDate: date,
        selectedMonth: date.month,
        selectedYear: date.year,
        displayedDate: date,
      ),
    );
  }
}
