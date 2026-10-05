import '../../enums/user_type.dart';

class AssignedByEntity {
  final String id;
  final String name;
  final UserType userType;

  const AssignedByEntity({
    required this.id,
    required this.name,
    required this.userType,
  });
}
