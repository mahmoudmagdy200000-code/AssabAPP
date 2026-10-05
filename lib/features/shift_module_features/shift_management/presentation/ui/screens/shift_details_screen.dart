import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/shift_details_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/arguments/shift_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../core/widgets/app_scaffold.dart';
import '../../../domain/entity/shift/shift_entity.dart';
import '../widgets/cashier_shifts_management_widgets/cashier_shifts_app_bar.dart';
import '../widgets/shift_details_widgets/tabs_widgets/shift_details_tab_startegy_factory.dart';

class ShiftDetailsScreen extends StatefulWidget {
  const ShiftDetailsScreen({super.key});

  @override
  State<ShiftDetailsScreen> createState() => _ShiftDetailsScreenState();
}

class _ShiftDetailsScreenState extends State<ShiftDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ShiftDetailsCubit>().getShiftDetails();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: AppPaddingWidget(
        top: 10.h,
        left: 0,
        right: 0,
        bottom: 0,
        child: BlocBuilder<ShiftDetailsCubit, ShiftDetailsState>(
          builder: (context, state) {
            if (state is ShiftDetailsLoading) {
              return const Center(child: AppLoadingWidget());
            }

            if (state is ShiftDetailsError) {
              return Center(
                child: AppFailureWidget(
                  failure: state.failure,
                  onRetry: () {
                    context.read<ShiftDetailsCubit>().getShiftDetails();
                  },
                ),
              );
            }

            final ShiftEntity shift = context.read<ShiftDetailsCubit>().shift;

            return Column(
              children: [
                CashierShiftsAppBar(
                  title: shift.shiftDateFormatted,
                  subTitle: context.tr.cashierShiftDetails(shift.cashier.name),
                ),

                const CashierShiftTopSection(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.h,
                      vertical: 10.h,
                    ),
                    child: CashierShiftsBottomSection(
                      shift: shift,
                      shiftArguments: ShiftArguments(
                        totalSales: shift.totalSales ?? 0,
                        cashCollected: shift.cashCollected ?? 0,
                        cardPayment: shift.cardPayment ?? 0,
                        deliveryApps: shift.deliveryApps ?? 0,
                        shiftId: shift.id,
                        nextCashier: shift.nextCashier?.name,
                        variance:
                            double.tryParse((shift.variance ?? 0).toString()) ??
                            0,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CashierShiftTopSection extends StatelessWidget {
  const CashierShiftTopSection({super.key});

  void _updateSelectedStatus(BuildContext context, int index) {
    context.read<PagingCubit>().goToStep(index);
  }

  Color _selectedColor({
    required BuildContext context,
    required bool isSelected,
  }) {
    return isSelected ? context.theme.primaryColor : context.customColor.text3;
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      context.tr.all,
      context.tr.shiftDetails,
      context.tr.salesAndHandovers,
    ];
    return Padding(
      padding: EdgeInsets.all(13.r),
      child: Column(
        children: [
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final name = tabs[index];
                return AppGestureDetectorButton(
                  onTap: () => _updateSelectedStatus(context, index),
                  child: BlocBuilder<PagingCubit, PagingState>(
                    builder: (context, state) {
                      final isSelected = state.currentIndex == index;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: _selectedColor(
                              context: context,
                              isSelected: isSelected,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(1000.r),
                        ),
                        margin: EdgeInsetsDirectional.only(
                          end: index == tabs.length - 1 ? 0 : 10.r,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 5.r,
                        ),
                        child: Center(
                          child: Text(
                            name,
                            style: AppStyles.s12W500.copyWith(
                              color: _selectedColor(
                                context: context,
                                isSelected: isSelected,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          13.verticalSpace,
          const CustomDivider(),
          4.verticalSpace,
        ],
      ),
    );
  }
}

class CashierShiftsBottomSection extends StatelessWidget {
  final ShiftEntity shift;
  final ShiftArguments? shiftArguments;

  const CashierShiftsBottomSection({
    super.key,
    required this.shift,
    this.shiftArguments,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagingCubit, PagingState>(
      builder: (context, state) {
        final strategy = ShiftTabStrategyFactory.getStrategy(
          state.currentIndex,
          isReassignedToMe: shift.isShiftReassignedToMe ?? false,
        );

        return strategy.buildTabContent(
          context,
          shift: shift,
          shiftArguments: shiftArguments,
        );
      },
    );
  }
}
