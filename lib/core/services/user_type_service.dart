import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';

import '../strategies/user_type_strategy.dart';

class UserTypeService {
  const UserTypeService._();

  static UserTypeStrategy? selectedUserTypeStrategy;
  static UserType? selectedUserType;

  static void setUserType({
    required UserTypeStrategy strategy,
    required UserType userType,
  }) {
    selectedUserType = userType;
    selectedUserTypeStrategy = strategy;
  }

  static Future<void> saveSelectedUserType(UserType userType) async {
    await getIt<SharedPreferencesHelper>().storeString(
      'selected_user_type',
      userType.value,
    );
  }

  static UserType? getSavedUserType() {
    final value = getIt<SharedPreferencesHelper>().getString(
      'selected_user_type',
    );

    if (value == null) return null;

    return UserType.fromString(value);
  }
}
