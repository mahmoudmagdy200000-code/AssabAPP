import 'package:assab/core/cubits/choose_item/choose_item_state.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../domain/strategies/document_type_strategy.dart';

class ReceiveOrderDocumentTypeView extends StatefulWidget {
  const ReceiveOrderDocumentTypeView({super.key});

  @override
  State<ReceiveOrderDocumentTypeView> createState() =>
      _ReceiveOrderDocumentTypeViewState();
}

class _ReceiveOrderDocumentTypeViewState
    extends State<ReceiveOrderDocumentTypeView> {
  List<DocumentTypeStrategy> get _documentTypeStrategies => [
    InvoiceDocumentTypeStrategy(),
    DeliveryNoteDocumentTypeStrategy(),
    ReturnDocumentTypeStrategy(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ValidationCubit, ValidationState>(
      listenWhen: (previous, current) {
        final prevDoc = previous.fieldsValue['documentType'];
        final currDoc = current.fieldsValue['documentType'];

        // Check for variance in items list
        final prevItems = previous.getListValue('receiveGoodsItems') ?? [];
        final currItems = current.getListValue('receiveGoodsItems') ?? [];

        final prevHasVariance = prevItems.any(
          (item) => item.isVariance == true,
        );
        final currHasVariance = currItems.any(
          (item) => item.isVariance == true,
        );

        // Document type changed
        final docChanged =
            currDoc != null && currDoc.isNotEmpty && currDoc != prevDoc;

        // Variance state changed (from true to false or false to true) and document type is selected
        final varianceStateChanged =
            prevHasVariance != currHasVariance &&
            currDoc != null &&
            currDoc.isNotEmpty;

        return docChanged || varianceStateChanged;
      },
      listener: (context, state) {
        final documentType = state.fieldsValue['documentType'];
        if (documentType == null || documentType.isEmpty) return;

        final strategyIndex = _documentTypeStrategies.indexWhere(
          (strategy) => strategy.value == documentType,
        );

        if (strategyIndex == -1) return;

        // Update ChooseItemCubit to show visual selection
        context.read<ChooseItemCubit>().selectItem(strategyIndex);

        // Execute strategy to add appropriate dynamic view
        _documentTypeStrategies[strategyIndex].addDynamicView(context);
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.reviewAllDeliveryDetailsOfTheItemsBelow,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  const CustomDivider(),
                  12.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.all(10.r),
                    child:
                        BlocSelector<
                          ValidationCubit,
                          ValidationState,
                          Map<String, dynamic>
                        >(
                          selector: (state) {
                            final items =
                                state.getListValue('receiveGoodsItems') ?? [];
                            final supplier =
                                state.fieldsValue['supplierName'] ?? '';
                            final orderNumber =
                                state.fieldsValue['orderNumber'] ?? '';
                            final totalBeforeTax = items.fold<double>(
                              0,
                              (sum, item) =>
                                  sum + (item.unitPrice * item.qtyReceived),
                            );
                            return {
                              'supplier': supplier,
                              'orderNumber': orderNumber,
                              'value': totalBeforeTax,
                            };
                          },
                          builder: (context, data) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _rowDeliveryDetailItem(
                                  context,
                                  context.tr.supplier,
                                  data['supplier'] ?? '',
                                ),
                                10.verticalSpace,
                                _rowDeliveryDetailItem(
                                  context,
                                  context.tr.order,
                                  data['orderNumber'] ?? '',
                                ),
                                10.verticalSpace,
                                _rowDeliveryDetailItem(
                                  context,
                                  context.tr.value,
                                  data['value'] != null
                                      ? '${(data['value'] as double).toStringAsFixed(2)} SAR'
                                      : '',
                                ),
                              ],
                            );
                          },
                        ),
                  ),
                  12.verticalSpace,
                  Text(
                    context.tr.goodsInspection,
                    style: AppStyles.s20W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  ListView.builder(
                    itemCount: 3,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final texts = [
                        context.tr.invoice,
                        context.tr.deliveryNote,
                        context.tr.receiptWithoutDocuments,
                      ];

                      final desc1 = [
                        context.tr.officialAccountingDocument,
                        context.tr.includesVat,
                        context.tr.requiredForPaymentAccounting,
                      ];

                      final desc2 = [
                        context.tr.receiptDocumentOnly,
                        context.tr.noFinancialValues,
                        context.tr.invoiceWillComeLater,
                      ];

                      final desc3 = [
                        context.tr.temporaryReceipt,
                        context.tr.waitingForOfficialDocs,
                        context.tr.automaticFollowupReminder,
                      ];

                      return BlocSelector<
                        ChooseItemCubit,
                        ChooseItemState,
                        bool
                      >(
                        selector: (state) => state.selectedIndex == index,
                        builder: (context, state) {
                          return AppGestureDetectorButton(
                            onTap: () {
                              context.read<ChooseItemCubit>().selectItem(index);

                              context
                                  .read<ValidationCubit>()
                                  .validateFieldAndStoreValue(
                                    fieldName: 'documentType',
                                    value: _documentTypeStrategies[index].value,
                                    isValid: true,
                                  );

                              _documentTypeStrategies[index].addDynamicView(
                                context,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: state
                                      ? context.theme.primaryColor
                                      : context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.all(20.r),
                              margin: EdgeInsets.only(bottom: 10.r),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppSvg(
                                    assetName: AppAssets.expenseSvg,
                                    colorFilter: ColorFilter.mode(
                                      context.customColor.text3,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          texts[index],
                                          style: AppStyles.s14W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                        4.verticalSpace,
                                        _buildDotText(context, desc1[index]),
                                        _buildDotText(context, desc2[index]),
                                        _buildDotText(context, desc3[index]),
                                      ],
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  SelectionCircule(isSelected: state),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 67.h,
                        color: context.theme.primaryColor,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${context.tr.note} 💡',
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            Text(
                              context
                                  .tr
                                  .documentTypeCanBeUpdatedLaterIfCircumstancesChange,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          BlocSelector<ValidationCubit, ValidationState, bool>(
            selector: (state) => state.fieldsValidity['documentType'] ?? false,
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.back,
                      onTap: () {
                        context.read<PagingCubit>().previousStep();
                      },
                      padding: EdgeInsets.symmetric(vertical: 18.r),
                      textColor: context.customColor.text1,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: AppButton(
                      onClick: () {
                        context.read<PagingCubit>().nextStep();
                      },
                      enabled: state,
                      text: context.tr.continue_c,
                      borderRadius: BorderRadius.circular(15.r),
                      padding: EdgeInsets.symmetric(vertical: 18.r),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _rowDeliveryDetailItem(
    BuildContext context,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        5.horizontalSpace,
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
          ),
        ),
      ],
    );
  }

  Widget _buildDotText(BuildContext context, String text) {
    return Row(
      children: [
        Icon(Icons.circle, size: 3.r, color: context.customColor.text4),
        8.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
          ),
        ),
      ],
    );
  }
}
