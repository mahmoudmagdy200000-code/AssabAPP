import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/custody/presentation/widgets/custody_empty_widget.dart';
import 'package:assab/features/inventory/presentation/cubit/get_monthly_completed_products/get_monthly_completed_products_state.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../purchase/presentation/widgets/purchase_app_bar.dart';
import '../../data/models/monthly_inventory_pending_products_response.dart';
import '../../domain/strategies/inventory_user_type.dart';
import '../cubit/get_monthly_completed_products/get_monthly_completed_products_cubit.dart';
import '../widgets/monthly_inventory_progress.dart';

class MonthlyInventoryStartScreen extends StatefulWidget {
  final InventoryUserType userType;
  final String sessionId;

  const MonthlyInventoryStartScreen({
    super.key,
    required this.sessionId,
    required this.userType,
  });

  @override
  State<MonthlyInventoryStartScreen> createState() =>
      _MonthlyInventoryStartScreenState();
}

class _MonthlyInventoryStartScreenState
    extends State<MonthlyInventoryStartScreen> {
  late final GetMonthlyCompletedProductsCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = context.read<GetMonthlyCompletedProductsCubit>();
  }

  @override
  void dispose() {
    _cubit.unsubscribeFromMonthlyInventoryProducts(
      inventoryId: widget.sessionId,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.monthlyRegularInventorySetup,
            subtitle: context.tr.simplifiedMonthlyInventorySetup,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const MonthlyInventoryProgress(),
                        12.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child:
                                  BlocSelector<
                                    GetMonthlyCompletedProductsCubit,
                                    GetMonthlyCompletedProductsState,
                                    GetMonthlyCompletedProductsSuccess?
                                  >(
                                    selector: (state) {
                                      return state
                                              is GetMonthlyCompletedProductsSuccess
                                          ? state
                                          : null;
                                    },
                                    builder: (context, state) {
                                      return Text(
                                        context.tr.completedProductsCount(
                                          state?.response.completed ?? 0,
                                        ),
                                        style: AppStyles.s14W500.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                            10.horizontalSpace,
                            ButtonTextIcon(
                              onTap: () {
                                NavigationService.I.pushNamed(
                                  AppRouteName
                                      .monthlyInventoryPendingProductsScreen,
                                  arguments: widget.sessionId,
                                );
                              },
                              label: context.tr.startCounting,
                              icon: Icon(
                                Icons.add,
                                size: 16.r,
                                color: context.customColor.reversedTextColor,
                              ),
                              backgroundColor: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(1000.r),
                              borderColor: Colors.transparent,
                              padding: EdgeInsets.all(10.r),
                              textColor: context.customColor.reversedTextColor,
                              spaceBetweenTextAndIcon: 7.w,
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.all(8.r),
                            child:
                                BlocBuilder<
                                  GetMonthlyCompletedProductsCubit,
                                  GetMonthlyCompletedProductsState
                                >(
                                  builder: (context, state) {
                                    final products =
                                        <MonthlyInventoryPendingProduct>[];

                                    if (state
                                        is GetMonthlyCompletedProductsLoading) {
                                      return const AppLoadingWidget();
                                    } else if (state
                                        is GetMonthlyCompletedProductsFailure) {
                                      return AppFailureWidget(
                                        failure: state.failure,
                                        onRetry: () {
                                          context
                                              .read<
                                                GetMonthlyCompletedProductsCubit
                                              >()
                                              .getMonthlyInventoryCompletedProducts(
                                                inventoryId: widget.sessionId,
                                              );
                                        },
                                      );
                                    } else if (state
                                        is GetMonthlyCompletedProductsSuccess) {
                                      products.addAll(
                                        state.response.completedProducts,
                                      );
                                    }

                                    if (products.isEmpty) {
                                      return CustodyEmptyWidget(
                                        asset: AppAssets.clockPng,
                                        title: context.tr.noInventories,
                                        desc: context.tr.noInventoriesDesc,
                                      );
                                    }

                                    return ListView.builder(
                                      itemCount: products.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final product = products[index];

                                        return Container(
                                          decoration: BoxDecoration(
                                            color: context
                                                .customColor
                                                .reversedTextColor,
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.r,
                                            vertical: 12.r,
                                          ),
                                          margin: EdgeInsets.only(
                                            bottom: index < products.length - 1
                                                ? 8.r
                                                : 0,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  PurchaseItemImage(size: 15.r),
                                                  12.horizontalSpace,
                                                  Expanded(
                                                    child: Text(
                                                      product.itemName,
                                                      style: AppStyles.s14W500
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text1,
                                                          ),
                                                    ),
                                                  ),
                                                  12.horizontalSpace,
                                                  AppSvgButton(
                                                    assetName: AppAssets.offEye,
                                                    onTap: () {},
                                                    iconSize: 14.r,
                                                    iconColor: context
                                                        .customColor
                                                        .text3,
                                                  ),
                                                  12.horizontalSpace,
                                                  AppSvgButton(
                                                    assetName: AppAssets.edit,
                                                    onTap: () {
                                                      NavigationService.I.pushNamed(
                                                        AppRouteName
                                                            .monthlyInventoryPendingProductsScreen,
                                                        arguments:
                                                            widget.sessionId,
                                                      );
                                                    },
                                                    iconSize: 14.r,
                                                    bgColor: context
                                                        .customColor
                                                        .text2,
                                                  ),
                                                ],
                                              ),
                                              10.verticalSpace,
                                              const CustomDivider(),
                                              10.verticalSpace,
                                              Row(
                                                children: [
                                                  AppSvg(
                                                    assetName: AppAssets.box,
                                                    width: 16.r,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          context
                                                              .customColor
                                                              .text3,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                  12.horizontalSpace,
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            context.tr.quantity,
                                                            style: AppStyles
                                                                .s13W400
                                                                .copyWith(
                                                                  color: context
                                                                      .customColor
                                                                      .text3,
                                                                ),
                                                          ),
                                                        ),
                                                        12.horizontalSpace,
                                                        Flexible(
                                                          child: Text(
                                                            '${product.quantityInventory} ${product.unit}',
                                                            style: AppStyles
                                                                .s13W600
                                                                .copyWith(
                                                                  color: context
                                                                      .customColor
                                                                      .text1,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.userType.buildButtonSection(
                    sessionId: widget.sessionId,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
