import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../cashier_home/presentation/widgets/cashier_grid_view_item.dart';

class BrandOwnerToolsScreen extends StatelessWidget {
  const BrandOwnerToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppPaddingWidget(
          top: 30.r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.operationsPanel,
                style: AppStyles.s16W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              Text(
                context.tr.operationsPanelDesc,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: context.customColor.text2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      spacing: 12.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.tr.quickActions} 6',
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Row(
                          spacing: 12.w,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 12.h,
                                children: [
                                  _buildCustomButton(
                                    context,
                                    label: context.tr.cashHandover,
                                    asset: AppAssets.returnsManagement,
                                    onTap: () {},
                                  ),
                                  _buildCustomButton(
                                    context,
                                    label: context.tr.addStoreBranch,
                                    asset: AppAssets.branchStoreSvg,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                spacing: 12.h,
                                children: [
                                  _buildCustomButton(
                                    context,
                                    label: context.tr.transferToBranch,
                                    asset: AppAssets.home,
                                    onTap: () {},
                                  ),
                                  _buildCustomButton(
                                    context,
                                    label: context.tr.addEmployee,
                                    asset: AppAssets.personSvg,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _buildCustomButton(
                          context,
                          label: context.tr.makePaymentToSupplier,
                          asset: AppAssets.transfer2,
                          onTap: () {},
                        ),
                        _buildCustomButton(
                          context,
                          label: context.tr.topUpCustodyFromSales,
                          asset: AppAssets.custody,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: GridView(
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
                        CashierGridViewItem(
                          colorHex: 0xfffef8f4,
                          title: context.tr.hrTools,
                          iconAssetName: AppAssets.tool,
                          iconColor: AppColors.orange,
                          // subtitle: '16',
                          onTap: () {},
                        ),
                        CashierGridViewItem(
                          colorHex: 0xfffef8f4,
                          title: context.tr.storeBranches,
                          iconAssetName: AppAssets.branchStoreSvg,
                          iconColor: AppColors.yellow,
                          // subtitle: '16',
                          onTap: () {},
                        ),
                        CashierGridViewItem(
                          colorHex: 0xfff2fcfc,
                          title: context.tr.employeeAndStaff,
                          iconAssetName: AppAssets.cashiersList,
                          // subtitle: '16',
                          onTap: () {},
                        ),
                        CashierGridViewItem(
                          colorHex: 0xfff2fcfc,
                          title: context.tr.custodyManagement,
                          iconAssetName: AppAssets.custody,
                          iconColor: context.theme.primaryColor,
                          // subtitle: '16',
                          onTap: () {},
                        ),
                        CashierGridViewItem(
                          colorHex: 0xfffef8f4,
                          title: context.tr.paymentLog,
                          iconAssetName: AppAssets.calendar,
                          iconColor: AppColors.orange,
                          // subtitle: '16',
                          onTap: () {
                            NavigationService.I.pushNamed(
                              AppRouteName.brandOwnerPaymentLogScreen,
                            );
                          },
                        ),
                        CashierGridViewItem(
                          colorHex: 0xfffef8f4,
                          title: context.tr.inventoryManagement,
                          iconAssetName: AppAssets.receipt,
                          iconColor: AppColors.yellow,
                          // subtitle: '16',
                          onTap: () {
                            NavigationService.I.pushNamed(
                              AppRouteName.brandOwnerInventoryManagementScreen,
                            );
                          },
                        ),
                        CashierGridViewItem(
                          colorHex: 0xfff2fcfc,
                          title: context.tr.assetManagement,
                          iconAssetName: AppAssets.assetCoinSvg,
                          // subtitle: '16',
                          onTap: () {
                            NavigationService.I.pushNamed(
                              AppRouteName
                                  .brandOwnerFixedAssetsControlPanalScreen,
                            );
                          },
                        ),
                        CashierGridViewItem(
                          colorHex: 0xfff2fcfc,
                          title: context.tr.financialReporting,
                          iconAssetName: AppAssets.viewReports,
                          iconColor: context.theme.primaryColor,
                          // subtitle: '16',
                          onTap: () {
                            NavigationService.I.pushNamed(
                              AppRouteName.brandOwnerFinancialReportingScreen,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required String label,
    required String asset,
    required VoidCallback onTap,
  }) {
    return ButtonTextIcon(
      onTap: onTap,
      backgroundColor: context.customColor.reversedTextColor,
      borderColor: Colors.transparent,
      label: label,
      textStyle: AppStyles.s12W500.copyWith(color: context.customColor.text1),
      spaceBetweenTextAndIcon: 7,
      isFlexible: true,
      icon: AppSvg(
        assetName: asset,
        width: 12.r,
        colorFilter: ColorFilter.mode(
          context.theme.primaryColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
