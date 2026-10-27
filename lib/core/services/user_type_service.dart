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

  static UserTypeStrategy strategyFor(UserType userType) {
    if (getIt.isRegistered<UserTypeStrategy>(instanceName: userType.value)) {
      return getIt<UserTypeStrategy>(instanceName: userType.value);
    }
    return switch (userType) {
      UserType.branchManager => BranchManagerUserStrategy(),
      UserType.cashier => CashierUserStrategy(),
      UserType.supplier => SupplierUserStrategy(),
      UserType.brandOwner => BrandOwnerUserStrategy(),
    };
  }

  static UserType? restoreSavedUserType() {
    final saved = getSavedUserType();
    if (saved == null) return null;
    setUserType(strategy: strategyFor(saved), userType: saved);
    return saved;
  }

  static Future<void> saveSelectedUserType(UserType userType) async {
    await getIt<SharedPreferencesHelper>().storeString(
      'selected_user_type',
      userType.value,
    );
  }

  static UserType? getSavedUserType() {
    if (!getIt.isRegistered<SharedPreferencesHelper>()) {
      return null;
    }
    final value = getIt<SharedPreferencesHelper>().getString(
      'selected_user_type',
    );

    if (value == null || value.isEmpty) return null;

    final matched = UserType.values.where((e) => e.value == value);
    return matched.isEmpty ? null : matched.first;
  }

  static Future<void> clearUserType() async {
    selectedUserType = null;
    selectedUserTypeStrategy = null;
    if (getIt.isRegistered<SharedPreferencesHelper>()) {
      await getIt<SharedPreferencesHelper>().remove('selected_user_type');
    }
  }
}
