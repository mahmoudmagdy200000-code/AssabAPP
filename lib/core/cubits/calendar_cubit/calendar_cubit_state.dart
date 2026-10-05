import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  final DateTime selectedDate;
  final DateTime displayedDate;
  final int selectedMonth;
  final int selectedYear;

  const CalendarState({
    required this.selectedDate,
    required this.displayedDate,
    required this.selectedMonth,
    required this.selectedYear,
  });

  factory CalendarState.initial(DateTime initialDate) => CalendarState(
    selectedDate: initialDate,
    displayedDate: initialDate,
    selectedMonth: initialDate.month,
    selectedYear: initialDate.year,
  );

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? displayedDate,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      displayedDate: displayedDate ?? this.displayedDate,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  @override
  List<Object> get props => [
    selectedDate,
    displayedDate,
    selectedMonth,
    selectedYear,
  ];
}
