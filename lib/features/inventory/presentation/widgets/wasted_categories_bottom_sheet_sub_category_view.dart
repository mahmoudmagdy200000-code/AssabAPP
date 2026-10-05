import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/row_text_circule_selection.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/select_item_sub_category_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/styles/app_styles.dart';

class WastedCategoriesBottomSheetSubCategoryView extends StatelessWidget {
  const WastedCategoriesBottomSheetSubCategoryView({super.key});

  void _onSelectSubItem(BuildContext context, int index) {
    context.read<ChooseItemCubit>().selectSubItem(index);
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
              itemCount: 5,
              itemBuilder: (context, index) {
                return AppGestureDetectorButton(
                  onTap: () => _onSelectItem(context, index),
                  child: BlocSelector<ChooseItemCubit, ChooseItemState, int?>(
                    selector: (state) => state.selectedIndex,
                    builder: (context, selectedIndex) {
                      const desc = 'sssssssssssssssss';

                      return SelectItemSubCategoryListViewItem(
                        title: 'Category name $index',
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

              // final selectedCategory = categories.elementAt(
              //   state.selectedIndex!,
              // );

              // final subCategories = selectedCategory.subCategories;

              // if (subCategories.isEmpty) {
              //   return Center(
              //     child: Text(
              //       context.tr.noSubCategories,
              //       style: AppStyles.s13W400.copyWith(
              //         color: context.customColor.text3,
              //       ),
              //     ),
              //   );
              // }

              return ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  // final subCategory = subCategories[index];
                  final isSelected = state.selectedSubIndex == index;

                  return AppGestureDetectorButton(
                    onTap: () => _onSelectSubItem(context, index),
                    child: Column(
                      children: [
                        RowTextCirculeSelection(
                          text: 'Item Name $index',
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
