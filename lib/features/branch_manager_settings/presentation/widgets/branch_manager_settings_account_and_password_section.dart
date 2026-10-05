import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../screens/branch_manager_my_account_details_screen.dart';
import '../screens/branch_manager_reset_my_password_screen.dart';
import 'branch_manager_account_and_password_item_widget.dart';
import 'brand_owner_notifications_screen.dart';

class BranchManagerSettingsAccountAndPasswordSection extends StatelessWidget {
  final UserTypeStrategy userType;

  const BranchManagerSettingsAccountAndPasswordSection({
    super.key,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.customColor.reversedTextColor,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      margin: EdgeInsets.only(bottom: 8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.accountPassword,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          BranchManagerAccountAndPasswordItemWidget(
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => const BranchManagerMyAccountDetailsScreen(),
              );
            },
            iconAssetName: AppAssets.accountDetails,
            title: context.tr.myAccountDetails,
          ),
          BranchManagerAccountAndPasswordItemWidget(
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => const BranchManagerResetMyPasswordScreen(),
              );
            },
            iconAssetName: AppAssets.resetMyPassword,
            title: context.tr.resetMyPassword,
          ),
          BranchManagerAccountAndPasswordItemWidget(
            onTap: () {
              if (userType is BrandOwnerUserStrategy) {}
              AppBottomSheet.customPageRoute(
                context,
                (context) => const BrandOwnerNotificationsScreen(),
              );
            },
            iconAssetName: AppAssets.notification,
            title: context.tr.notificationsAlerts,
            iconColor: ColorFilter.mode(
              context.customColor.error,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
