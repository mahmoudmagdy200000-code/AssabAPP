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
              previous.aggregators != current.aggregators ||
              previous.cashiers != current.cashiers;
        }
        return true;
      },
      builder: (context, state) {
        final rows = state is FinalDailyCloseLoadedOrUpdated
            ? state.cashiers
            : cashiersBreakdowns;
        final isExpanded =
            state is FinalDailyCloseLoadedOrUpdated && state.isExpanded;
        final List<AggregatorFinalDailyCloseEntity>? aggregators =
            state is FinalDailyCloseLoadedOrUpdated ? state.aggregators : [];

        final height = isExpanded
            ? (5 + (aggregators?.length ?? 0)) * 70.h
            : 420.h;
        final tableHeight = height + 110.h;

        return SizedBox(
          height: tableHeight,
          child: Stack(
            children: [
              Row(
                children: [
                  90.horizontalSpace,

                  Expanded(
                    child: ListView.builder(
                      itemCount: rows.length < 3 ? 3 : rows.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (rows.length <= index) {
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
                          final cashier = rows[index];

                          return Column(
                            key: ValueKey(cashier.cashierShiftId),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FinalDailyCloseTopTableCellWidget(
                                text: cashier.cashierName,
                              ),

                              FinalDailyCloseCenterTableCellWidget(
                                isEnabled:
                                    isEnabled && cashier.cashierShiftId != null,
                                key: ValueKey(
                                  '${cashier.cashierShiftId}-cc',
                                ), // CashCollected == cc
                                value: cashier.cashCollected,
                                onChanged: (value) {
                                  context
                                      .read<FinalDailyCloseCubit>()
                                      .updateCashierField(
                                        cashierShiftId: cashier.cashierShiftId!,
                                        field: CashierField.cashCollected,
                                        value: value,
                                      );
                                },
                              ),
                              FinalDailyCloseCenterTableCellWidget(
                                isEnabled:
                                    isEnabled && cashier.cashierShiftId != null,
                                value: cashier.cardPayments,
                                key: ValueKey(
                                  '${cashier.cashierShiftId}-cp',
                                ), // CardPayments == cp
                                onChanged: (value) {
                                  context
                                      .read<FinalDailyCloseCubit>()
                                      .updateCashierField(
                                        cashierShiftId: cashier.cashierShiftId!,
                                        field: CashierField.cardPayments,
                                        value: value,
                                      );
                                },
                              ),

                              FinalDailyCloseCenterTableCellWidget(
                                isEnabled: false,
                                key: ValueKey(
                                  '${cashier.cashierShiftId}-v',
                                ), // Variance == v (server-derived, strictly read-only)
                                value: cashier.variance.abs(),
                                onChanged: (_) {},
                              ),

                              if (!isExpanded)
                                FinalDailyCloseCenterTableCellWidget(
                                  isEnabled:
                                      isEnabled &&
                                      cashier.cashierShiftId != null &&
                                      (aggregators?.length ?? 0) <= 1,
                                  value: cashier.deliveryAppPayments,
                                  key: ValueKey(
                                    '${cashier.cashierShiftId}-dap',
                                  ), // DeliveryAppPayments == dap
                                  onChanged: (value) {
                                    context
                                        .read<FinalDailyCloseCubit>()
                                        .updateCashierField(
                                          cashierShiftId:
                                              cashier.cashierShiftId!,
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
                                    isEnabled:
                                        isEnabled &&
                                        cashier.cashierShiftId != null,
                                    value:
                                        aggregator.cashierBreakdown
                                            ?.where(
                                              (row) =>
                                                  row.cashierShiftId ==
                                                  cashier.cashierShiftId,
                                            )
                                            .fold<double>(
                                              0,
                                              (sum, row) => sum + row.amount,
                                            ) ??
                                        0,
                                    key: ValueKey(
                                      '${cashier.cashierShiftId}-${aggregator.id}',
                                    ),
                                    onChanged: (value) {
                                      context
                                          .read<FinalDailyCloseCubit>()
                                          .updateAggregatorAmount(
                                            cashierShiftId:
                                                cashier.cashierShiftId!,
                                            aggregatorId: aggregator.id,
                                            newValue: value,
                                          );
                                    },
                                  ),
                                ),

                              FinalDailyCloseBottomCenterTableCellWidget(
                                text: cashier.cashierTotal.toString(),
                              ),
                              SizedBox(
                                width: 90.w,
                                height: 100.h,
                                child: TextFormField(
                                  key: ValueKey(
                                    '${cashier.cashierShiftId}-reason',
                                  ),
                                  initialValue: cashier.reason ?? '',
                                  enabled:
                                      isEnabled &&
                                      cashier.isModified &&
                                      cashier.cashierShiftId != null,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    labelText: context.tr.reasonForChange,
                                  ),
                                  onChanged: (reason) => context
                                      .read<FinalDailyCloseCubit>()
                                      .updateReason(
                                        cashierShiftId: cashier.cashierShiftId!,
                                        reason: reason,
                                      ),
                                ),
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
