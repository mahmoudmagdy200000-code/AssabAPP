import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/purchase/presentation/cubit/filter_suppliers/filter_suppliers_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/filter_suppliers/filter_suppliers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/purchase_supplier_availability_enum.dart';
import 'filter_supplier_widget_availability_section.dart';
import 'purchase_filter_distance_section.dart';

class FilterSupplierWidget extends StatelessWidget {
  final void Function(String? availability, int? timeDelivery) onApplyFilters;
  final VoidCallback onResetFilters;

  const FilterSupplierWidget({
    super.key,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

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
                        context.tr.filterSuppliersListBy,
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    const CustomDivider(),
                    16.verticalSpace,
                    const FilterSupplierWidgetAvailabilitySection(),
                    16.verticalSpace,
                    PurchaseFilterDistanceSection<
                      FilterSuppliersCubit,
                      FilterSuppliersState
                    >(
                      selector: (state) => state.distance,
                      onChangedSlider: (bloc, newValue) {
                        context.read<FilterSuppliersCubit>().setDistance(
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
                      context.read<FilterSuppliersCubit>().resetFilters();
                      onResetFilters();
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
                      final state = context.read<FilterSuppliersCubit>().state;

                      String? availability;

                      if (state.availability !=
                              PurchaseSupplierAvailabilityEnum.non ||
                          state.availability !=
                              PurchaseSupplierAvailabilityEnum.all) {
                        availability = state.availability.toString();
                      }

                      onApplyFilters(availability, state.distance.toInt());
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
