import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../cubit/add_item_purchase/add_item_purchase_cubit.dart';
import '../cubit/add_item_purchase/add_item_purchase_state.dart';
import '../cubit/get_purchase_branch_items/get_purchase_branch_items_cubit.dart';
import '../cubit/get_purchase_branch_items/get_purchase_branch_items_state.dart';
import '../cubit/select_filter_item/select_filter_item_cubit.dart';
import '../widgets/filter_item_purchase_bottom_sheet.dart';
import '../widgets/item_list_view_widget.dart';
import '../../domain/strategies/create_order_strategy.dart';
import '../widgets/purchase_screen_bottom_section.dart';
import '../widgets/purchase_search_bar.dart';

class PurchaseChooseItemsView extends StatefulWidget {
  final CreateOrderStrategy strategy;

  const PurchaseChooseItemsView({super.key, required this.strategy});

  @override
  State<PurchaseChooseItemsView> createState() =>
      _PurchaseChooseItemsViewState();
}

class _PurchaseChooseItemsViewState extends State<PurchaseChooseItemsView> {
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300.r) {
      if (context.read<GetPurchaseBranchItemsCubit>().paginator.hasMore) {
        _getPurchaseBranchItems(loadMore: true);
      }
    }
  }

  void _getPurchaseBranchItems({
    bool loadMore = false,
    String? categoryId,
    String? supplierId,
  }) {
    context.read<GetPurchaseBranchItemsCubit>().getPurchaseBranchItems(
      loadMore: loadMore,
      categoryId: categoryId,
      supplierId: supplierId,
    );
  }

  void _clearAllSelections(BuildContext context) {
    context.read<AddItemPurchaseCubit>().clearItems();
    context.read<ValidationCubit>().resetFieldValidity('items');
  }

  /// Replaces stale [PurchaseBranchItemData] keys in [AddItemPurchaseCubit]
  /// with the freshly deserialized API objects, matched by [itemId].
  /// This ensures that Equatable-based map lookups in [ItemListViewWidget]
  /// still find the selected items even when other fields change between
  /// API calls (e.g. after applying/clearing a filter).
  void _reconcileSelectedItems(
    BuildContext context,
    List<PurchaseBranchItemData> apiItems,
  ) {
    final cubit = context.read<AddItemPurchaseCubit>();
    if (cubit.state.items.isEmpty) return;

    final apiByItemId = <String, PurchaseBranchItemData>{};
    for (final api in apiItems) {
      apiByItemId[api.itemId] = api;
    }

    var changed = false;
    final newItems = <PurchaseBranchItemData, int>{};
    for (final entry in cubit.state.items.entries) {
      final fresh = apiByItemId[entry.key.itemId];
      if (fresh != null && fresh != entry.key) {
        newItems[fresh] = entry.value;
        changed = true;
      } else {
        newItems[entry.key] = entry.value;
      }
    }

    if (changed) {
      cubit.replaceItems(newItems);
    }
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
            SearchCubit<PurchaseBranchItemData>,
            SearchState<PurchaseBranchItemData>,
            int
          >(
            selector: (state) => state is SearchSuccess<PurchaseBranchItemData>
                ? state.results.length
                : 0,
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
            onChanged: (value) {
              context.read<SearchCubit<PurchaseBranchItemData>>().search(
                value,
                (item, query) => item.itemName.contains(query),
              );
            },
            onFilterTap: () {
              final selectFilterItemCubit = context
                  .read<SelectFilterItemCubit>();
              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: selectFilterItemCubit),
                    BlocProvider(
                      create: (context) => ValidationCubit(
                        requiredFields: {'filterType', 'filterId'},
                      ),
                    ),
                  ],
                  child: FilterItemPurchaseBottomSheet(
                    onClearFilter: () {
                      _getPurchaseBranchItems();
                    },
                    onApplyFilter: (categoryId, supplierId) {
                      _getPurchaseBranchItems(
                        categoryId: categoryId,
                        supplierId: supplierId,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          13.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr.recentSelections,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text4,
                  ),
                ),
              ),
              10.horizontalSpace,
              BlocSelector<AddItemPurchaseCubit, AddItemPurchaseState, bool>(
                selector: (state) =>
                    state.items.values.any((quantity) => quantity > 0),
                builder: (context, state) {
                  if (!state) {
                    return const SizedBox.shrink();
                  }

                  return ButtonTextIcon(
                    onTap: () => _clearAllSelections(context),
                    label: context.tr.clearAllSelections,
                    padding: EdgeInsets.symmetric(
                      vertical: 7.r,
                      horizontal: 6.r,
                    ),
                    backgroundColor: context.customColor.text2,
                    borderRadius: BorderRadius.circular(10.r),
                    icon: Icon(Icons.close, size: 12.r),
                  );
                },
              ),
            ],
          ),
          16.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          Expanded(
            child:
                BlocConsumer<
                  GetPurchaseBranchItemsCubit,
                  GetPurchaseBranchItemsState
                >(
                  listener: (context, state) {
                    if (state is GetPurchaseBranchItemsSuccess) {
                      context
                          .read<SearchCubit<PurchaseBranchItemData>>()
                          .setData(state.response);

                      // Refresh selected item keys to match the newly-fetched
                      // API objects so Equatable lookups don't break when
                      // mutable fields (qty, price, etc.) change between calls.
                      _reconcileSelectedItems(context, state.response);

                      // Reconcile draft items with API items via addItem().
                      widget.strategy.onItemsLoaded(context, state.response);
                    }
                  },
                  builder: (context, state) {
                    if (state is GetPurchaseBranchItemsLoading) {
                      return const AppLoadingWidget();
                    } else if (state is GetPurchaseBranchItemsFailure) {
                      return AppFailureWidget(
                        failure: state.failure,
                        withBorder: false,
                        onRetry: _getPurchaseBranchItems,
                      );
                    }

                    return BlocBuilder<
                      SearchCubit<PurchaseBranchItemData>,
                      SearchState<PurchaseBranchItemData>
                    >(
                      builder: (context, searchState) {
                        if (searchState
                            is SearchSuccess<PurchaseBranchItemData>) {
                          final items = searchState.results;

                          if (items.isEmpty) {
                            return const AppSearchEmptyResultWidget();
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ItemListViewWidget(item: items[index]);
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
          const PurchaseScreenBottomSection(),
        ],
      ),
    );
  }
}
