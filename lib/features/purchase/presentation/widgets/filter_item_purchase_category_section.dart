import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/purchase/presentation/cubit/select_filter_item/select_filter_item_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/select_filter_item/select_filter_item_state.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/select_filter_item_type.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/selection_circule.dart';

class FilterItemPurchaseCategorySection extends StatelessWidget {
  final ValueNotifier<int> isExpandedNotifier;

  const FilterItemPurchaseCategorySection({
    super.key,
    required this.isExpandedNotifier,
  });

  void _selectCategory(BuildContext context, String id) {
    context.read<SelectFilterItemCubit>().selectFilterItem(
      filterType: SelectFilterItemType.category,
      id: id.toString(),
    );

    _validateSelection(
      context: context,
      fieldName: 'filterType',
      value: SelectFilterItemType.category.value,
      isValid: true,
    );

    _validateSelection(
      context: context,
      fieldName: 'filterId',
      value: id,
      isValid: true,
    );
  }

  void _validateSelection({
    required BuildContext context,
    required String fieldName,
    required String value,
    required bool isValid,
  }) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: fieldName,
      value: value,
      isValid: isValid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${context.tr.category} (80)',
                  style: AppStyles.s14W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: isExpandedNotifier,
                  builder: (context, value, child) {
                    return AppGestureDetectorButton(
                      onTap: () {
                        isExpandedNotifier.value = value == 0 ? 1 : 0;
                      },
                      child: Icon(
                        value == 0
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18.r,
                      ),
                    );
                  },
                ),
              ],
            ),
            6.verticalSpace,
            Text(
              context.tr.resultsWillIncludeSubcategoriesOfTheSelectedItem,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: isExpandedNotifier,
              builder: (context, value, child) {
                if (value != 0) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    6.verticalSpace,
                    PurchaseSearchBar(
                      hintText: context.tr.egBeveragesOrMeat,
                      searchIconSize: 20.r,
                      searchIconColor: context.customColor.text1,
                      isFilterActive: false,
                      borderRadius: 1000.r,
                    ),
                    12.verticalSpace,
                    SizedBox(
                      height: (MediaQuery.of(context).size.height) - 430.h,
                      child: ListView.builder(
                        itemCount: 10,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return AppGestureDetectorButton(
                            onTap: () =>
                                _selectCategory(context, index.toString()),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Beverages',
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          Text(
                                            'Coke, Fanta, Water, Pepsi, Prime, +4 More...',
                                            style: AppStyles.s12W400.copyWith(
                                              color: context.customColor.text3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    BlocSelector<
                                      SelectFilterItemCubit,
                                      SelectFilterItemState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state.selectedFilterType ==
                                              SelectFilterItemType.category &&
                                          (state.selectedId ?? '') ==
                                              index.toString(),
                                      builder: (context, isSelected) {
                                        return SelectionCircule(
                                          isSelected: isSelected,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                12.verticalSpace,
                                const CustomDivider(),
                                12.verticalSpace,
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
