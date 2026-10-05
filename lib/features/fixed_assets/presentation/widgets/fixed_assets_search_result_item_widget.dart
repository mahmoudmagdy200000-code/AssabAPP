import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_check_box.dart';
import '../../data/models/fixed_assets_search_response.dart';
import '../cubit/update_asset_settings/update_asset_settings_cubit.dart';
import '../screens/fixed_assets_preview_history_asset_screen.dart';
import 'fixed_assets_search_screen_item_actions_bottom_sheet.dart';
import 'fixed_assets_search_screen_item_setting_bottom_sheet.dart';

class FixedAssetsSearchResultItemWidget extends StatelessWidget {
  final FixedAssetsSearchItem item;
  final bool isSelected;
  final VoidCallback? onTapCheckBox;

  const FixedAssetsSearchResultItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    this.onTapCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        border: Border.all(color: context.customColor.text2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AppAssetImage(
                  image: AppAssets.testProfile,
                  width: 42.h,
                  height: 42.h,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.id,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),
              ),
              AppCheckBox(
                onChanged: (value) {
                  onTapCheckBox?.call();
                },
                value: isSelected,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: context.customColor.text2, height: 1),
          SizedBox(height: 8.h),
          _buildDetailRow(context, context.tr.location, item.location.name),
          SizedBox(height: 8.h),
          _buildDetailRow(
            context,
            context.tr.status,
            item.status.label(context),
            statusColor: item.status.color,
          ),
          SizedBox(height: 8.h),
          _buildDetailRow(context, context.tr.assignedTo, item.assignedTo),
          SizedBox(height: 8.h),
          _buildDetailRow(context, context.tr.age, item.age),
          SizedBox(height: 8.h),
          Divider(color: context.customColor.text2, height: 1),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10.w,
            children: [
              Expanded(
                child: ButtonTextIcon(
                  onTap: () {
                    AppBottomSheet.customPageRoute(
                      context,
                      (context) => FixedAssetsPreviewHistoryAssetScreen(
                        assetId: item.id,
                      ),
                    );
                  },
                  label: context.tr.preview,
                  icon: AppSvg(
                    assetName: AppAssets.eye,
                    width: 14.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text1,
                      BlendMode.srcIn,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  spaceBetweenTextAndIcon: 7.w,
                  borderRadius: BorderRadius.circular(10.r),
                  textStyle: AppStyles.s12W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  isFlexible: true,
                ),
              ),
              Expanded(
                child: ButtonTextIcon(
                  onTap: () {
                    AppBottomSheet.customPageRoute(
                      context,
                      (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => ValidationCubit(
                              requiredFields: {'newLocation'},
                              optionalFields: {'newImage'},
                            ),
                          ),
                          BlocProvider(
                            create: (context) =>
                                getIt<UpdateAssetSettingsCubit>(),
                          ),
                        ],
                        child: FixedAssetsSearchScreenItemSettingBottomSheet(
                          item: item,
                        ),
                      ),
                    );
                  },
                  label: context.tr.settings,
                  icon: AppSvg(
                    assetName: AppAssets.settings,
                    width: 14.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text1,
                      BlendMode.srcIn,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  spaceBetweenTextAndIcon: 7.w,
                  borderRadius: BorderRadius.circular(10.r),
                  textStyle: AppStyles.s12W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  isFlexible: true,
                ),
              ),
              Expanded(
                child: ButtonTextIcon(
                  onTap: () {
                    AppBottomSheet.customPageRoute(
                      context,
                      (context) =>
                          FixedAssetsSearchScreenItemActionsBottomSheet(
                            item: item,
                          ),
                    );
                  },
                  label: context.tr.actionBtn,
                  icon: Icon(
                    Icons.more_horiz,
                    size: 14.r,
                    color: context.customColor.reversedTextColor,
                  ),
                  backgroundColor: context.theme.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  spaceBetweenTextAndIcon: 7.w,
                  borderRadius: BorderRadius.circular(10.r),
                  textStyle: AppStyles.s12W500.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                  isFlexible: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? statusColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              if (statusColor != null) ...[
                SizedBox(width: 8.w),
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
