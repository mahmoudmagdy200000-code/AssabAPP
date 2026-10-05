import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import 'branch_manager_grid_view_item.dart';

class BranchManagerHomeBottomSection extends StatelessWidget {
  const BranchManagerHomeBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Tools & Records (9)',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     Text(
              //       context.tr.viewAll,
              //       style: AppStyles.s12W400.copyWith(
              //         color: context.theme.primaryColor,
              //       ),
              //     ),
              //     5.horizontalSpace,
              //     AppSvg(
              //       assetName: AppAssets.arrowRight,
              //       colorFilter: ColorFilter.mode(
              //         context.theme.primaryColor,
              //         BlendMode.srcIn,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.r,
              crossAxisSpacing: 10.r,
              childAspectRatio: 1.1,
            ),
            padding: EdgeInsets.zero,
            children: [
              BranchManagerGridViewItem(
                colorHex: 0xffFCFAFF,
                title: context.tr.custodyBalance,
                iconAssetName: AppAssets.custody,
                subtitle: '16',
                onTap: () {
                  NavigationService.I.pushNamed(AppRouteName.custodyScreen);
                },
              ),
              BranchManagerGridViewItem(
                colorHex: 0xfff2f2f2,
                title: context.tr.purchaseHistory,
                iconAssetName: AppAssets.box,
                subtitle: '16',
                onTap: () {
                  NavigationService.I.pushNamed(
                    AppRouteName.purchaseHistoryScreen,
                  );
                },
              ),
              BranchManagerGridViewItem(
                colorHex: 0xfffef3f5,
                title: context.tr.returnsManagement,
                iconAssetName: AppAssets.returnsManagement,
                subtitle: '16',
                onTap: () {
                  NavigationService.I.pushNamed(
                    AppRouteName.returnsManagementScreen,
                  );
                },
              ),
              BranchManagerGridViewItem(
                colorHex: 0xfff5f9ff,
                title: context.tr.recurringOrders,
                iconAssetName: AppAssets.recurringOrders,
                subtitle: '3',
                onTap: () {
                  NavigationService.I.pushNamed(
                    AppRouteName.recurringOrdersScreen,
                  );
                },
              ),
              BranchManagerGridViewItem(
                colorHex: 0xfffffdf5,
                title: context.tr.myLedger,
                iconAssetName: AppAssets.myLedger,
                subtitle: '16',
                onTap: () {},
              ),
              BranchManagerGridViewItem(
                colorHex: 0xfff2fcfc,
                title: context.tr.cashiersList,
                iconAssetName: AppAssets.cashiersList,
                subtitle: '16',
                onTap: () {
                  NavigationService.I.pushNamed(
                    AppRouteName.cashiersManagementScreen,
                  );
                },
              ),
              BranchManagerGridViewItem(
                colorHex: 0xfffef8f4,
                title: context.tr.accountStatement,
                iconAssetName: AppAssets.accountStatement,
                subtitle: '16',
                onTap: () {},
              ),
              BranchManagerGridViewItem(
                colorHex: 0xfff4f4f7,
                title: context.tr.inventoryManagement,
                iconAssetName: AppAssets.receipt,
                subtitle: '16',
                onTap: () {
                  NavigationService.I.pushNamed(AppRouteName.inventoryScreen);
                },
              ),
              BranchManagerGridViewItem(
                colorHex: 0xfff3fef3,
                title: context.tr.fixedAssets,
                iconAssetName: AppAssets.fixedAssets,
                subtitle: '16',
                onTap: () {
                  NavigationService.I.pushNamed(AppRouteName.fixedAssetsScreen);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
