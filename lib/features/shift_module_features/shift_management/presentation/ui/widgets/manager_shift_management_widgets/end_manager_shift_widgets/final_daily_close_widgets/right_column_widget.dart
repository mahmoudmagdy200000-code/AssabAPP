import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/svg_with_title_cell_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/table_cells_widgets/final_daily_close_end_bottom_table_cell_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/table_cells_widgets/final_daily_close_end_center_table_cell_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_colors.dart';
import 'final_daily_close_table_cell_widget.dart';

class RightColumnWidget extends StatelessWidget {
  const RightColumnWidget({super.key, required this.totals});

  final TotalsEntity totals;
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
            : [];

        return PositionedDirectional(
          end: 0,
          top: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(20.r),
                topEnd: Radius.circular(20.r),
              ),

              boxShadow: [
                BoxShadow(
                  color: AppColors.gray.withAlpha(70),
                  blurRadius: 15.r,
                  offset: const Offset(-1, 10),
                  spreadRadius: 2.r,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FinalDailyCloseTableCellWidget(
                  topEndBorderRadius: 10.r,
                  cellColor: AppColors.lightGray,
                  bottomBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                  startBorderSide: BorderSide(
                    color: context.customColor.border,
                    width: 1.w,
                  ),

                  child: SvgWithTitleCellWidget(
                    title: context.tr.total,
                    svgAssetName: AppAssets.saudiRiyal,
                  ),
                ),

                FinalDailyCloseEndCenterTableCellWidget(
                  text: totals.totalCashCollected.toString(),
                ),
                FinalDailyCloseEndCenterTableCellWidget(
                  text: totals.totalCardPayments.toString(),
                ),
                FinalDailyCloseEndCenterTableCellWidget(
                  text: totals.totalVariance.toString(),
                ),

                if (!isExpanded)
                  FinalDailyCloseEndCenterTableCellWidget(
                    text: totals.totalDeliveryApps.toString(),
                  ),

                if (isExpanded && aggregators != null)
                  ...aggregators.map(
                    (aggregator) => FinalDailyCloseEndCenterTableCellWidget(
                      text: aggregator.total.toString(),
                    ),
                  ),

                FinalDailyCloseEndBottomTableCellWidget(
                  text: totals.totalOfTotals.toString(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
