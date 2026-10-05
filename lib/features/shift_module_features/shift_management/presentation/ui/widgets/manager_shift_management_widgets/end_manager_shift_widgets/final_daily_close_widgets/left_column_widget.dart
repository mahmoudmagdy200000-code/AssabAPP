import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'svg_with_title_cell_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../../core/widgets/app_svg.dart';
import 'final_daily_close_table_cell_widget.dart';

class LeftColumnWidget extends StatelessWidget {
  const LeftColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinalDailyCloseCubit, FinalDailyCloseState>(
      buildWhen: (previous, current) {
        if (previous is FinalDailyCloseLoadedOrUpdated &&
            current is FinalDailyCloseLoadedOrUpdated) {
          return previous.isExpanded != current.isExpanded ||
              previous.aggregators != current.aggregators;
        }
        return true;
      },
      builder: (context, state) {
        final isExpanded =
            state is FinalDailyCloseLoadedOrUpdated && state.isExpanded;
        final aggregators = state is FinalDailyCloseLoadedOrUpdated
            ? state.aggregators
            : null;

        return PositionedDirectional(
          start: 0,
          top: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(20.r),
                topStart: Radius.circular(20.r),
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.gray.withAlpha(70),
                  blurRadius: 15.r,
                  offset: const Offset(5, 10),
                  spreadRadius: 2.r,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FinalDailyCloseTableCellWidget(
                  topStartBorderRadius: 10.r,
                  cellColor: AppColors.lightGray,
                  bottomBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  endBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),

                  child: const AppSvg(assetName: AppAssets.appLogoSvg),
                ),

                FinalDailyCloseTableCellWidget(
                  endBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  bottomBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  startBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  topBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  child: SvgWithTitleCellWidget(
                    svgAssetName: AppAssets.cash,
                    title: context.tr.cashCollected,
                  ),
                ),

                FinalDailyCloseTableCellWidget(
                  endBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  bottomBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  startBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  topBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  child: SvgWithTitleCellWidget(
                    svgAssetName: AppAssets.cardSvg,
                    title: context.tr.cardPayment,
                  ),
                ),

                FinalDailyCloseTableCellWidget(
                  endBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  bottomBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  startBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  topBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  child: SvgWithTitleCellWidget(
                    svgAssetName: AppAssets.cash,
                    title: context.tr.totalVariance,
                  ),
                ),

                if (!isExpanded)
                  AppGestureDetectorButton(
                    onTap: () =>
                        context.read<FinalDailyCloseCubit>().toggleExpansion(),
                    child: FinalDailyCloseTableCellWidget(
                      endBorderSide: BorderSide(
                        color: context.customColor.border,
                        width: 1.w,
                      ),
                      bottomBorderSide: BorderSide(
                        color: context.customColor.border,
                        width: 1.w,
                      ),
                      startBorderSide: BorderSide(
                        color: context.customColor.border,
                        width: 1.w,
                      ),
                      topBorderSide: BorderSide(
                        color: context.customColor.border,
                        width: 1.w,
                      ),
                      child: SvgWithTitleCellWidget(
                        svgAssetName: AppAssets.groupItemsSvg,
                        title: context.tr.deliveryAppsTotal,
                      ),
                    ),
                  ),

                if (isExpanded && aggregators != null)
                  ...aggregators.map(
                    (aggregator) => AppGestureDetectorButton(
                      onTap: () => context
                          .read<FinalDailyCloseCubit>()
                          .toggleExpansion(),
                      child: FinalDailyCloseTableCellWidget(
                        endBorderSide: BorderSide(
                          color: context.customColor.border,
                          width: 1.w,
                        ),
                        bottomBorderSide: BorderSide(
                          color: context.customColor.border,
                          width: 1.w,
                        ),
                        startBorderSide: BorderSide(
                          color: context.customColor.border,
                          width: 1.w,
                        ),
                        topBorderSide: BorderSide(
                          color: context.customColor.border,
                          width: 1.w,
                        ),
                        child: Row(
                          children: [
                            AppNetworkImage(
                              image: aggregator.logo ?? '',
                              width: 24.w,
                              height: 24.w,
                              errorWidget: Icon(
                                Icons.error,
                                color: AppColors.sBlack,
                                size: 15.w,
                              ),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            8.horizontalSpace,

                            Expanded(
                              child: Text(
                                aggregator.name,
                                style: context.textTheme.labelSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                FinalDailyCloseTableCellWidget(
                  bottomStartBorderRadius: 10.r,
                  cellColor: AppColors.lightGray,
                  bottomBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  endBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),

                  child: SvgWithTitleCellWidget(
                    svgAssetName: AppAssets.saudiRiyal,
                    title: context.tr.totalSales,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
