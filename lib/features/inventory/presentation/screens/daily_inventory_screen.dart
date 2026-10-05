import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/inventory/data/models/daily_inventory_items_response.dart';
import 'package:assab/features/inventory/presentation/cubit/get_daily_inventory_items/get_daily_inventory_items_cubit.dart';
import 'package:assab/features/inventory/presentation/cubit/get_daily_inventory_items/get_daily_inventory_items_state.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyInventoryScreen extends StatefulWidget {
  const DailyInventoryScreen({super.key});

  @override
  State<DailyInventoryScreen> createState() => _DailyInventoryScreenState();
}

class _DailyInventoryScreenState extends State<DailyInventoryScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<GetDailyInventoryItemsCubit>()
        .getInventoryDailyQuickBranchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child:
            BlocBuilder<
              GetDailyInventoryItemsCubit,
              GetDailyInventoryItemsState
            >(
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.dailyQuickInventory,
                            style: AppStyles.s20W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            context.tr.selectedProductsForTodaysInventory(
                              _getItemsCount(state),
                            ),
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            children: [
                              Container(
                                width: 5.w,
                                height: 46.h,
                                color: context.theme.primaryColor,
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${context.tr.note}💡',
                                      style: AppStyles.s14W600.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    5.verticalSpace,
                                    Text(
                                      context
                                          .tr
                                          .productsPreSelectedByManagement,
                                      style: AppStyles.s14W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          Expanded(child: _buildItemsList(context, state)),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    AppButton(
                      onClick: () {
                        final items = _getItems(state);

                        NavigationService.I.pushNamed(
                          AppRouteName
                              .dailyInventoryChooseInventoryMethodScreen,
                          arguments: items,
                        );
                      },
                      text: context.tr.startDailyQuickInventory,
                      enabled:
                          state is GetDailyInventoryItemsSuccess &&
                          state.items.isNotEmpty,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }

  String _getItemsCount(GetDailyInventoryItemsState state) {
    if (state is GetDailyInventoryItemsSuccess) {
      return state.items.length.toString();
    }
    return '0';
  }

  List<DailyInventoryItem> _getItems(GetDailyInventoryItemsState state) {
    if (state is GetDailyInventoryItemsSuccess) {
      return state.items;
    }
    return [];
  }

  Widget _buildItemsList(
    BuildContext context,
    GetDailyInventoryItemsState state,
  ) {
    if (state is GetDailyInventoryItemsLoading) {
      return const AppLoadingWidget();
    }

    if (state is GetDailyInventoryItemsFailure) {
      return AppFailureWidget(failure: state.failure);
    }

    if (state is GetDailyInventoryItemsSuccess) {
      final items = state.items;

      if (items.isEmpty) {
        return Center(
          child: Text(
            context.tr.noProductsSelectedForToday,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Column(
            children: [
              Row(
                children: [
                  PurchaseItemImage(image: item.itemLogo),
                  12.horizontalSpace,
                  Text(
                    item.itemName,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
              if (index != items.length - 1) 6.verticalSpace,
            ],
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
