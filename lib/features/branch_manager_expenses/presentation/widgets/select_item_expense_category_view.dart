import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../domain/entities/expenses_main_category_response_entity.dart';

class SelectItemExpenseCategoryView extends StatelessWidget {
  final List<ExpensesMainCategoryResponseEntity> categories;

  const SelectItemExpenseCategoryView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return BlocSelector<ChooseItemCubit, ChooseItemState, int?>(
          selector: (state) => state.selectedIndex,
          builder: (context, selectedIndex) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categories[index].name,
                  softWrap: true,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                20.verticalSpace,
                const CustomDivider(),
                20.verticalSpace,
              ],
            );
          },
        );
      },
    );
  }
}
