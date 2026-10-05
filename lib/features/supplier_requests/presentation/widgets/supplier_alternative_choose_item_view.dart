import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_preview_widget.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/get_supplier_items/get_supplier_items_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../purchase/presentation/widgets/purchase_search_bar.dart';
import '../../data/models/supplier_items_response.dart';
import '../../data/models/supplier_orders_response.dart';
import '../cubit/get_supplier_items/get_supplier_items_cubit.dart';
import 'supplier_item_list_view_widget.dart';

class SupplierAlternativeChooseItemView extends StatefulWidget {
  final SupplierOrderItem item;
  final ValueNotifier<Map<SupplierItem, int>> itemCountNotifier;

  const SupplierAlternativeChooseItemView({
    super.key,
    required this.item,
    required this.itemCountNotifier,
  });

  @override
  State<SupplierAlternativeChooseItemView> createState() =>
      _SupplierAlternativeChooseItemViewState();
}

class _SupplierAlternativeChooseItemViewState
    extends State<SupplierAlternativeChooseItemView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _getPurchaseBranchItems();

    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listenToScroll);

    _scrollController.dispose();
    super.dispose();
  }

  void _listenToScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300.r) {
        if (context.read<GetSupplierItemsCubit>().paginator.hasMore) {
          _getPurchaseBranchItems(loadMore: true);
        }
      }
    });
  }

  void _getPurchaseBranchItems({
    bool loadMore = false,
    String? categoryId,
    String? supplierId,
  }) {
    context.read<GetSupplierItemsCubit>().getSupplierItems(loadMore: loadMore);
  }

  void _clearAllSelections(BuildContext context) {
    widget.itemCountNotifier.value = {};
    context.read<ValidationCubit>().resetFieldValidity('items');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocSelector<
            SearchCubit<SupplierItem>,
            SearchState<SupplierItem>,
            int
          >(
            selector: (state) =>
                state is SearchSuccess<SupplierItem> ? state.results.length : 0,
            builder: (context, state) {
              return Text(
                '${context.tr.allItems} ($state)',
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              );
            },
          ),
          8.verticalSpace,
          Text(
            context.tr.chooseItemsAndRequiredQuantity,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          8.verticalSpace,
          PurchaseSearchBar(
            hintText: context.tr.searchForItems,
            isFilterActive: false,
            onChanged: (value) {
              context.read<SearchCubit<SupplierItem>>().search(
                value,
                (item, query) => item.item.name.contains(query),
              );
            },
          ),
          13.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr.similarItems,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text4,
                  ),
                ),
              ),
              10.horizontalSpace,
              ButtonTextIcon(
                onTap: () => _clearAllSelections(context),
                label: context.tr.clearAllSelections,
                padding: EdgeInsets.symmetric(vertical: 7.r, horizontal: 6.r),
                backgroundColor: context.customColor.text2,
                borderRadius: BorderRadius.circular(10.r),
                icon: Icon(Icons.close, size: 12.r),
              ),
            ],
          ),
          16.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          PurchaseItemPreviewWidget(
            itemImage: '',
            itemName: widget.item.productName,
            itemPrice: widget.item.unitPrice.toDouble(),
            itemUnit: widget.item.productUnit,
            itemQuantity: widget.item.orderedQuantity.toInt(),
          ),
          12.verticalSpace,
          Expanded(
            child: BlocConsumer<GetSupplierItemsCubit, GetSupplierItemsState>(
              listener: (context, state) {
                if (state is GetSupplierItemsSuccess) {
                  context.read<SearchCubit<SupplierItem>>().setData(
                    state.items,
                  );
                }
              },
              builder: (context, state) {
                if (state is GetSupplierItemsLoading) {
                  return const AppLoadingWidget();
                } else if (state is GetSupplierItemsFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    withBorder: false,
                    onRetry: _getPurchaseBranchItems,
                  );
                }

                return BlocBuilder<
                  SearchCubit<SupplierItem>,
                  SearchState<SupplierItem>
                >(
                  builder: (context, searchState) {
                    if (searchState is SearchSuccess<SupplierItem>) {
                      final items = searchState.results;

                      if (items.isEmpty) {
                        return const AppSearchEmptyResultWidget();
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return SupplierItemListViewWidget(
                            item: items[index],
                            itemCountNotifier: widget.itemCountNotifier,
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
          7.verticalSpace,
          20.verticalSpace,
          Row(
            children: [
              CustomTextButton(
                text: context.tr.cancel,
                onTap: () {
                  NavigationService.I.pop();
                },
                textColor: context.customColor.text1,
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 14.r, horizontal: 35.r),
                borderRadius: 12.r,
              ),
              12.horizontalSpace,
              Expanded(
                child: BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) => state.fieldsValidity['items'] ?? false,
                  builder: (context, state) {
                    return AppButton(
                      text: context.tr.rereviewReplacement,
                      onClick: () {
                        context.read<PagingCubit>().goToStep(1);
                      },
                      enabled: state,
                      padding: EdgeInsets.symmetric(vertical: 14.r),
                      borderRadius: BorderRadius.circular(12.r),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
