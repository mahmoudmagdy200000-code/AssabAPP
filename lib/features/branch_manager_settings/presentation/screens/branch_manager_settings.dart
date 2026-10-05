import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/features/branch_manager_settings/presentation/screens/branch_manager_my_account_details_screen.dart';
import 'package:assab/features/branch_manager_settings/presentation/widgets/brand_owner_retention_settings_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../widgets/branch_manager_account_and_password_item_widget.dart';
import '../widgets/branch_manager_settings_account_and_password_section.dart';
import '../widgets/branch_manager_settings_system_settings_section.dart';
import '../widgets/branch_manager_settings_top_section.dart';
import '../widgets/brand_owner_report_settings_screen.dart';
import '../widgets/brand_owner_security_setting_screen.dart';
import '../widgets/brand_owner_setting_approval_screen.dart';

class BranchManagerSettings extends StatelessWidget {
  final UserTypeStrategy userType;

  const BranchManagerSettings({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BranchManagerSettingsTopSection(userType: userType),
              if (userType is BrandOwnerUserStrategy)
                Container(
                  color: context.customColor.reversedTextColor,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.r,
                    vertical: 16.r,
                  ),
                  margin: EdgeInsets.only(bottom: 8.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Approvals, Reports, Security & Retention',
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      BranchManagerAccountAndPasswordItemWidget(
                        onTap: () {
                          AppBottomSheet.customPageRoute(
                            context,
                            (context) =>
                                const BrandOwnerSettingApprovalScreen(),
                          );
                        },
                        iconAssetName: AppAssets.approvalSettingsSvg,
                        title: 'Approval Settings',
                        iconColor: ColorFilter.mode(
                          context.theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      BranchManagerAccountAndPasswordItemWidget(
                        onTap: () {
                          AppBottomSheet.customPageRoute(
                            context,
                            (context) => const BrandOwnerReportSettingsScreen(),
                          );
                        },
                        iconAssetName: AppAssets.viewReports,
                        title: 'Report Settings',
                        iconColor: ColorFilter.mode(
                          context.theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      BranchManagerAccountAndPasswordItemWidget(
                        onTap: () {
                          AppBottomSheet.customPageRoute(
                            context,
                            (context) =>
                                const BrandOwnerSecuritySettingScreen(),
                          );
                        },
                        iconAssetName: AppAssets.securitySettingsSvg,
                        title: 'Security Settings',
                        iconColor: ColorFilter.mode(
                          context.theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      BranchManagerAccountAndPasswordItemWidget(
                        onTap: () {
                          AppBottomSheet.customPageRoute(
                            context,
                            (context) =>
                                const BrandOwnerRetentionSettingsScreen(),
                          );
                        },
                        iconAssetName: AppAssets.retentionSettingsSvg,
                        title: 'Retention Settings',
                        iconColor: ColorFilter.mode(
                          context.theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              BranchManagerSettingsAccountAndPasswordSection(
                userType: userType,
              ),
              const BranchManagerSettingsSystemSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
