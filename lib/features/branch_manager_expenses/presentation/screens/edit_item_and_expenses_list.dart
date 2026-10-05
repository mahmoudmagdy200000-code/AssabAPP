import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/search/search_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_back_button.dart';
import '../../domain/entities/expenses_main_category_response_entity.dart';
import '../../domain/entities/expenses_sup_category_entity.dart';
import '../cubit/categories/categories_cubit.dart';
import '../widgets/edit_item_and_expenses_list_bottom_sheet_widget.dart';

class EditItemAndExpensesList extends StatefulWidget {
  const EditItemAndExpensesList({super.key});

  @override
  State<EditItemAndExpensesList> createState() =>
      _EditItemAndExpensesListState();
}

class _EditItemAndExpensesListState extends State<EditItemAndExpensesList> {
  late final ValueNotifier<int?> _showSubCategoriesNotifier;

  @override
  void initState() {
    super.initState();
    _showSubCategoriesNotifier = ValueNotifier(null);
    context.read<CategoriesCubit>().getAllCategories();
  }

  @override
  void dispose() {
    _showSubCategoriesNotifier.dispose();
    super.dispose();
  }

  void _showEditItemAndExpensesListBottomSheet(String categoryId) {
    AppBottomSheet.customPageRoute(
      context,
      (context) => BlocProvider(
        create: (context) => getIt<CategoriesCubit>(),
        child: EditItemAndExpensesListBottomSheetWidget(categoryId: categoryId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          25.verticalSpace,
          _topSection(context),
          Expanded(
            child: Container(
              color: context.customColor.text2,
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      AppSvg(
                        assetName: AppAssets.search,
                        width: 20.r,
                        height: 20.r,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: CustomTextField(
                          hintText: context.tr.searchForItemsByName,
                          onChanged: (value) {
                            context
                                .read<
                                  SearchCubit<
                                    ExpensesMainCategoryResponseEntity
                                  >
                                >()
                                .search(
                                  value,
                                  (item, query) => item.name
                                      .toLowerCase()
                                      .contains(query.toLowerCase()),
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  Expanded(
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
                          return AppFailureWidget(failure: state.failure);
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

                              return ListView.builder(
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    key: UniqueKey(),
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const AppSvg(
                                            assetName: AppAssets.reorderSvg,
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: Column(
                                              children: [
                                                _topSectionSubCategoryWidgetList(
                                                  context: context,
                                                  index: index,
                                                  categoryName:
                                                      categories[index].name,
                                                ),
                                                4.verticalSpace,
                                                _valueListenableBuilderSubCategoryList(
                                                  context: context,
                                                  index: index,
                                                  subCategories:
                                                      categories[index]
                                                          .subCategories,
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          AppGestureDetectorButton(
                                            onTap: () =>
                                                _showEditItemAndExpensesListBottomSheet(
                                                  categories[index].id,
                                                ),
                                            child: AppSvg(
                                              assetName: AppAssets.edit,
                                              width: 16.r,
                                            ),
                                          ),
                                        ],
                                      ),
                                      12.verticalSpace,
                                      CustomDivider(
                                        color: context.customColor.border,
                                      ),
                                      12.verticalSpace,
                                    ],
                                  );
                                },
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    return AppPaddingWidget(
      child: Row(
        children: [
          AppBackButton(
            isTransparent: true,
            iconColor: context.customColor.text1,
          ),
          5.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.itemList,
                style: AppStyles.s20W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              Text(
                context.tr.addEditDeleteItemExpenses,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topSectionSubCategoryWidgetList({
    required BuildContext context,
    required int index,
    required String categoryName,
  }) {
    return AppGestureDetectorButton(
      onTap: () => _showSubCategoriesNotifier.value =
          _showSubCategoriesNotifier.value == index ? null : index,
      child: Row(
        children: [
          Text(
            '$index $categoryName',
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18.r),
        ],
      ),
    );
  }

  Widget _valueListenableBuilderSubCategoryList({
    required BuildContext context,
    required int index,
    required List<ExpensesSupCategoryEntity> subCategories,
  }) {
    return ValueListenableBuilder(
      valueListenable: _showSubCategoriesNotifier,
      builder: (context, value, child) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutBack,
          child: value == index
              ? _buildSubCategoryList(context, subCategories)
              : Text(
                  subCategories.join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildSubCategoryList(
    BuildContext context,
    List<ExpensesSupCategoryEntity> subCategories,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubCategoryWidgetListView(
            context,
            context.tr.chooseSubCategory,
            textColor: context.customColor.text3,
          ),
          12.verticalSpace,
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subCategories.length,
            itemBuilder: (context, subIndex) {
              return Column(
                children: [
                  _buildSubCategoryWidgetListView(
                    context,
                    subCategories[subIndex].name,
                  ),
                  12.verticalSpace,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryWidgetListView(
    BuildContext context,
    String expenseName, {
    Color? textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          expenseName,
          style: AppStyles.s12W500.copyWith(
            color: textColor ?? context.customColor.text1,
          ),
        ),
        12.verticalSpace,
        CustomDivider(color: context.customColor.border),
      ],
    );
  }
}
