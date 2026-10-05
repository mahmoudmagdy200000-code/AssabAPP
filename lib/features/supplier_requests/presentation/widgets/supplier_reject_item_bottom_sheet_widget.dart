import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';

class SupplierRejectItemBottomSheetWidget extends StatelessWidget {
  final String itemName;
  final String itemImage;
  final String itemUnit;
  final String requestedQty;
  final String price;
  final String totalPrice;
  final String quality;
  final void Function(String reason) onClick;

  const SupplierRejectItemBottomSheetWidget({
    super.key,
    required this.itemName,
    required this.itemImage,
    required this.itemUnit,
    required this.requestedQty,
    required this.price,
    required this.totalPrice,
    required this.quality,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 40.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.rejectRequest,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      context.tr.cancelOrderConfirmDesc,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    15.verticalSpace,
                    Text(
                      context.tr.rejectOrderItemDesc,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    16.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
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
                                  itemName,
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
                            '$requestedQty $itemUnit',
                          ),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                          _buildDetailRow(context, context.tr.quality, quality),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                          _buildDetailRow(
                            context,
                            context.tr.price,
                            '$price / $itemUnit',
                            showCurrencySymbol: true,
                          ),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                          _buildDetailRow(
                            context,
                            context.tr.totalAmount,
                            totalPrice,
                            showCurrencySymbol: true,
                          ),
                          8.verticalSpace,
                          _buildDiv(context),
                          8.verticalSpace,
                        ],
                      ),
                    ),
                    LabelTextField(
                      text: context.tr.reasonForRejection,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      child: CustomTextField(
                        hintText: context
                            .tr
                            .egItemUnavailableLowStockOrNotAuthorizedForTransfer,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreValue(
                                fieldName: 'reason',
                                value: value,
                                isValid: value.isNotEmpty,
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.cancel,
                    onTap: () => NavigationService.I.pop(),
                    textColor: context.customColor.text1,
                    padding: EdgeInsets.symmetric(vertical: 17.r),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (state) => state.enableButton,
                    builder: (context, state) {
                      return AppButton(
                        onClick: () {
                          onClick(
                            context.read<ValidationCubit>().getFieldValue(
                              'reason',
                            ),
                          );
                        },
                        enabled: state,
                        text: context.tr.reject,
                        background: context.customColor.error,
                        borderRadius: BorderRadius.circular(12.r),
                      );
                    },
                  ),
                ),
              ],
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
