import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/supplier_partial_confirmItem_request.dart';
import '../../data/models/supplier_partial_confirm_item_local_model.dart';
import '../cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart';
import 'supplier_partial_confirm_success_bottom_sheet_widget.dart';

class SupplierPartialConfirmItemSummary extends StatelessWidget {
  final SupplierPartialConfirmItemLocalModel summary;

  const SupplierPartialConfirmItemSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          AppPaddingWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.proposeNewQuantity,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
                3.verticalSpace,
                Text(
                  context.tr.editTheOrderDetailsFromRiyadhBranchMalqa,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.tr.modificationSummary,
                                style: AppStyles.s16W600.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ),
                            10.horizontalSpace,
                            const AppSvg(assetName: AppAssets.edit),
                          ],
                        ),
                        12.verticalSpace,
                        const CustomDivider(),
                        12.verticalSpace,
                        Text(
                          context.tr.modificationDetails,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text4,
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.text2,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  PurchaseItemImage(
                                    bgColor:
                                        context.customColor.reversedTextColor,
                                  ),
                                  12.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      summary.item.productName,
                                      style: AppStyles.s14W600.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              8.verticalSpace,
                              _buildDiv(context),
                              8.verticalSpace,
                              _buildDetailRow(
                                context,
                                context.tr.requestedQty,
                                '${summary.item.orderedQuantity} ${summary.item.productUnit}',
                              ),
                              8.verticalSpace,
                              _buildDiv(context),
                              8.verticalSpace,
                              _buildDetailRow(
                                context,
                                context.tr.newProposal,
                                '${summary.newQty} ${summary.item.productUnit}',
                              ),
                              8.verticalSpace,
                              _buildDiv(context),
                              8.verticalSpace,
                              _buildDetailRow(
                                context,
                                context.tr.shortage,
                                '${summary.shortage} ${summary.item.productUnit}',
                                valueColor: context.customColor.error,
                              ),
                            ],
                          ),
                        ),
                        16.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr.modifiedTotal,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              8.verticalSpace,
                              _buildDiv(context),
                              8.verticalSpace,
                              _buildDetailRow(
                                context,
                                context.tr.original,
                                summary.originalPrice,
                                showCurrencySymbol: true,
                              ),
                              8.verticalSpace,
                              _buildDiv(context),
                              8.verticalSpace,
                              _buildDetailRow(
                                context,
                                context.tr.new_n,
                                summary.newPrice,
                                showCurrencySymbol: true,
                              ),
                              8.verticalSpace,
                              _buildDiv(context),
                              8.verticalSpace,
                              _buildDetailRow(
                                context,
                                context.tr.difference,
                                summary.differencePrice,
                                showCurrencySymbol: true,
                              ),
                            ],
                          ),
                        ),
                        16.verticalSpace,
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr.modificationNotes,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                              Text(
                                summary.modificationNotes,
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  BlocConsumer<
                    SupplierConfirmOrRejectOrderOrItemCubit,
                    SupplierConfirmOrRejectOrderOrItemState
                  >(
                    listener: (context, state) {
                      if (state is SupplierConfirmOrRejectOrderOrItemFailure) {
                        AppDialog.showErrorDialog(
                          context: context,
                          failure: state.failure,
                        );
                      } else if (state
                          is SupplierConfirmOrRejectOrderOrItemSuccess) {
                        NavigationService.I.popToFirst();

                        AppBottomSheet.customPageRoute(
                          context,
                          (context) =>
                              const SupplierPartialConfirmSuccessBottomSheetWidget(),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is SupplierConfirmOrRejectOrderOrItemLoading) {
                        return const AppLoadingWidget();
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: CustomTextButton(
                              text: context.tr.cancel,
                              onTap: () {
                                NavigationService.I.pop();
                              },
                              backgroundColor: Colors.transparent,
                              textColor: context.customColor.text1,
                              padding: EdgeInsets.symmetric(vertical: 14.r),
                              borderRadius: 15.r,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: AppButton(
                              text: context.tr.sendModification,
                              onClick: () {
                                context
                                    .read<
                                      SupplierConfirmOrRejectOrderOrItemCubit
                                    >()
                                    .partialConfirmItem(
                                      id: summary.orderId,
                                      body: SupplierPartialConfirmItemRequest(
                                        items: [
                                          SupplierPartialConfirmItemRequestItem(
                                            itemId: summary.item.productId,
                                            quantity:
                                                double.tryParse(
                                                  summary.newQty,
                                                ) ??
                                                0,
                                            note: summary.modificationNotes,
                                          ),
                                        ],
                                      ),
                                    );
                              },
                              enabled: true,
                              padding: EdgeInsets.symmetric(vertical: 14.r),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String value, {
    bool showCurrencySymbol = false,
    Widget? customValueWidget,
    Color? valueColor,
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
        customValueWidget ??
            Text(
              value,
              style: AppStyles.s13W500.copyWith(
                color: valueColor ?? context.customColor.text1,
              ),
            ),
      ],
    );
  }

  Widget _buildDiv(BuildContext context) {
    return CustomDivider(color: context.customColor.border);
  }
}
