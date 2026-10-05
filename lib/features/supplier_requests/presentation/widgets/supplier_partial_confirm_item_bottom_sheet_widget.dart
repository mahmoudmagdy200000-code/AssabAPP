import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/supplier_orders_response.dart';
import '../../data/models/supplier_partial_confirm_item_local_model.dart';
import '../cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart';
import 'supplier_partial_confirm_item_summary.dart';

class SupplierPartialConfirmItemBottomSheetWidget extends StatelessWidget {
  final SupplierOrderItem item;
  final String orderId;

  const SupplierPartialConfirmItemBottomSheetWidget({
    super.key,
    required this.item,
    required this.orderId,
  });

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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4.w,
                                height: 42.h,
                                color: context.theme.primaryColor,
                              ),
                              10.horizontalSpace,
                              Expanded(
                                child: Text(
                                  context
                                      .tr
                                      .editTheQuantityYouCanSupplyThenReviewAndSubmit,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          25.verticalSpace,
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
                                        item.productName,
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
                                  item.orderedQuantity.toString(),
                                ),
                                8.verticalSpace,
                                _buildDiv(context),
                                8.verticalSpace,
                                _buildDetailRow(
                                  context,
                                  context.tr.newProposal,
                                  '',
                                  customValueWidget: Expanded(
                                    child: ContainerCustomTextField(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6.r,
                                        horizontal: 12.r,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              hintText: '0',
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                final isValid =
                                                    int.tryParse(value) !=
                                                        null &&
                                                    int.parse(value) !=
                                                        item.orderedQuantity;

                                                context
                                                    .read<ValidationCubit>()
                                                    .validateFieldAndStoreValue(
                                                      fieldName: 'newQty',
                                                      value: value,
                                                      isValid: isValid,
                                                    );
                                              },
                                            ),
                                          ),
                                          5.horizontalSpace,
                                          Text(
                                            '/${item.productUnit}',
                                            style: AppStyles.s10W400.copyWith(
                                              color: context.customColor.text3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                8.verticalSpace,
                                _buildDiv(context),
                                8.verticalSpace,
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  double
                                >(
                                  selector: (state) {
                                    final newQtyString =
                                        (double.tryParse(
                                          state.fieldsValue['newQty'] ?? '',
                                        )) ??
                                        0;

                                    return (newQtyString -
                                        item.orderedQuantity.toDouble());
                                  },
                                  builder: (context, state) {
                                    return _buildDetailRow(
                                      context,
                                      context.tr.shortage,
                                      state.toString(),
                                      showCurrencySymbol: false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          16.verticalSpace,
                          Text(
                            context.tr.modificationDetails,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text4,
                            ),
                          ),
                          8.verticalSpace,
                          ContainerCustomTextField(
                            child: CustomTextField(
                              hintText: context
                                  .tr
                                  .egSorryForBeefShortageDueToHighDemandThis,
                              maxLines: 5,
                              onChanged: (value) {
                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'note',
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
                        child: BlocSelector<ValidationCubit, ValidationState, bool>(
                          selector: (state) => state.enableButton,
                          builder: (context, state) {
                            return AppButton(
                              text: context.tr.rereview,
                              onClick: () {
                                final summary =
                                    SupplierPartialConfirmItemLocalModel(
                                      item: item,
                                      orderId: orderId,
                                      newQty: context
                                          .read<ValidationCubit>()
                                          .getFieldValue('newQty'),
                                      shortage:
                                          (item.orderedQuantity -
                                                  (double.tryParse(
                                                        context
                                                            .read<
                                                              ValidationCubit
                                                            >()
                                                            .getFieldValue(
                                                              'newQty',
                                                            ),
                                                      ) ??
                                                      0))
                                              .toString(),
                                      originalPrice: item.totalPrice.toString(),
                                      newPrice:
                                          (item.unitPrice *
                                                  (double.tryParse(
                                                        context
                                                            .read<
                                                              ValidationCubit
                                                            >()
                                                            .getFieldValue(
                                                              'newQty',
                                                            ),
                                                      ) ??
                                                      0))
                                              .toString(),
                                      differencePrice:
                                          ((item.unitPrice *
                                                      (double.tryParse(
                                                            context
                                                                .read<
                                                                  ValidationCubit
                                                                >()
                                                                .getFieldValue(
                                                                  'newQty',
                                                                ),
                                                          ) ??
                                                          0)) -
                                                  item.totalPrice)
                                              .toString(),
                                      modificationNotes: context
                                          .read<ValidationCubit>()
                                          .getFieldValue('note'),
                                    );

                                AppBottomSheet.customPageRoute(
                                  context,
                                  (context) => BlocProvider(
                                    create: (context) =>
                                        getIt<
                                          SupplierConfirmOrRejectOrderOrItemCubit
                                        >(),
                                    child: SupplierPartialConfirmItemSummary(
                                      summary: summary,
                                    ),
                                  ),
                                );
                              },
                              enabled: state,
                              padding: EdgeInsets.symmetric(vertical: 14.r),
                              borderRadius: BorderRadius.circular(15.r),
                            );
                          },
                        ),
                      ),
                    ],
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
                color: context.customColor.text1,
              ),
            ),
      ],
    );
  }

  Widget _buildDiv(BuildContext context) {
    return CustomDivider(color: context.customColor.border);
  }
}
