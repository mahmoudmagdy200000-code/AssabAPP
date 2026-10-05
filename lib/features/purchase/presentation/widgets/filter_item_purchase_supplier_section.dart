import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/search/search_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/select_filter_item_type.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/selection_circule.dart';
import '../../data/models/suppliers_for_filter_purchase_items_response.dart';
import '../cubit/get_suppliers_for_filter/get_suppliers_for_filter_cubit.dart';
import '../cubit/get_suppliers_for_filter/get_suppliers_for_filter_state.dart';
import '../cubit/select_filter_item/select_filter_item_cubit.dart';
import '../cubit/select_filter_item/select_filter_item_state.dart';
import 'purchase_search_bar.dart';

class FilterItemPurchaseSupplierSection extends StatefulWidget {
  final ValueNotifier<int> isExpandedNotifier;

  const FilterItemPurchaseSupplierSection({
    super.key,
    required this.isExpandedNotifier,
  });

  @override
  State<FilterItemPurchaseSupplierSection> createState() =>
      _FilterItemPurchaseSupplierSectionState();
}

class _FilterItemPurchaseSupplierSectionState
    extends State<FilterItemPurchaseSupplierSection> {
  late final ScrollController _scrollController;

  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _getSuppliers();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);

    _scrollController.dispose();
    super.dispose();
  }

  void _getSuppliers() {
    context.read<GetSuppliersForFilterCubit>().getSuppliers();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300.h) {
      if (context.read<GetSuppliersForFilterCubit>().paginator.hasMore) {
        context.read<GetSuppliersForFilterCubit>().getSuppliers(loadMore: true);
      }
    }
  }

  void _selectSupplier(BuildContext context, String id, String name) {
    context.read<SelectFilterItemCubit>().selectFilterItem(
      filterType: SelectFilterItemType.supplier,
      id: id.toString(),
      name: name,
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
                BlocSelector<
                  SearchCubit<SuppliersForFilterPurchaseItemsResponseData>,
                  SearchState<SuppliersForFilterPurchaseItemsResponseData>,
                  int
                >(
                  selector: (state) =>
                      state
                          is SearchSuccess<
                            SuppliersForFilterPurchaseItemsResponseData
                          >
                      ? state.results.length
                      : 0,
                  builder: (context, state) {
                    return Text(
                      '${context.tr.supplier} ($state)',
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: widget.isExpandedNotifier,
                  builder: (context, value, child) {
                    return AppGestureDetectorButton(
                      onTap: () {
                        widget.isExpandedNotifier.value = value == 0 ? 1 : 0;
                      },
                      child: Icon(
                        value == 1
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
              context
                  .tr
                  .resultsWillIncludeItemListAssociatedToTheSelectedSupplier,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: widget.isExpandedNotifier,
              builder: (context, value, child) {
                // return const SizedBox.shrink();

                if (value != 1 && !_isExpanded) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    6.verticalSpace,
                    PurchaseSearchBar(
                      hintText: context.tr.egSuppliersName,
                      searchIconSize: 20.r,
                      searchIconColor: context.customColor.text1,
                      isFilterActive: false,
                      borderRadius: 1000.r,
                      onChanged: (value) {
                        context
                            .read<
                              SearchCubit<
                                SuppliersForFilterPurchaseItemsResponseData
                              >
                            >()
                            .search(
                              value,
                              (supplier, query) =>
                                  supplier.name.contains(query),
                            );
                      },
                    ),
                    12.verticalSpace,
                    SizedBox(
                      height: (MediaQuery.of(context).size.height) - 430.h,
                      child:
                          BlocConsumer<
                            GetSuppliersForFilterCubit,
                            GetSuppliersForFilterState
                          >(
                            listener: (context, state) {
                              if (state is GetSuppliersForFilterSuccess) {
                                context
                                    .read<
                                      SearchCubit<
                                        SuppliersForFilterPurchaseItemsResponseData
                                      >
                                    >()
                                    .setData(state.suppliers);

                                _isExpanded = false;
                              }
                            },
                            builder: (context, state) {
                              if (state is GetSuppliersForFilterLoading) {
                                return const AppLoadingWidget();
                              } else if (state
                                  is GetSuppliersForFilterFailure) {
                                return AppFailureWidget(
                                  failure: state.failure,
                                  withBorder: false,
                                  onRetry: _getSuppliers,
                                );
                              }

                              return BlocBuilder<
                                SearchCubit<
                                  SuppliersForFilterPurchaseItemsResponseData
                                >,
                                SearchState<
                                  SuppliersForFilterPurchaseItemsResponseData
                                >
                              >(
                                builder: (context, state) {
                                  if (state
                                      is SearchSuccess<
                                        SuppliersForFilterPurchaseItemsResponseData
                                      >) {
                                    final suppliers = state.results;

                                    if (suppliers.isEmpty) {
                                      return const AppSearchEmptyResultWidget();
                                    }

                                    return ListView.builder(
                                      controller: _scrollController,
                                      itemCount: suppliers.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final supplier = suppliers[index];

                                        return AppGestureDetectorButton(
                                          onTap: () => _selectSupplier(
                                            context,
                                            supplier.id,
                                            supplier.name,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          supplier.name,
                                                          style: AppStyles
                                                              .s14W500
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text1,
                                                              ),
                                                        ),
                                                        Text(
                                                          context
                                                              .tr
                                                              .associatedItems,
                                                          style: AppStyles
                                                              .s12W400
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text3,
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
                                                            SelectFilterItemType
                                                                .supplier &&
                                                        (state.selectedId ??
                                                                '') ==
                                                            supplier.id,
                                                    builder:
                                                        (context, isSelected) {
                                                          return SelectionCircule(
                                                            isSelected:
                                                                isSelected,
                                                          );
                                                        },
                                                  ),
                                                ],
                                              ),
                                              if (index <
                                                  suppliers.length - 1) ...[
                                                12.verticalSpace,
                                                const CustomDivider(),
                                                12.verticalSpace,
                                              ],
                                            ],
                                          ),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
