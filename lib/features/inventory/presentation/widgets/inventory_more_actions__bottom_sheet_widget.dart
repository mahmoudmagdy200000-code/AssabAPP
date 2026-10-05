import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/strategies/inventory_requests_strategy.dart';
import '../screens/inventory_requests_screen.dart';

class InventoryMoreActionsBottomSheetWidget extends StatelessWidget {
  const InventoryMoreActionsBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.inventoryActions,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            // Description
            Text(
              context.tr.completeCoreTasksOrAssignNewTaskToOthers,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            14.verticalSpace,
            // Actions
            _buildActionItem(
              context,
              context.tr.dailyInventoryAction,
              AppAssets.package,
              () {
                NavigationService.I.push(
                  MaterialPageRoute(
                    builder: (_) => InventoryRequestsScreen(
                      strategy: DailyInventoryRequestsStrategy(),
                    ),
                  ),
                );
              },
            ),
            12.verticalSpace,
            _buildActionItem(
              context,
              context.tr.monthlyInventory,
              AppAssets.waste,
              () {
                NavigationService.I.push(
                  MaterialPageRoute(
                    builder: (_) => InventoryRequestsScreen(
                      strategy: MonthlyInventoryRequestsStrategy(),
                    ),
                  ),
                );
              },
            ),
            12.verticalSpace,
            _buildActionItem(
              context,
              context.tr.smartMonthlyInventory,
              AppAssets.edit,
              () {
                // Handle add justification
              },
            ),
            12.verticalSpace,
            _buildActionItem(
              context,
              context.tr.wasteDamageManagement,
              AppAssets.edit,
              () {
                NavigationService.I.push(
                  MaterialPageRoute(
                    builder: (_) => InventoryRequestsScreen(
                      strategy: WastedAndDamagedInventoryRequestsStrategy(),
                    ),
                  ),
                );
              },
            ),
            12.verticalSpace,
            _buildActionItem(
              context,
              context.tr.reportsReview,
              AppAssets.edit,
              () {
                // Handle add justification
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    String label,
    String iconAsset,
    VoidCallback onTap,
  ) {
    return AppGestureDetectorButton(
      onTap: () {
        NavigationService.I.pop();

        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: context.customColor.border),
        ),
        child: Row(
          children: [
            AppSvg(
              assetName: iconAsset,
              width: 16.r,
              height: 16.r,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text4,
                ),
              ),
            ),
            AppSvg(
              assetName: AppAssets.arrowRight,
              width: 10.r,
              height: 10.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
