import 'manager_shift_end_data_entity.dart';

class EndShiftResponseEntity {
  final bool success;
  final String message;
  final ManagerShiftEndDataEntity data;

  const EndShiftResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
