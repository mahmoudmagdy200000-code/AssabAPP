import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/purchase/presentation/cubit/get_purchase_products_officer_details/get_purchase_products_officer_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/purchase_create_order_request.dart';
import '../../data/models/source_local_model.dart';
import '../cubit/get_purchase_products_officer_details/get_purchase_products_officer_details_cubit.dart';
import 'purchase_item_image.dart';

class PurchasingOfficerSummaryViewProductDetailsSection
    extends StatelessWidget {
  final SourceLocalModel source;
  final void Function(double total) totalSavings;
  final PurchaseCreateOrderRequest createOrderRequest;

  const PurchasingOfficerSummaryViewProductDetailsSection({
    super.key,
    required this.source,
    required this.totalSavings,
    required this.createOrderRequest,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetPurchaseProductsOfficerDetailsCubit,
      GetPurchaseProductsOfficerDetailsState
    >(
      builder: (context, state) {
        if (state is GetPurchaseProductsOfficerDetailsLoading) {
          return const AppLoadingWidget().sliverBoxAdapter;
        } else if (state is GetPurchaseProductsOfficerDetailsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            withBorder: false,
            onRetry: () {
              context
                  .read<GetPurchaseProductsOfficerDetailsCubit>()
                  .getPurchaseProductOfficerDetails();
            },
          ).sliverBoxAdapter;
        } else if (state is GetPurchaseProductsOfficerDetailsSuccess) {
          final choosedIds = source.choosedItemSourceIds.toSet();

          final filteredProducts = state.products
              .where((item) => choosedIds.contains(item.itemId))
              .toList();

          // Build lookup maps for correct alignment regardless of
          // API vs. selection order.
          final qtyByItemId = <String, String>{};
          final mainIdByItemId = <String, String>{};
          final mainIdsList = source.mainIds.toList();
          for (int i = 0; i < source.choosedItemSourceIds.length; i++) {
            qtyByItemId[source.choosedItemSourceIds[i]] =
                source.requestedQty[i];
            if (i < mainIdsList.length) {
              mainIdByItemId[source.choosedItemSourceIds[i]] = mainIdsList[i];
            }
          }

          final total = filteredProducts.fold<double>(0, (sum, product) {
            final qty =
                double.tryParse(qtyByItemId[product.itemId] ?? '0') ?? 0;
            return sum + product.itemPrice * qty;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            totalSavings(total);
          });

          final List<PurchaseCreateOrderRequestPurchaseOfficerItem> apiItems =
              [];

          createOrderRequest.setPurchaseOfficerItems(apiItems);

          return SliverList.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];

              apiItems.add(
                PurchaseCreateOrderRequestPurchaseOfficerItem(
                  itemId: product.itemId,
                  itemName: product.itemName,
                  itemUnit: product.itemUnit,
                  itemImage: product.itemLogo,
                  itemPrice: product.itemPrice.toString(),
                  quantity:
                      int.tryParse(qtyByItemId[product.itemId] ?? '0') ?? 0,
                  quality:
                      context
                          .read<ValidationCubit>()
                          .state
                          .fieldsValue['quality_${mainIdByItemId[product.itemId] ?? ''}'] ??
                      '',
                  latestDeliveryDate:
                      context
                          .read<ValidationCubit>()
                          .state
                          .fieldsValue['latestDelivery_${mainIdByItemId[product.itemId] ?? ''}'] ??
                      '',
                  preferredDeliveryDate:
                      context
                          .read<ValidationCubit>()
                          .state
                          .fieldsValue['preferredDelivery_${mainIdByItemId[product.itemId] ?? ''}'] ??
                      '',
                  specialInstructions: context
                      .read<ValidationCubit>()
                      .state
                      .fieldsValue['specialInstructions_${mainIdByItemId[product.itemId] ?? ''}'],
                ),
              );

              return Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.all(16.r),
                margin: EdgeInsets.only(bottom: 12.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        PurchaseItemImage(
                          bgColor: context.customColor.reversedTextColor,
                          image: product.itemLogo,
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Text(
                            '${product.itemName} (${product.itemUnit})',
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    const CustomDivider(),
                    8.verticalSpace,
                    _buildDetailRow(
                      context,
                      context.tr.requestedQty,
                      '${qtyByItemId[product.itemId] ?? '0'} ${product.itemUnit}',
                    ),
                    8.verticalSpace,
                    const CustomDivider(),
                    8.verticalSpace,
                    BlocSelector<ValidationCubit, ValidationState, String>(
                      selector: (state) =>
                          state
                              .fieldsValue['quality_${mainIdByItemId[product.itemId] ?? ''}'] ??
                          '',
                      builder: (context, state) {
                        return _buildDetailRow(
                          context,
                          context.tr.quality,
                          state,
                        );
                      },
                    ),
                    8.verticalSpace,
                    const CustomDivider(),
                    8.verticalSpace,
                    BlocSelector<ValidationCubit, ValidationState, String>(
                      selector: (state) =>
                          state
                              .fieldsValue['preferredDelivery_${mainIdByItemId[product.itemId] ?? ''}'] ??
                          '',
                      builder: (context, state) {
                        return _buildDetailRow(
                          context,
                          context.tr.preferredDelivery,
                          DateFormatter.formatDateMDY(
                                DateTime.tryParse(state),
                              ) ??
                              '',
                        );
                      },
                    ),
                    8.verticalSpace,
                    const CustomDivider(),
                    8.verticalSpace,
                    BlocSelector<ValidationCubit, ValidationState, String>(
                      selector: (state) =>
                          state
                              .fieldsValue['latestDelivery_${mainIdByItemId[product.itemId] ?? ''}'] ??
                          '',
                      builder: (context, state) {
                        return _buildDetailRow(
                          context,
                          context.tr.latestDelivery,
                          DateFormatter.formatDateMDY(
                                DateTime.tryParse(state),
                              ) ??
                              '',
                        );
                      },
                    ),
                    BlocSelector<ValidationCubit, ValidationState, String?>(
                      selector: (state) => state
                          .fieldsValue['specialInstructions_${mainIdByItemId[product.itemId] ?? ''}'],
                      builder: (context, state) {
                        if (state == null || state.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: context.customColor.reversedTextColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12.r,
                                horizontal: 16.r,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          context.tr.specialInstruction,
                                          style: AppStyles.s14W600.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      AppSvgButton(
                                        assetName: AppAssets.edit,
                                        onTap: () {},
                                        withBorder: false,
                                      ),
                                    ],
                                  ),
                                  8.verticalSpace,
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: context.customColor.text2
                                          .withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    padding: EdgeInsets.all(16.r),
                                    child: Text(
                                      state,
                                      style: AppStyles.s14W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    8.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.r,
                        horizontal: 16.r,
                      ),
                      child: Column(
                        children: [
                          Text(
                            context.tr.priceComparison,
                            style: AppStyles.s14W500.copyWith(
                              color: context.theme.primaryColor,
                            ),
                          ),
                          8.verticalSpace,
                          _buildPriceComparisonRow(
                            context,
                            context.tr.directSupplier,
                            '${product.priceComparison.directSupplier.totalAmount} ${context.tr.sar}/${context.tr.pk}',
                          ),
                          6.verticalSpace,
                          const CustomDivider(),
                          6.verticalSpace,
                          _buildPriceComparisonRow(
                            context,
                            context.tr.viaPurchasingOfficer,
                            '${product.priceComparison.purchasingOfficer.totalAmount} ${context.tr.sar}/${context.tr.pk}',
                          ),
                          6.verticalSpace,
                          const CustomDivider(),
                          6.verticalSpace,
                          _buildPriceComparisonRow(
                            context,
                            context.tr.savings,
                            '${product.priceComparison.savings} ${context.tr.sar}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox.shrink().sliverBoxAdapter;
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  Widget _buildPriceComparisonRow(
    BuildContext context,
    String title,
    String value, {
    bool showCurrencySymbol = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        if (showCurrencySymbol) const SaudiRiyalSvgWidget(),
        5.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
