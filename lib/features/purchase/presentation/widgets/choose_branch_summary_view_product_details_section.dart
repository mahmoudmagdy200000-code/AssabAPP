import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/features/purchase/data/models/purchase_product_branch_details_response.dart';
import 'package:assab/features/purchase/data/models/source_local_model.dart';
import 'package:assab/features/purchase/presentation/cubit/get_purchase_products_branch_details/get_purchase_products_branch_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/purchase_create_order_request.dart';
import '../cubit/get_purchase_products_branch_details/get_purchase_products_branch_details_state.dart';
import 'purchase_item_image.dart';

class ChooseBranchSummaryViewProductDetailsSection extends StatelessWidget {
  final SourceLocalModel branch;
  final PurchaseCreateOrderRequest createOrderRequest;
  final PurchaseCreateOrderRequestBranch branchRequest;

  const ChooseBranchSummaryViewProductDetailsSection({
    super.key,
    required this.branch,
    required this.createOrderRequest,
    required this.branchRequest,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetPurchaseProductsBranchDetailsCubit,
      GetPurchaseProductsBranchDetailsState
    >(
      builder: (context, state) {
        final products = <PurchaseProductBranchDetailsData>[];
        final qtyByItemId = <String, String>{};

        if (state is GetPurchaseProductsBranchDetailsLoading) {
          return const AppLoadingWidget().sliverBoxAdapter;
        } else if (state is GetPurchaseProductsBranchDetailsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            withBorder: false,
            onRetry: () {
              context
                  .read<GetPurchaseProductsBranchDetailsCubit>()
                  .getPurchaseProductsBranchDetails(branchId: branch.sourceId);
            },
          ).sliverBoxAdapter;
        } else if (state is GetPurchaseProductsBranchDetailsSuccess) {
          final choosedIds = branch.choosedItemSourceIds.toSet();

          products.addAll(
            state.purchaseProductBranchDetailsResponse.data.where(
              (item) => choosedIds.contains(item.itemId),
            ),
          );

          // Build a map from itemId → requestedQty for correct alignment
          // regardless of API vs. selection order.
          for (int i = 0; i < branch.choosedItemSourceIds.length; i++) {
            qtyByItemId[branch.choosedItemSourceIds[i]] =
                branch.requestedQty[i];
          }

          final apiItems = List.generate(products.length, (index) {
            final product = products[index];

            return PurchaseCreateOrderRequestBranchItem(
              itemId: product.itemId,
              quantity: int.tryParse(qtyByItemId[product.itemId] ?? '0') ?? 0,
            );
          });

          branchRequest.updateItems(apiItems);
        }

        branchRequest.updateBranchId(branch.sourceId);
        createOrderRequest.upsertBranch(branchRequest);

        return SliverList.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

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
                  _buildDetailRow(
                    context,
                    '${context.tr.availableIn} ${branch.sourceName}',
                    '${product.remainingBalanceInTransferringBranch.quantity} ${product.itemUnit}',
                  ),
                  8.verticalSpace,
                  const CustomDivider(),
                  8.verticalSpace,
                  _buildDetailRow(
                    context,
                    context.tr.balanceAfter,
                    '${product.remainingBalanceInTransferringBranch.quantity - (double.tryParse(qtyByItemId[product.itemId] ?? '0') ?? 0)} ${product.itemUnit}',
                  ),
                  8.verticalSpace,
                  const CustomDivider(),
                  8.verticalSpace,
                  _buildDetailRow(
                    context,
                    context.tr.qualityGrade,
                    product.qualityLabel,
                  ),
                  8.verticalSpace,
                  const CustomDivider(),
                  8.verticalSpace,
                  _buildDetailRow(
                    context,
                    context.tr.expiryDate,
                    DateFormatter.formatDateMDY(
                          DateTime.tryParse(product.expiryDate),
                        ) ??
                        '',
                  ),
                  8.verticalSpace,
                  const CustomDivider(),
                  8.verticalSpace,
                  _buildDetailRow(
                    context,
                    context.tr.coolingStatus,
                    product.coolingStatus
                        ? context.tr.transferReady
                        : context.tr.transferNotReady,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
