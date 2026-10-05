import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/purchase/presentation/cubit/filter_branches/filter_branches_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/filter_branches/filter_branches_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/purchase_branch_availability_enum.dart';
import '../../../../core/enums/purchase_response_time_enum.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../cubit/get_purchase_branches/get_purchase_branches_cubit.dart';
import 'filter_branch_widget_availability_section.dart';
import 'filter_branch_widget_response_time_section.dart';
import 'purchase_filter_distance_section.dart';

class FilterBranchWidget extends StatelessWidget {
  final PurchaseBranchItemData item;
  final int quantity;

  const FilterBranchWidget({
    super.key,
    required this.item,
    required this.quantity,
  });

  void _getBranches({
    required BuildContext context,
    String? availability,
    String? responseTime,
    String? distance,
  }) {
    context.read<GetPurchaseBranchesCubit>().getPurchaseBranches(
      itemId: item.id,
      quantity: quantity.toString(),
      availability: availability,
      responseTime: responseTime,
      distance: distance,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 50.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${context.tr.filterBranchListBy}:',
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    const CustomDivider(),
                    16.verticalSpace,
                    const FilterBranchWidgetAvailabilitySection(),
                    16.verticalSpace,
                    const FilterBranchWidgetResponseTimeSection(),
                    16.verticalSpace,
                    PurchaseFilterDistanceSection<
                      FilterBranchesCubit,
                      FilterBranchesState
                    >(
                      selector: (state) => state.distance,
                      onChangedSlider: (bloc, newValue) {
                        context.read<FilterBranchesCubit>().setDistance(
                          newValue,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.defaultSettings,
                    textColor: context.customColor.text3,
                    padding: EdgeInsets.symmetric(
                      vertical: 18.r,
                      horizontal: 23.r,
                    ),
                    onTap: () {
                      context.read<FilterBranchesCubit>().resetFilters();
                      _getBranches(context: context);
                      NavigationService.I.pop();
                    },
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: AppButton(
                    text: context.tr.showResults,
                    enabled: true,
                    borderRadius: BorderRadius.circular(12.r),
                    padding: EdgeInsets.symmetric(
                      vertical: 18.r,
                      horizontal: 23.r,
                    ),
                    onClick: () {
                      final state = context.read<FilterBranchesCubit>().state;
                      String? availability;
                      String? responseTime;

                      if (state.availability !=
                              PurchaseBranchAvailabilityEnum.non ||
                          state.availability !=
                              PurchaseBranchAvailabilityEnum.all) {
                        availability = state.availability.name;
                      }

                      if (state.responseTime != PurchaseResponseTimeEnum.non) {
                        responseTime = state.responseTime.name;
                      }

                      _getBranches(
                        context: context,
                        availability: availability,
                        responseTime: responseTime,
                        distance: state.distance.toStringAsFixed(0),
                      );

                      NavigationService.I.pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
