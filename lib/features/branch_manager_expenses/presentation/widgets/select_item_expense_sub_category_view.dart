import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/row_text_circule_selection.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/select_item_sub_category_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../domain/entities/expenses_main_category_response_entity.dart';
import '../../domain/entities/expenses_sup_category_entity.dart';

class SelectItemExpenseSubCategoryView extends StatelessWidget {
  final Function(ExpensesSupCategoryEntity expensesSupCategoryEntity)
  onChooseSubItem;
  final List<ExpensesMainCategoryResponseEntity> categories;

  const SelectItemExpenseSubCategoryView({
    super.key,
    required this.onChooseSubItem,
    required this.categories,
  });

  void _onSelectSubItem(
    BuildContext context,
    int index,
    ExpensesSupCategoryEntity expensesSupCategoryEntity,
  ) {
    context.read<ChooseItemCubit>().selectSubItem(index);
    onChooseSubItem(expensesSupCategoryEntity);
    NavigationService.I.pop();
  }

  void _onSelectItem(BuildContext context, int index) {
    context.read<ChooseItemCubit>().selectItem(index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsetsDirectional.only(end: 14.r),
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return AppGestureDetectorButton(
                  onTap: () => _onSelectItem(context, index),
                  child: BlocSelector<ChooseItemCubit, ChooseItemState, int?>(
                    selector: (state) => state.selectedIndex,
                    builder: (context, selectedIndex) {
                      final desc = categories[index].subCategories
                          .map((e) => e.name)
                          .join(', ');

                      return SelectItemSubCategoryListViewItem(
                        title: categories[index].name,
                        desc: desc,
                        border: selectedIndex == index
                            ? Border.all(color: context.theme.primaryColor)
                            : null,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 120.w,
          child: BlocBuilder<ChooseItemCubit, ChooseItemState>(
            buildWhen: (prev, curr) =>
                prev.selectedIndex != curr.selectedIndex ||
                prev.selectedSubIndex != curr.selectedSubIndex,
            builder: (context, state) {
              if (state.selectedIndex == null) {
                return Center(
                  child: Text(
                    context.tr.noSubCategories,
                    textAlign: TextAlign.center,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                );
              }

              final selectedCategory = categories.elementAt(
                state.selectedIndex!,
              );

              final subCategories = selectedCategory.subCategories;

              if (subCategories.isEmpty) {
                return Center(
                  child: Text(
                    context.tr.noSubCategories,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  final subCategory = subCategories[index];
                  final isSelected = state.selectedSubIndex == index;

                  return AppGestureDetectorButton(
                    onTap: () => _onSelectSubItem(context, index, subCategory),
                    child: Column(
                      children: [
                        RowTextCirculeSelection(
                          text: subCategory.name,
                          isSelected: isSelected,
                        ),
                        25.verticalSpace,
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
