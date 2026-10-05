import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/inventory/presentation/cubit/get_monthly_pending_products/get_monthly_pending_products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../data/models/monthly_inventory_pending_products_response.dart';
import '../cubit/get_monthly_pending_products/get_monthly_pending_products_cubit.dart';
import '../widgets/handled_qty_by_another_employee_monthly_inventory_pending_products_widget.dart';
import '../widgets/update_qty_monthly_inventory_pending_products_widget.dart';

class MonthlyInventoryPendingProductsScreen extends StatefulWidget {
  final String sessionId;

  const MonthlyInventoryPendingProductsScreen({
    super.key,
    required this.sessionId,
  });

  @override
  State<MonthlyInventoryPendingProductsScreen> createState() =>
      _MonthlyInventoryPendingProductsScreenState();
}

class _MonthlyInventoryPendingProductsScreenState
    extends State<MonthlyInventoryPendingProductsScreen> {
  @override
  void initState() {
    super.initState();

    _getMonthlyPendingProducts();
  }

  void _getMonthlyPendingProducts() {
    context
        .read<GetMonthlyPendingProductsCubit>()
        .getMonthlyInventoryPendingProducts(inventoryId: widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocSelector<
              SearchCubit<MonthlyInventoryPendingProduct>,
              SearchState<MonthlyInventoryPendingProduct>,
              int?
            >(
              selector: (state) {
                if (state is SearchSuccess<MonthlyInventoryPendingProduct>) {
                  return state.results.length;
                }

                return null;
              },
              builder: (context, count) {
                return Text(
                  context.tr.pendingProducts(count ?? 0),
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                );
              },
            ),
            5.verticalSpace,
            Text(
              context.tr.chooseAProductToStartTheInventoryCount,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            ContainerCustomTextField(
              padding: EdgeInsets.all(9.r),
              borderRadius: BorderRadius.circular(12.r),
              child: Row(
                children: [
                  AppSvg(
                    assetName: AppAssets.search,
                    colorFilter: ColorFilter.mode(
                      context.theme.primaryColor,
                      BlendMode.srcIn,
                    ),
                    width: 13.r,
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: CustomTextField(
                      hintText: context.tr.searchForItems,
                      onChanged: (value) {
                        context
                            .read<SearchCubit<MonthlyInventoryPendingProduct>>()
                            .search(
                              value,
                              (item, query) => item.itemName
                                  .toLowerCase()
                                  .contains(query.toLowerCase()),
                            );
                      },
                    ),
                  ),
                  // 10.horizontalSpace,
                  // AppGestureDetectorButton(
                  //   onTap: () {},
                  //   child: AppSvg(assetName: AppAssets.filter, width: 13.r),
                  // ),
                ],
              ),
            ),
            14.verticalSpace,
            const CustomDivider(),
            14.verticalSpace,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.all(4.r),
                child:
                    BlocListener<
                      GetMonthlyPendingProductsCubit,
                      GetMonthlyPendingProductsState
                    >(
                      listener: (context, state) {
                        if (state is GetMonthlyPendingProductsSuccess) {
                          context
                              .read<
                                SearchCubit<MonthlyInventoryPendingProduct>
                              >()
                              .setData(state.response.data);
                        }
                      },
                      child:
                          BlocBuilder<
                            GetMonthlyPendingProductsCubit,
                            GetMonthlyPendingProductsState
                          >(
                            builder: (context, state) {
                              if (state is GetMonthlyPendingProductsLoading) {
                                return const AppLoadingWidget();
                              } else if (state
                                  is GetMonthlyPendingProductsFailure) {
                                return AppFailureWidget(
                                  failure: state.failure,
                                  withBorder: false,
                                  onRetry: _getMonthlyPendingProducts,
                                );
                              }

                              return BlocBuilder<
                                SearchCubit<MonthlyInventoryPendingProduct>,
                                SearchState<MonthlyInventoryPendingProduct>
                              >(
                                builder: (context, state) {
                                  final products =
                                      <MonthlyInventoryPendingProduct>[];
                                  if (state
                                      is SearchSuccess<
                                        MonthlyInventoryPendingProduct
                                      >) {
                                    products.addAll(state.results);
                                  }

                                  if (products.isEmpty) {
                                    return const AppSearchEmptyResultWidget();
                                  }

                                  return ListView.builder(
                                    itemCount: products.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      final product = products[index];

                                      return _ProductItem(
                                        productId: product.id,
                                        inventoryId: widget.sessionId,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final String productId;
  final String inventoryId;

  const _ProductItem({required this.productId, required this.inventoryId});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      GetMonthlyPendingProductsCubit,
      GetMonthlyPendingProductsState,
      MonthlyInventoryPendingProduct?
    >(
      selector: (state) {
        if (state is GetMonthlyPendingProductsSuccess) {
          return state.response.productsMap[productId];
        }

        return null;
      },
      builder: (context, product) {
        if (product == null) return const SizedBox.shrink();

        if (product.isHandledByAnotherEmployee) {
          return HandledQtyByAnotherEmployeeMonthlyInventoryPendingProductsWidget(
            product: product,
          );
        }

        return UpdateQtyMonthlyInventoryPendingProductsWidget(
          product: product,
          inventoryId: inventoryId,
        );
      },
    );
  }
}
