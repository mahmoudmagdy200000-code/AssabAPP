import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../../inventory/data/models/wasted_damage_items_response.dart';
import '../cubit/get_wasted_damage_items/get_wasted_damage_items_cubit.dart';
import '../cubit/get_wasted_damage_items/get_wasted_damage_items_state.dart';
import '../cubit/wasted_selected_items/wasted_selected_items_cubit.dart';

class WastedCategoriesBottomSheetWidget extends StatefulWidget {
  const WastedCategoriesBottomSheetWidget({super.key});

  @override
  State<WastedCategoriesBottomSheetWidget> createState() =>
      _WastedCategoriesBottomSheetWidgetState();
}

class _WastedCategoriesBottomSheetWidgetState
    extends State<WastedCategoriesBottomSheetWidget> {
  final Set<String> _selectedItemIds = {};
  List<WastedDamageItemData> _allItems = [];
  String _searchQuery = '';
  late final Set<String> _alreadySelectedIds;

  @override
  void initState() {
    super.initState();
    _alreadySelectedIds = context
        .read<WastedSelectedItemsCubit>()
        .state
        .items
        .map((i) => i.id)
        .toSet();
    _getWastedDamageItems();
  }

  void _getWastedDamageItems() {
    context.read<GetWastedDamageItemsCubit>().getWastedDamageItems();
  }

  void _toggleItem(String itemId) {
    setState(() {
      if (_selectedItemIds.contains(itemId)) {
        _selectedItemIds.remove(itemId);
      } else {
        _selectedItemIds.add(itemId);
      }
    });
  }

  void _onAddPressed() {
    final selectedItems = _allItems
        .where((item) => _selectedItemIds.contains(item.id))
        .toList();

    if (selectedItems.isNotEmpty) {
      context.read<WastedSelectedItemsCubit>().addItems(selectedItems);
    }

    NavigationService.I.pop();
  }

  List<WastedDamageItemData> get _filteredItems {
    final available = _allItems.where(
      (item) => !_alreadySelectedIds.contains(item.id),
    );
    if (_searchQuery.isEmpty) return available.toList();
    return available
        .where(
          (item) =>
              item.itemName.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.itemList,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    context.tr.itemListDesc,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
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
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  15.verticalSpace,
                  Expanded(
                    child:
                        BlocConsumer<
                          GetWastedDamageItemsCubit,
                          GetWastedDamageItemsState
                        >(
                          listener: (context, state) {
                            if (state is GetWastedDamageItemsSuccess) {
                              _allItems = state.response.data;
                            }
                          },
                          builder: (context, state) {
                            if (state is GetWastedDamageItemsLoading) {
                              return const AppLoadingWidget();
                            } else if (state is GetWastedDamageItemsFailure) {
                              return AppFailureWidget(
                                failure: state.failure,
                                onRetry: _getWastedDamageItems,
                              );
                            }

                            final items = _filteredItems;

                            if (items.isEmpty) {
                              return const AppSearchEmptyResultWidget();
                            }

                            return ListView.builder(
                              itemCount: items.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final isSelected = _selectedItemIds.contains(
                                  item.id,
                                );

                                return Column(
                                  children: [
                                    Row(
                                      spacing: 12.w,
                                      children: [
                                        PurchaseItemImage(image: item.itemLogo),
                                        Expanded(
                                          child: Text(
                                            item.itemName,
                                            style: AppStyles.s16W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                        ),
                                        AppCheckBox(
                                          onChanged: (_) =>
                                              _toggleItem(item.id),
                                          value: isSelected,
                                        ),
                                      ],
                                    ),
                                    12.verticalSpace,
                                  ],
                                );
                              },
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            AppButton(
              onClick: _onAddPressed,
              text: _selectedItemIds.isEmpty
                  ? context.tr.add
                  : '${context.tr.add} (${_selectedItemIds.length})',
              enabled: _selectedItemIds.isNotEmpty,
              borderRadius: BorderRadius.circular(18.r),
            ),
          ],
        ),
      ),
    );
  }
}
