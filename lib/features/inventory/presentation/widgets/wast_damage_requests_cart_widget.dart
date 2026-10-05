import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/models/wasted_damage_list_response.dart';
import '../screens/waste_damage_details_screen.dart';

class WastDamageRequestsCartWidget extends StatelessWidget {
  final WastedDamageListEntry request;

  const WastDamageRequestsCartWidget({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        NavigationService.I.push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => PagingCubit(totalSteps: 2),
              child: WasteDamageDetailsScreen(details: request.details),
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
                          request.reportType.label(context),
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
              context.tr.submissionDate,
              DateFormatter.formatDateMDY(
                    DateTime.tryParse(request.submissionDate),
                  ) ??
                  '-',
            ),
            8.verticalSpace,
            _buildField(
              context,
              AppAssets.time04,
              context.tr.affectedProducts,
              request.itemsCount.toString(),
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
