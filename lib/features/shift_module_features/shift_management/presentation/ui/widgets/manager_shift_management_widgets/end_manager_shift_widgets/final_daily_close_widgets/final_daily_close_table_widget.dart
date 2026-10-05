import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/final_daily_close/AggregatorFinalDailyCloseEntity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/right_column_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/table_cells_widgets/final_daily_close_bottom_center_table_cell_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/table_cells_widgets/final_daily_close_center_table_cell_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/end_manager_shift_widgets/final_daily_close_widgets/table_cells_widgets/final_daily_close_top_table_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../domain/entity/manager_shift/current_shift/final_daily_close/cashier_breakdown_entity.dart';
import '../../../../../../domain/entity/manager_shift/current_shift/final_daily_close/totals_entity.dart';
import '../../../../../logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import 'left_column_widget.dart';

class FinalDailyCloseTableWidget extends StatelessWidget {
  const FinalDailyCloseTableWidget({
    super.key,
    required this.cashiersBreakdowns,
    required this.totals,
    this.isEnabled = true,
  });

  final List<CashierBreakdownEntity> cashiersBreakdowns;
  final TotalsEntity totals;
  final bool isEnabled;
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
        final List<AggregatorFinalDailyCloseEntity>? aggregators =
            state is FinalDailyCloseLoadedOrUpdated ? state.aggregators : [];

        final height = isExpanded
            ? (5 + (aggregators?.length ?? 0)) * 70.h
            : 420.h;

        print('looooooool $isExpanded');
        print('looooooool ${aggregators?.length ?? -1}');
        return SizedBox(
          height: height,
          child: Stack(
            children: [
              Row(
                children: [
                  90.horizontalSpace,

                  Expanded(
                    child: ListView.builder(
                      itemCount: cashiersBreakdowns.length < 3
                          ? 3
                          : cashiersBreakdowns.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (cashiersBreakdowns.length <= index) {
                          return Container(
                            height: double.maxFinite,
                            width: 90.w,
                            decoration: BoxDecoration(
                              color: AppColors.lightGray,
                              border: Border.all(
                                color: context.customColor.border,
                                width: 1.w,
                              ),
                            ),
                          );
                        } else {
                          final cashier = cashiersBreakdowns[index];

                          return Column(
                            key: ValueKey(cashier.cashierId),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FinalDailyCloseTopTableCellWidget(
                                text: cashier.cashierName,
                              ),

                              FinalDailyCloseCenterTableCellWidget(
                                isEnabled: isEnabled,
                                key: ValueKey(
                                  '${cashier.cashierId}-cc',
                                ), // CashCollected == cc
                                value: cashier.cashCollected,
                                onChanged: (value) {
                                  context
                                      .read<FinalDailyCloseCubit>()
                                      .updateCashierField(
                                        cashierId: cashier.cashierId,
                                        field: CashierField.cashCollected,
                                        value: value,
                                      );
                                },
                              ),
                              FinalDailyCloseCenterTableCellWidget(
                                isEnabled: isEnabled,
                                value: cashier.cardPayments,
                                key: ValueKey(
                                  '${cashier.cashierId}-cp',
                                ), // CardPayments == cp
                                onChanged: (value) {
                                  context
                                      .read<FinalDailyCloseCubit>()
                                      .updateCashierField(
                                        cashierId: cashier.cashierId,
                                        field: CashierField.cardPayments,
                                        value: value,
                                      );
                                },
                              ),

                              FinalDailyCloseCenterTableCellWidget(
                                isEnabled: isEnabled,
                                key: ValueKey(
                                  '${cashier.cashierId}-v',
                                ), // Variance == v
                                value: cashier.variance.abs(),
                                onChanged: (value) {
                                  context
                                      .read<FinalDailyCloseCubit>()
                                      .updateCashierField(
                                        cashierId: cashier.cashierId,
                                        field: CashierField.variance,
                                        value: value,
                                      );
                                },
                              ),

                              if (!isExpanded)
                                FinalDailyCloseCenterTableCellWidget(
                                  isEnabled: isEnabled,
                                  value: cashier.deliveryAppPayments,
                                  key: ValueKey(
                                    '${cashier.cashierId}-dap',
                                  ), // DeliveryAppPayments == dap
                                  onChanged: (value) {
                                    context
                                        .read<FinalDailyCloseCubit>()
                                        .updateCashierField(
                                          cashierId: cashier.cashierId,
                                          field:
                                              CashierField.deliveryAppPayments,
                                          value: value,
                                        );
                                  },
                                ),

                              if (isExpanded && aggregators != null)
                                ...aggregators.map(
                                  (
                                    aggregator,
                                  ) => FinalDailyCloseCenterTableCellWidget(
                                    isEnabled: isEnabled,
                                    value:
                                        aggregator.cashierBreakdown
                                            ?.firstWhere(
                                              (element) =>
                                                  element.cashierId.compareTo(
                                                    cashier.cashierId,
                                                  ) ==
                                                  0,
                                            )
                                            .amount ??
                                        0,
                                    key: ValueKey(
                                      '${cashier.cashierId}-${aggregator.id}',
                                    ),
                                    onChanged: (value) {
                                      context
                                          .read<FinalDailyCloseCubit>()
                                          .updateAggregatorAmount(
                                            cashierId: cashier.cashierId,
                                            aggregatorId: aggregator.id,
                                            newValue: value,
                                          );
                                    },
                                  ),
                                ),

                              FinalDailyCloseBottomCenterTableCellWidget(
                                text: cashier.cashierTotal.toString(),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  90.horizontalSpace,
                ],
              ),

              const LeftColumnWidget(),

              BlocSelector<
                FinalDailyCloseCubit,
                FinalDailyCloseState,
                TotalsEntity
              >(
                selector: (state) {
                  if (state is FinalDailyCloseLoadedOrUpdated) {
                    return state.totals;
                  }
                  return totals; // fallback
                },
                builder: (_, totals) {
                  return RightColumnWidget(totals: totals);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
