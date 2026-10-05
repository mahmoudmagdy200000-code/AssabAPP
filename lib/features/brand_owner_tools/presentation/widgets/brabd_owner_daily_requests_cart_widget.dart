import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/brand_owner_daily_inventory_requests_response.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../cubit/brand_owner_daily_inventory_details/brand_owner_daily_inventory_details_cubit.dart';
import '../cubit/brand_owner_daily_inventory_requests/brand_owner_daily_inventory_requests_cubit.dart';
import '../screens/brand_owner_daily_inventory_details_screen.dart';

class BrandOwnerDailyRequestsCartWidget extends StatelessWidget {
  final BrandOwnerDailyInventoryRequest request;

  const BrandOwnerDailyRequestsCartWidget({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        final requestsCubit = context
            .read<BrandOwnerDailyInventoryRequestsCubit>();

        NavigationService.I.push(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
                BlocProvider(
                  create: (context) =>
                      getIt<BrandOwnerDailyInventoryDetailsCubit>()
                        ..load(requestId: request.id),
                ),
                BlocProvider.value(value: requestsCubit),
              ],
              child: BrandOwnerDailyInventoryDetailsScreen(
                requestId: request.id,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        margin: EdgeInsets.only(bottom: 4.h),
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: context.customColor.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      AppSvg(
                        assetName: AppAssets.detailsSvg,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          context.customColor.text1,
                          BlendMode.srcIn,
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: Text(
                          context.tr.dailyInventory_d,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                request.status.buildStatus(context),
              ],
            ),
            8.verticalSpace,
            _buildField(
              context,
              AppAssets.calendar02,
              context.tr.inventoryDate,
              DateFormatter.formatDateMDY(
                    DateTime.tryParse(request.inventoryDate),
                  ) ??
                  '-',
            ),
            8.verticalSpace,
            _buildField(
              context,
              AppAssets.time04,
              context.tr.startTime,
              request.startTime,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context,
    String icon,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10.w,
      children: [
        Expanded(
          child: Row(
            children: [
              AppSvg(
                assetName: icon,
                width: 14.w,
                height: 14.h,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              8.horizontalSpace,
              Text(
                label,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
