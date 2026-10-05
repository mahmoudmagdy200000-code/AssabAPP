import 'package:equatable/equatable.dart';

class DateManagementState extends Equatable {
  final String selectedMonth;
  final int selectedYear;

  const DateManagementState({
    required this.selectedMonth,
    required this.selectedYear,
  });

  factory DateManagementState.initial() {
    final now = DateTime.now();
    const months = [
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

    return DateManagementState(
      selectedMonth: months[now.month - 1],
      selectedYear: now.year,
    );
  }

  DateManagementState copyWith({String? selectedMonth, int? selectedYear}) {
    return DateManagementState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  @override
  List<Object?> get props => [selectedMonth, selectedYear];
}
