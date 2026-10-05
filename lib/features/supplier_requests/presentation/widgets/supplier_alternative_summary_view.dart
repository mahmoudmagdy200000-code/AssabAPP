import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/supplier_alternative_product_request.dart';
import '../../data/models/supplier_items_response.dart';
import '../../data/models/supplier_orders_response.dart';
import '../cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart';
import 'supplier_partial_confirm_success_bottom_sheet_widget.dart';

class SupplierAlternativeSummaryView extends StatelessWidget {
  final SupplierOrderItem oldItem;
  final SupplierItem newItem;
  final int newItemQty;
  final String orderId;

  const SupplierAlternativeSummaryView({
    super.key,
    required this.oldItem,
    required this.newItem,
    required this.newItemQty,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerCustomTextField(
                      label: context.tr.modificationNotes,
                      child: CustomTextField(
                        hintText:
                            'e.g Sorry for beef shortage due to high demand this week. We can provide replace the item with a greater suggestion.',
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreValue(
                                fieldName: 'note',
                                value: value,
                                isValid: value.isNotEmpty,
                              );
                        },
                        maxLines: 5,
                      ),
                    ),
                    16.verticalSpace,
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
                        5.horizontalSpace,
                        AppSvgButton(
                          assetName: AppAssets.edit,
                          onTap: () {
                            context.read<PagingCubit>().goToStep(0);
                          },
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    const CustomDivider(),
                    12.verticalSpace,
                    Text(
                      context.tr.originalOrder,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.all(16.r),
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
                                  oldItem.productName,
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
                            oldItem.orderedQuantity.toString(),
                          ),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                          _buildDetailRow(
                            context,
                            context.tr.quality,
                            oldItem.qualityLevel.getString(context),
                          ),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                          _buildDetailRow(
                            context,
                            context.tr.price,
                            oldItem.unitPrice.toStringAsFixed(2),
                            showCurrencySymbol: true,
                          ),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                          _buildDetailRow(
                            context,
                            context.tr.totalAmount,
                            oldItem.totalPrice.toStringAsFixed(2),
                            showCurrencySymbol: true,
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      context.tr.yourProposal,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.all(16.r),
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
                                  newItem.item.name,
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
                            newItemQty.toString(),
                          ),

                          /// TODO: add quality level to the alternative product and show it here
                          // 8.verticalSpace,
                          // _buildDiv(context),
                          // 8.verticalSpace,
                          // _buildDetailRow(
                          //   context,
                          //   context.tr.quality,
                          //   newItem.rating,
                          // ),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                          _buildDetailRow(
                            context,
                            context.tr.price,
                            newItem.unitPrice,
                            showCurrencySymbol: true,
                          ),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                          _buildDetailRow(
                            context,
                            context.tr.totalAmount,
                            ((double.tryParse(newItem.unitPrice) ?? 0) *
                                    newItemQty)
                                .toStringAsFixed(2),
                            showCurrencySymbol: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            BlocConsumer<
              SupplierConfirmOrRejectOrderOrItemCubit,
              SupplierConfirmOrRejectOrderOrItemState
            >(
              listener: (context, state) {
                if (state is SupplierConfirmOrRejectOrderOrItemSuccess) {
                  NavigationService.I.popToFirst();

                  AppBottomSheet.customPageRoute(
                    context,
                    (context) =>
                        const SupplierPartialConfirmSuccessBottomSheetWidget(),
                  );
                } else if (state is SupplierConfirmOrRejectOrderOrItemFailure) {
                  AppDialog.showErrorDialog(
                    context: context,
                    failure: state.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state is SupplierConfirmOrRejectOrderOrItemLoading) {
                  return const AppButtonLoading();
                }

                return Row(
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        text: context.tr.cancel,
                        onTap: () {
                          NavigationService.I.pop();
                        },
                        textColor: context.customColor.text1,
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 14.r),
                        borderRadius: 1000.r,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child:
                          BlocSelector<ValidationCubit, ValidationState, bool>(
                            selector: (state) => state.enableButton,
                            builder: (context, state) {
                              return AppButton(
                                text: context.tr.sendModification,
                                onClick: () {
                                  context
                                      .read<
                                        SupplierConfirmOrRejectOrderOrItemCubit
                                      >()
                                      .supplierAlternativeProductItem(
                                        orderId: orderId,
                                        itemId: oldItem.productId,
                                        body: SupplierAlternativeProductRequest(
                                          note: context
                                              .read<ValidationCubit>()
                                              .getFieldValue('note'),
                                          alternativeItemId: newItem.itemId,
                                        ),
                                      );
                                },
                                enabled: state,
                                padding: EdgeInsets.symmetric(vertical: 14.r),
                                borderRadius: BorderRadius.circular(1000.r),
                              );
                            },
                          ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
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

  Widget _buildDiv(BuildContext context) {
    return CustomDivider(color: context.customColor.border);
  }
}
