import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/choose_user_type/presentation/cubit/choose_user_type/choose_user_type_cubit.dart';
import 'package:assab/features/choose_user_type/presentation/cubit/choose_user_type/choose_user_type_state.dart';
import 'package:assab/features/choose_user_type/presentation/widget/user_type_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/user_type_service.dart';
import '../../../../core/strategies/user_type_strategy.dart';

class ChooseUserTypeScreen extends StatelessWidget {
  const ChooseUserTypeScreen({super.key});

  void _selectUserType(BuildContext context, UserType userType) {
    context.read<ChooseUserTypeCubit>().selectUserType(userType);
  }

  void _setUserStrategy({
    required UserTypeStrategy strategy,
    required UserType userType,
  }) {
    UserTypeService.setUserType(strategy: strategy, userType: userType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 50.h,
        child: Column(
          children: [
            const Expanded(
              child: AppAssetImage(
                image: AppAssets.chooseUserType,
                borderRadius: BorderRadius.zero,
              ),
            ),
            30.verticalSpace,
            UserTypeButton(
              title: 'Branch Manager',
              userTypeStrategy: getIt<UserTypeStrategy>(
                instanceName: UserType.branchManager.value,
              ),
              onTap: () {
                _selectUserType(context, UserType.branchManager);
                _setUserStrategy(
                  strategy: getIt<UserTypeStrategy>(
                    instanceName: UserType.branchManager.value,
                  ),
                  userType: UserType.branchManager,
                );
              },
            ),
            10.verticalSpace,
            UserTypeButton(
              title: 'Cashier',
              userTypeStrategy: getIt<UserTypeStrategy>(
                instanceName: UserType.cashier.value,
              ),
              onTap: () {
                _selectUserType(context, UserType.cashier);
                _setUserStrategy(
                  strategy: getIt<UserTypeStrategy>(
                    instanceName: UserType.cashier.value,
                  ),
                  userType: UserType.cashier,
                );
              },
            ),
            10.verticalSpace,
            UserTypeButton(
              title: 'Supplier',
              userTypeStrategy: getIt<UserTypeStrategy>(
                instanceName: UserType.supplier.value,
              ),
              onTap: () {
                _selectUserType(context, UserType.supplier);
                _setUserStrategy(
                  strategy: getIt<UserTypeStrategy>(
                    instanceName: UserType.supplier.value,
                  ),
                  userType: UserType.supplier,
                );
              },
            ),
            10.verticalSpace,
            UserTypeButton(
              title: 'Brand Owner',
              userTypeStrategy: getIt<UserTypeStrategy>(
                instanceName: UserType.brandOwner.value,
              ),
              onTap: () {
                _selectUserType(context, UserType.brandOwner);
                _setUserStrategy(
                  strategy: getIt<UserTypeStrategy>(
                    instanceName: UserType.brandOwner.value,
                  ),
                  userType: UserType.brandOwner,
                );
              },
            ),
            30.verticalSpace,
            BlocSelector<ChooseUserTypeCubit, ChooseUserTypeState, bool>(
              selector: (state) => state.selectedUserType != null,
              builder: (context, state) {
                return AppButton(
                  onClick: () =>
                      NavigationService.I.pushNamed(AppRouteName.onboarding),
                  enabled: state,
                  text: context.tr.confirmSelection,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
