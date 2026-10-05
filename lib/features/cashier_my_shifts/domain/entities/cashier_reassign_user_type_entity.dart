import '../../../shift_module_features/shift_management/domain/enums/user_type.dart';

class CashierUserObjectEntity {
  final String? id;
  final String name;
  final UserType? userType;

  const CashierUserObjectEntity({
    required this.id,
    required this.name,
    this.userType,
  });
}
