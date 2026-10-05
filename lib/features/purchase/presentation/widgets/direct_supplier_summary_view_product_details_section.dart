import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/purchase_create_order_request.dart';
import '../../data/models/purchase_supplier_product_details_response.dart';
import '../../data/models/source_local_model.dart';
import 'purchase_item_image.dart';

class DirectSupplierSummaryViewProductDetailsSection extends StatelessWidget {
  final SourceLocalModel source;
  final List<PurchaseSupplierProductDetailsData> productsDetails;
  final PurchaseCreateOrderRequest createOrderRequest;
  final PurchaseCreateOrderRequestDirectSupplier supplier;

  const DirectSupplierSummaryViewProductDetailsSection({
    super.key,
    required this.source,
    required this.productsDetails,
    required this.createOrderRequest,
    required this.supplier,
  });

  void _updateApiModel(
    BuildContext context, {
    required Map<String, String> qtyByItemId,
    required Map<String, String> mainIdByItemId,
  }) {
    final apiItems = List.generate(productsDetails.length, (index) {
      final product = productsDetails[index];

      return PurchaseCreateOrderRequestDirectSupplierItem(
        itemId: product.itemId,
        itemName: product.itemName,
        itemUnit: product.itemUnit,
        itemPrice: product.itemPrice.toString(),
        itemImage: product.itemLogo,
        quantity: int.tryParse(qtyByItemId[product.itemId] ?? '0') ?? 0,
        quality:
            context
                .read<ValidationCubit>()
                .state
                .fieldsValue['quality_${mainIdByItemId[product.itemId] ?? ''}'] ??
            '',
      );
    });

    supplier.updateSupplierId(source.sourceId);
    supplier.updateItems(apiItems);

    createOrderRequest.upsertDirectSupplier(supplier);
  }

  @override
  Widget build(BuildContext context) {
    // Build lookup maps for correct item-to-qty and item-to-mainId alignment
    // regardless of API vs. selection order.
    final qtyByItemId = <String, String>{};
    final mainIdByItemId = <String, String>{};
    final mainIdsList = source.mainIds.toList();
    for (int i = 0; i < source.choosedItemSourceIds.length; i++) {
      qtyByItemId[source.choosedItemSourceIds[i]] = source.requestedQty[i];
      if (i < mainIdsList.length) {
        mainIdByItemId[source.choosedItemSourceIds[i]] = mainIdsList[i];
      }
    }

    _updateApiModel(
      context,
      qtyByItemId: qtyByItemId,
      mainIdByItemId: mainIdByItemId,
    );

    return SliverList.builder(
      itemCount: productsDetails.length,
      itemBuilder: (context, index) {
        final product = productsDetails[index];

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
                  return _buildDetailRow(context, context.tr.quality, state);
                },
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.rate,
                '${product.itemPrice} / ${product.itemUnit}',
                showCurrencySymbol: true,
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.totalAmount,
                '${product.itemPrice * (double.tryParse(qtyByItemId[product.itemId] ?? '0') ?? 0)}',
                showCurrencySymbol: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
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
        2.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
