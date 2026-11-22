import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/app_text_form_field.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/branch_manager_expenses/data/models/add_sup_category_request.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/categories/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../data/models/sup_categories_response.dart';
import '../../data/models/update_sup_category_request.dart';

class EditItemAndExpensesListBottomSheetWidget extends StatefulWidget {
  final String categoryId;

  const EditItemAndExpensesListBottomSheetWidget({
    super.key,
    required this.categoryId,
  });

  @override
  State<EditItemAndExpensesListBottomSheetWidget> createState() =>
      _EditItemAndExpensesListBottomSheetWidgetState();
}

class _EditItemAndExpensesListBottomSheetWidgetState
    extends State<EditItemAndExpensesListBottomSheetWidget> {
  late final ValueNotifier<bool> _addCategory;
  late final ValueNotifier<int?> _updateCategory;
  late final ValueNotifier<int?> _removeCategory;
  late final TextEditingController _updateCategoryController;
  late final TextEditingController _addCategoryController;

  @override
  void initState() {
    _getSupCategories();
    _addCategory = ValueNotifier(false);
    _updateCategory = ValueNotifier(null);
    _removeCategory = ValueNotifier(null);
    _updateCategoryController = TextEditingController();
    _addCategoryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _addCategory.dispose();
    _updateCategory.dispose();
    _removeCategory.dispose();
    _updateCategoryController.dispose();
    _addCategoryController.dispose();
    super.dispose();
  }

  void _getSupCategories() {
    context.read<CategoriesCubit>().getSupCategories(
      categoryId: widget.categoryId,
    );
  }

  void _showAddEditCategoryTextField() {
    if (_addCategory.value != true) {
      _addCategory.value = true;
    }
  }

  void _hideAddEditCategoryTextField() {
    if (_addCategory.value != false) {
      _addCategory.value = false;
    }
  }

  void _showUpdateCategoryTextField(int index) {
    if (_updateCategory.value != index) {
      _updateCategory.value = index;
    }
  }

  void _hideUpdateCategoryTextField() {
    _updateCategory.value = null;
  }

  void _showRemoveCategoryWidget(int index) {
    if (_removeCategory.value != index) {
      _removeCategory.value = index;
    }
  }

  void _hideRemoveCategoryWidget() {
    _removeCategory.value = null;
  }

  void _deleteSupCategory(String id) {
    context.read<CategoriesCubit>().deleteCategories(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              AppSvg(
                assetName: AppAssets.edit,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  context.theme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
              20.verticalSpace,
              Text(
                context.tr.editItemListAndSubCategoryDetails,
                style: AppStyles.s20W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              14.verticalSpace,
              const CustomDivider(),
              14.verticalSpace,
              BlocBuilder<CategoriesCubit, CategoriesState>(
                buildWhen: (previous, current) {
                  return (current is GetSupCategoriesSuccess) ||
                      (current is CategoriesLoading) ||
                      (current is CategoriesFailure);
                },
                builder: (context, state) {
                  SupCategoriesResponse? supCategoriesResponse;
                  final supCategories = <SupCategory>[];

                  if (state is CategoriesLoading) {
                    return const AppLoadingWidget();
                  } else if (state is CategoriesFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      withBorder: false,
                      onRetry: _getSupCategories,
                    );
                  } else if (state is GetSupCategoriesSuccess) {
                    supCategoriesResponse = state.categories;
                    supCategories.addAll(
                      supCategoriesResponse.data.subcategories,
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.itemTitle,
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text4,
                        ),
                      ),
                      5.verticalSpace,
                      ContainerCustomTextField(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                supCategoriesResponse?.data.parent.name ??
                                    context.tr.notAvailable,
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr.itemSubCategories,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text4,
                            ),
                          ),
                          ButtonTextIcon(
                            onTap: () => _showAddEditCategoryTextField(),
                            label: context.tr.addItem,
                            textColor: context.theme.primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.r,
                              horizontal: 12.r,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            icon: Icon(
                              Icons.add,
                              color: context.theme.primaryColor,
                              size: 16.r,
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      ValueListenableBuilder(
                        valueListenable: _addCategory,
                        builder: (context, value, child) => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -1,
                                  child: child,
                                ),
                              ),
                          child: value
                              ? _addCategoryTextField(
                                  context: context,
                                  controller: _addCategoryController,
                                  type:
                                      supCategoriesResponse?.data.parent.type ??
                                      '',
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('empty_add'),
                                ),
                        ),
                      ),
                      14.verticalSpace,
                      if (supCategoriesResponse == null ||
                          supCategories.isEmpty)
                        Center(
                          child: Text(
                            context.tr.noSupCategories,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text4,
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          itemCount: supCategories.length,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final supCategory = supCategories[index];

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        supCategory.name,
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    AppSvgButton(
                                      assetName: AppAssets.edit,
                                      onTap: () {
                                        _updateCategoryController.text =
                                            supCategory.name;
                                        _showUpdateCategoryTextField(index);
                                      },
                                    ),
                                    12.horizontalSpace,
                                    AppSvgButton(
                                      assetName: AppAssets.trashSvg,
                                      iconSize: 14.r,
                                      iconColor: context.customColor.error,
                                      onTap: () =>
                                          _showRemoveCategoryWidget(index),
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder(
                                  valueListenable: _updateCategory,
                                  builder: (context, value, child) {
                                    return AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      transitionBuilder: (child, animation) =>
                                          FadeTransition(
                                            opacity: animation,
                                            child: SizeTransition(
                                              sizeFactor: animation,
                                              axisAlignment: -1,
                                              child: child,
                                            ),
                                          ),
                                      child: value == index
                                          ? _updateCategoryTextField(
                                              context: context,
                                              controller:
                                                  _updateCategoryController,
                                              subCategory: supCategory,
                                            )
                                          : const SizedBox.shrink(
                                              key: ValueKey('empty_add'),
                                            ),
                                    );
                                  },
                                ),
                                ValueListenableBuilder(
                                  valueListenable: _removeCategory,
                                  builder: (context, value, child) =>
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        transitionBuilder: (child, animation) =>
                                            FadeTransition(
                                              opacity: animation,
                                              child: SizeTransition(
                                                sizeFactor: animation,
                                                axisAlignment: -1,
                                                child: child,
                                              ),
                                            ),
                                        child: value == index
                                            ? _removeCategoryWidget(
                                                context: context,
                                                id: supCategory.id,
                                                categoryName: supCategory.name,
                                              )
                                            : const SizedBox.shrink(
                                                key: ValueKey('empty_remove'),
                                              ),
                                      ),
                                ),
                                14.verticalSpace,
                                const CustomDivider(),
                                14.verticalSpace,
                              ],
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addCategoryTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String type,
  }) {
    return Column(
      children: [
        AppTextFormField(
          controller: controller,
          hint: context.tr.itemSubCategories,
        ),
        10.verticalSpace,
        BlocConsumer<CategoriesCubit, CategoriesState>(
          buildWhen: (previous, current) {
            return (current is CategoriesAddLoading) ||
                (current is CategoriesAddSuccess) ||
                (current is CategoriesAddFailure);
          },
          listenWhen: (previous, current) {
            return (current is CategoriesAddSuccess) ||
                (current is CategoriesAddFailure);
          },
          listener: (context, state) {
            if (state is CategoriesAddSuccess) {
              _hideAddEditCategoryTextField();
              _getSupCategories();
            } else if (state is CategoriesAddFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
          builder: (context, state) {
            if (state is CategoriesAddLoading) {
              return const AppLoadingWidget();
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomTextButton(
                  text: context.tr.cancel,
                  onTap: () => _hideAddEditCategoryTextField(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.r,
                    vertical: 10.r,
                  ),
                ),
                12.horizontalSpace,
                CustomTextButton(
                  text: context.tr.save,
                  onTap: () => context.read<CategoriesCubit>().addSupCategory(
                    model: AddSupCategoryRequest(
                      parentId: widget.categoryId,
                      name: controller.text,
                      type: type,
                      isActive: true,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.r,
                    vertical: 10.r,
                  ),
                ),
              ],
            );
          },
        ),
        14.verticalSpace,
        const CustomDivider(),
      ],
    );
  }

  Widget _updateCategoryTextField({
    required BuildContext context,
    required TextEditingController controller,
    required SupCategory subCategory,
  }) {
    return Column(
      children: [
        10.verticalSpace,
        AppTextFormField(
          controller: controller,
          hint: context.tr.itemSubCategories,
        ),
        10.verticalSpace,
        BlocConsumer<CategoriesCubit, CategoriesState>(
          buildWhen: (previous, current) {
            return (current is CategoriesUpdateLoading) ||
                (current is CategoriesUpdateSuccess) ||
                (current is CategoriesUpdateFailure);
          },
          listenWhen: (previous, current) {
            return (current is CategoriesUpdateSuccess) ||
                (current is CategoriesUpdateFailure);
          },
          listener: (context, state) {
            if (state is CategoriesUpdateSuccess) {
              _hideUpdateCategoryTextField();
              _getSupCategories();
            } else if (state is CategoriesUpdateFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
          builder: (context, state) {
            if (state is CategoriesUpdateLoading) {
              return const AppLoadingWidget();
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomTextButton(
                  text: context.tr.cancel,
                  onTap: () => _hideUpdateCategoryTextField(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.r,
                    vertical: 10.r,
                  ),
                ),
                12.horizontalSpace,
                CustomTextButton(
                  text: context.tr.save,
                  onTap: () {
                    context.read<CategoriesCubit>().updateSupCategory(
                      id: subCategory.id,
                      model: UpdateSupCategoryRequest(
                        parentId: widget.categoryId,
                        name: controller.text,
                        type: subCategory.type,
                        isActive: true,
                      ),
                    );
                  },
                  padding: EdgeInsets.symmetric(
                    horizontal: 28.r,
                    vertical: 10.r,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _removeCategoryWidget({
    required BuildContext context,
    required String id,
    required String categoryName,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(20.r),
      margin: EdgeInsets.only(top: 10.r),
      child: Column(
        children: [
          5.verticalSpace,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(20.r),
            child: Text(
              categoryName,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ),
          12.verticalSpace,
          Text(
            context.tr.deleteSubCategoryWarning,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          20.verticalSpace,
          Text(
            context.tr.areYouSureYouWantToProceed,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          12.verticalSpace,
          BlocConsumer<CategoriesCubit, CategoriesState>(
            buildWhen: (previous, current) {
              return (current is CategoriesDeleteLoading) ||
                  (current is CategoriesDeleteSuccess) ||
                  (current is CategoriesDeleteFailure);
            },
            listenWhen: (previous, current) {
              return (current is CategoriesDeleteSuccess) ||
                  (current is CategoriesDeleteFailure);
            },
            listener: (context, state) {
              if (state is CategoriesDeleteSuccess) {
                _hideRemoveCategoryWidget();
                _getSupCategories();
              } else if (state is CategoriesDeleteFailure) {
                AppDialog.showErrorDialog(
                  context: context,
                  failure: state.failure,
                );
              }
            },
            builder: (context, state) {
              if (state is CategoriesDeleteLoading) {
                return const AppLoadingWidget();
              }

              return Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.cancel,
                      onTap: () => _hideRemoveCategoryWidget(),
                      textColor: context.customColor.text1,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: 19.r,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.deleteForever,
                      onTap: () => _deleteSupCategory(id),
                      textColor: context.customColor.reversedTextColor,
                      backgroundColor: context.customColor.error,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: 19.r,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
