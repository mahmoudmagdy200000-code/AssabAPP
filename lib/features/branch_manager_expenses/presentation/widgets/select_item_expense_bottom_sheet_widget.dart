import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/switch_button/switch_button_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_switch_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_main_category_response_entity.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/expenses_sup_category_entity.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/categories/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../domain/strategies/category_strategy.dart';
import 'select_item_expense_category_view.dart';
import 'select_item_expense_sub_category_view.dart';

class SelectItemExpenseBottomSheetWidget extends StatefulWidget {
  final Function(ExpensesSupCategoryEntity expensesSupCategoryEntity)
  onChooseSubItem;
  final CategoryStrategy type;

  const SelectItemExpenseBottomSheetWidget({
    super.key,
    required this.onChooseSubItem,
    required this.type,
  });

  @override
  State<SelectItemExpenseBottomSheetWidget> createState() =>
      _SelectItemExpenseBottomSheetWidgetState();
}

class _SelectItemExpenseBottomSheetWidgetState
    extends State<SelectItemExpenseBottomSheetWidget> {
  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  void _getCategories() {
    context.read<CategoriesCubit>().getCategories(type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.itemList,
            style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          Text(
            context.tr.itemListDesc,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          15.verticalSpace,
          Row(
            children: [
              Text(
                context.tr.showSubCategory,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              8.horizontalSpace,
              BlocBuilder<SwitchButtonCubit, bool>(
                builder: (context, state) {
                  return CustomSwitchButton(
                    value: state,
                    onChanged: (newValue) =>
                        context.read<SwitchButtonCubit>().toggle(),
                  );
                },
              ),
              const Spacer(),
              ButtonTextIcon(
                onTap: () {
                  NavigationService.I.pushNamed(
                    AppRouteName.editItemAndExpensesList,
                  );
                },
                label: context.tr.edit,
                padding: EdgeInsets.symmetric(vertical: 7.r, horizontal: 14.r),
                borderRadius: BorderRadius.circular(1000.r),
                icon: AppSvg(assetName: AppAssets.edit, width: 11.r),
              ),
            ],
          ),
          14.verticalSpace,
          const CustomDivider(),
          14.verticalSpace,
          Row(
            children: [
              AppSvg(assetName: AppAssets.search, width: 16.r),
              10.horizontalSpace,
              Expanded(
                child: CustomTextField(
                  hintText: context.tr.searchForItemsByName,
                  onChanged: (value) {
                    context
                        .read<SearchCubit<ExpensesMainCategoryResponseEntity>>()
                        .search(value, (item, query) {
                          return item.name.toLowerCase().contains(
                            query.toLowerCase(),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
          25.verticalSpace,
          Expanded(
            child: BlocBuilder<SwitchButtonCubit, bool>(
              builder: (context, switchState) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeInOutCubic,
                  switchOutCurve: Curves.easeInOutCubic,
                  transitionBuilder: (child, animation) {
                    final fade = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    );

                    final slide =
                        Tween<Offset>(
                          begin: const Offset(0.15, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        );

                    final scale = Tween<double>(begin: 0.98, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    );

                    return FadeTransition(
                      opacity: fade,
                      child: SlideTransition(
                        position: slide,
                        child: ScaleTransition(scale: scale, child: child),
                      ),
                    );
                  },
                  child: BlocConsumer<CategoriesCubit, CategoriesState>(
                    listener: (context, state) {
                      if (state is CategoriesSuccess) {
                        context
                            .read<
                              SearchCubit<ExpensesMainCategoryResponseEntity>
                            >()
                            .setData(state.categories);
                      }
                    },
                    builder: (context, state) {
                      if (state is CategoriesLoading) {
                        return const AppLoadingWidget();
                      } else if (state is CategoriesFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          withBorder: false,
                          onRetry: _getCategories,
                        );
                      }

                      return BlocBuilder<
                        SearchCubit<ExpensesMainCategoryResponseEntity>,
                        SearchState<ExpensesMainCategoryResponseEntity>
                      >(
                        builder: (context, searchState) {
                          if (searchState
                              is SearchSuccess<
                                ExpensesMainCategoryResponseEntity
                              >) {
                            final categories = searchState.results;

                            if (categories.isEmpty) {
                              return const AppSearchEmptyResultWidget();
                            }

                            return switchState
                                ? SelectItemExpenseSubCategoryView(
                                    key: const ValueKey('subCategory'),
                                    onChooseSubItem: widget.onChooseSubItem,
                                    categories: categories,
                                  )
                                : SelectItemExpenseCategoryView(
                                    key: const ValueKey('category'),
                                    categories: categories,
                                  );
                          }

                          return const SizedBox.shrink();
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
