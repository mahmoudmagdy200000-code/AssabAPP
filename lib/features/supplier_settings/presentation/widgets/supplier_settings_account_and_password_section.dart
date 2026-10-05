import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import 'supplier_account_and_password_item_widget.dart';

class SupplierSettingsAccountAndPasswordSection extends StatelessWidget {
  const SupplierSettingsAccountAndPasswordSection({super.key});

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
            style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          SupplierAccountAndPasswordItemWidget(
            onTap: () {},
            iconAssetName: AppAssets.accountDetails,
            title: context.tr.myAccountDetails,
          ),
          SupplierAccountAndPasswordItemWidget(
            onTap: () {},
            iconAssetName: AppAssets.resetMyPassword,
            title: context.tr.resetMyPassword,
          ),
          SupplierAccountAndPasswordItemWidget(
            onTap: () {},
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
