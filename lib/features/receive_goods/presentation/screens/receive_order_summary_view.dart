import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/enums/document_type_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_file_image.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/file_preview_widget.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/enums/variance_required_actions_enum.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/models/receive_goods_local_item_model.dart';
import '../../data/models/receive_order_inspection_response.dart';
import '../../data/models/receive_order_supplier_request.dart';
import '../cubit/start_receive_order/start_receive_order_cubit.dart';
import '../cubit/start_receive_order/start_receive_order_state.dart';
import 'receive_order_success_screen.dart';

class ReceiveOrderSummaryView extends StatelessWidget {
  final String orderId;

  const ReceiveOrderSummaryView({super.key, required this.orderId});

  ReceiveOrderSupplierRequest _request(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final items =
        validationCubit.getListValue<ReceiveGoodsLocalItemModel>(
          'receiveGoodsItems',
        ) ??
        [];

    final documentType = validationCubit.getFieldValue('documentType');

    final receivedItems = items
        .map(
          (item) => ReceivedItem(
            itemId: item.itemId,
            quantityReceived: item.qtyReceived.toDouble(),
            quality: item.quality.name,
            temperature: item.termperature.toDouble(),
            expirationDate: item.expirationDate,
            file: item.selectedImage?.toFile,
            notes: item.note,
          ),
        )
        .toList();

    InvoiceData? invoiceData;

    if (documentType == DocumentTypeEnum.invoice.value) {
      final invoiceNumber = validationCubit.getFieldValue('invoiceNumber');
      final invoiceDate = validationCubit.getFieldValue('invoiceDate');
      final dueDate = validationCubit.getFieldValue('dueDate');
      final paymentTerms = validationCubit.getFieldValue('paymentTerms');
      final file = validationCubit.getTypedValue<MediaFile>('file');
      final note = validationCubit.getFieldValue('note');
      invoiceData = InvoiceData(
        invoiceNumber: invoiceNumber,
        invoiceDate: invoiceDate,
        dueDate: dueDate,
        paymentTerms: paymentTerms,
        file: file!.toFile,
        notes: note,
      );
    }

    final varianceItems = items.where((item) => item.isVariance).toList();

    VarianceData? variance;

    if (varianceItems.isNotEmpty) {
      final action = validationCubit.getFieldValue('varianceRequiredAction');
      final note = validationCubit.getFieldValue('note');
      final file = validationCubit.getTypedValue<MediaFile>('file');
      final varianceItemModels = varianceItems
          .map(
            (item) => VarianceItem(
              itemId: item.itemId,
              quantity: item.qtyOrdered - item.qtyReceived,
            ),
          )
          .toList();
      variance = VarianceData(
        action: action,
        note: note,
        file: file?.toFile,
        items: varianceItemModels,
      );
    }

    return ReceiveOrderSupplierRequest(
      items: receivedItems,
      documentType: documentType,
      invoiceData: invoiceData,
      variance: variance,
    );
  }

  void _receive(BuildContext context) {
    context.read<StartReceiveOrderCubit>().startReceivingSupplierOrder(
      orderId: orderId,
      request: _request(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.receiveOrderSummary,
                  style: AppStyles.s20W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                8.verticalSpace,
                Text(
                  context.tr.youCanConfirmNow,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                12.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.inspectionSummary,
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      10.verticalSpace,
                      BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        List<ReceiveGoodsLocalItemModel>
                      >(
                        selector: (state) {
                          return state.getListValue<ReceiveGoodsLocalItemModel>(
                                'receiveGoodsItems',
                              ) ??
                              [];
                        },
                        builder: (context, items) {
                          final itemsReceived = items.length;
                          final varianceCount = items
                              .where((item) => item.isVariance)
                              .length;

                          // Calculate financials from received items
                          final totalBeforeTax = items.fold<double>(
                            0,
                            (sum, item) =>
                                sum + (item.unitPrice * item.qtyReceived),
                          );
                          final vatAmount = totalBeforeTax * 0.15;
                          final totalWithVat = totalBeforeTax + vatAmount;

                          String formatAmount(double value) =>
                              '${value.toStringAsFixed(2)} SAR';

                          final totalValue = formatAmount(totalWithVat);

                          return Container(
                            decoration: BoxDecoration(
                              color: context.customColor.reversedTextColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 12.r,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr.receiptSummary,
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text6,
                                  ),
                                ),
                                5.verticalSpace,
                                _buildRowWidget(
                                  context: context,
                                  title: context.tr.countItemsReceived(
                                    itemsReceived,
                                  ),
                                ),
                                10.verticalSpace,
                                _buildRowWidget(
                                  context: context,
                                  title: context.tr.countQuantityVariance(
                                    varianceCount,
                                  ),
                                ),
                                10.verticalSpace,
                                _buildRowWidget(
                                  context: context,
                                  title: context.tr.totalValue,
                                  value: totalValue,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      10.verticalSpace,
                      BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        DeliveryDetails?
                      >(
                        selector: (state) => state
                            .getTypedValue<DeliveryDetails>('deliveryDetails'),
                        builder: (context, deliveryDetails) {
                          if (deliveryDetails == null) {
                            return const SizedBox.shrink();
                          }

                          final arrivalDateTime = DateTime.tryParse(
                            deliveryDetails.arrivalTime,
                          );
                          final arrivalDate =
                              DateFormatter.formatDateMDY(arrivalDateTime) ??
                              '';
                          final arrivalTime =
                              DateFormatter.formatTimeHM(arrivalDateTime) ?? '';
                          final arrivalDisplay = '$arrivalDate - $arrivalTime';

                          return Container(
                            decoration: BoxDecoration(
                              color: context.customColor.reversedTextColor,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 12.r,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      context.tr.deliveryDetails,
                                      style: AppStyles.s14W500.copyWith(
                                        color: context.customColor.text6,
                                      ),
                                    ),
                                    4.horizontalSpace,
                                    Icon(
                                      Icons.error_outline,
                                      size: 16.r,
                                      color: context.customColor.text3,
                                    ),
                                  ],
                                ),
                                5.verticalSpace,
                                _buildRowWidget(
                                  context: context,
                                  title: context.tr.driver,
                                  value: deliveryDetails.driverName,
                                ),
                                10.verticalSpace,
                                _buildRowWidget(
                                  context: context,
                                  title: context.tr.contactNumber,
                                  value: deliveryDetails.contactNumber ?? '-',
                                ),
                                10.verticalSpace,
                                _buildRowWidget(
                                  context: context,
                                  title: context.tr.vehicle,
                                  value: deliveryDetails.vehicleNumber,
                                ),
                                10.verticalSpace,
                                _buildRowWidget(
                                  context: context,
                                  title: context.tr.arrivalTime,
                                  value: arrivalDisplay,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      10.verticalSpace,
                      BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        List<ReceiveGoodsLocalItemModel>
                      >(
                        selector: (state) {
                          return state.getListValue<ReceiveGoodsLocalItemModel>(
                                'receiveGoodsItems',
                              ) ??
                              [];
                        },
                        builder: (context, items) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      context.tr.goodsInspectionCountTitle(
                                        items.length,
                                      ),
                                      style: AppStyles.s16W600.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                  3.horizontalSpace,
                                  AppSvgButton(
                                    assetName: AppAssets.edit,
                                    onTap: () {
                                      context.read<PagingCubit>().goToStep(0);
                                    },
                                    borderColor: Colors.transparent,
                                  ),
                                ],
                              ),
                              10.verticalSpace,
                              ListView.builder(
                                itemCount: items.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final unitText = item.unit;

                                  return _buildItemCard(
                                    context,
                                    item,
                                    unitText,
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.tr.document,
                              style: AppStyles.s16W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                          3.horizontalSpace,
                          AppSvgButton(
                            assetName: AppAssets.edit,
                            onTap: () {
                              context.read<PagingCubit>().goToStep(1);
                            },
                            borderColor: Colors.transparent,
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: context.customColor.reversedTextColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 12.r,
                        ),
                        child:
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              String?
                            >(
                              selector: (state) =>
                                  state.fieldsValue['documentType'],
                              builder: (context, documentType) {
                                String typeText = DocumentTypeEnum.getStrategy(
                                  DocumentTypeEnum.fromValue(
                                    documentType ?? '',
                                  ),
                                ).typeLabel(context);

                                return _buildRowWidget(
                                  context: context,
                                  title: context.tr.type,
                                  value: typeText,
                                );
                              },
                            ),
                      ),
                      10.verticalSpace,
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) => state.fieldsValue['documentType'],
                        builder: (context, documentType) {
                          if (documentType == DocumentTypeEnum.invoice.value) {
                            return BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              Map<String, String?>
                            >(
                              selector: (state) => {
                                'invoiceNumber':
                                    state.fieldsValue['invoiceNumber'],
                                'invoiceDate': state.fieldsValue['invoiceDate'],
                                'supplier':
                                    state.fieldsValue['supplierName'] ?? '',
                              },
                              builder: (context, data) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.r,
                                    vertical: 12.r,
                                  ),
                                  child: Column(
                                    children: [
                                      _buildRowWidget(
                                        context: context,
                                        title: context.tr.invoiceNumber,
                                        value:
                                            data['invoiceNumber'] ??
                                            '[2024/11/22-485]',
                                      ),
                                      10.verticalSpace,
                                      _buildRowWidget(
                                        context: context,
                                        title: context.tr.date,
                                        value: data['invoiceDate'] != null
                                            ? DateFormatter.formatDateMDY(
                                                DateTime.tryParse(
                                                  data['invoiceDate']!,
                                                ),
                                              )
                                            : 'June 15, 2024',
                                      ),
                                      10.verticalSpace,
                                      _buildRowWidget(
                                        context: context,
                                        title: context.tr.supplier,
                                        value: data['supplier'] ?? '',
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        MediaFile?
                      >(
                        selector: (state) =>
                            state.getTypedValue<MediaFile>('file'),
                        builder: (context, selectedFile) {
                          return _buildInvoiceAttachmentWidget(
                            context,
                            selectedFile,
                          );
                        },
                      ),
                      _buildVarianceSummary(context),
                      _buildOptionalNoteWidget(context),
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) =>
                            state.fieldsValue['varianceRequiredAction'],
                        builder: (context, varianceRequiredAction) {
                          if (varianceRequiredAction ==
                              VarianceRequiredActionsEnum
                                  .createCompensatoryOrder
                                  .value) {
                            return BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              List<ReceiveGoodsLocalItemModel>
                            >(
                              selector: (state) {
                                return state
                                        .getListValue<
                                          ReceiveGoodsLocalItemModel
                                        >('receiveGoodsItems')
                                        ?.where((item) => item.isVariance)
                                        .toList() ??
                                    [];
                              },
                              builder: (context, compensatoryItems) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${context.tr.compensatoryOrder} (${compensatoryItems.length})',
                                      style: AppStyles.s16W600.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    5.verticalSpace,
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: compensatoryItems.length,
                                      itemBuilder: (context, index) {
                                        final item = compensatoryItems[index];
                                        final unitText = item.unit;
                                        return _buildItemCardcompensatory(
                                          context,
                                          item,
                                          unitText,
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.financialSummary,
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      10.verticalSpace,
                      BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        Map<String, dynamic>
                      >(
                        selector: (state) {
                          final items =
                              state.getListValue<ReceiveGoodsLocalItemModel>(
                                'receiveGoodsItems',
                              ) ??
                              <ReceiveGoodsLocalItemModel>[];
                          final orderNumber = state.fieldsValue['orderNumber'];
                          final supplier =
                              state.fieldsValue['supplierName'] ?? '';

                          return {
                            'items': items,
                            'orderNumber': orderNumber,
                            'supplier': supplier,
                          };
                        },
                        builder: (context, data) {
                          final items =
                              data['items'] as List<ReceiveGoodsLocalItemModel>;
                          final orderNumber = data['orderNumber'] as String?;

                          final totalBeforeTax = items.fold<double>(
                            0,
                            (sum, item) =>
                                sum + (item.unitPrice * item.qtyReceived),
                          );
                          final vatAmount = totalBeforeTax * 0.15;
                          final totalWithVat = totalBeforeTax + vatAmount;

                          String formatAmount(double value) =>
                              '${value.toStringAsFixed(2)} SAR';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: context.customColor.reversedTextColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.r,
                                  vertical: 12.r,
                                ),
                                child: Column(
                                  children: [
                                    _buildRowWidget(
                                      context: context,
                                      title: context.tr.supplier,
                                      value: data['supplier'] ?? '',
                                    ),
                                    10.verticalSpace,
                                    _buildRowWidget(
                                      context: context,
                                      title: context.tr.order,
                                      value: orderNumber ?? '-',
                                    ),
                                    10.verticalSpace,
                                    _buildRowWidget(
                                      context: context,
                                      title: context.tr.value,
                                      value: formatAmount(totalBeforeTax),
                                    ),
                                  ],
                                ),
                              ),
                              10.verticalSpace,
                              Container(
                                decoration: BoxDecoration(
                                  color: context.customColor.reversedTextColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.r,
                                  vertical: 12.r,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr.financialDetails,
                                      style: AppStyles.s14W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    10.verticalSpace,
                                    _buildRowWidget(
                                      context: context,
                                      title: context.tr.amountBeforeTax,
                                      value: formatAmount(totalBeforeTax),
                                    ),
                                    10.verticalSpace,
                                    _buildRowWidget(
                                      context: context,
                                      title: context.tr.vat15Percent,
                                      value: formatAmount(vatAmount),
                                    ),
                                    10.verticalSpace,
                                    _buildRowWidget(
                                      context: context,
                                      title: context.tr.totalAmount,
                                      value: formatAmount(totalWithVat),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        BlocConsumer<StartReceiveOrderCubit, StartReceiveOrderState>(
          listener: (context, state) {
            if (state is StartReceiveOrderSuccess) {
              NavigationService.I.pop();

              AppBottomSheet.customPageRoute(
                context,
                (context) => const ReceiveOrderSuccessScreen(),
              );
            } else if (state is StartReceiveOrderFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
          builder: (context, state) {
            if (state is StartReceiveOrderLoading) {
              return const AppButtonLoading();
            }

            return AppButton(
              onClick: () {
                _receive(context);
              },
              text: context.tr.markOrderAsReceived,
              enabled: true,
              borderRadius: BorderRadius.circular(15.r),
            );
          },
        ),
      ],
    );
  }

  Widget _buildItemCardcompensatory(
    BuildContext context,
    ReceiveGoodsLocalItemModel item,
    String unitText,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SupplierItemPreviewWidget(
            itemName: item.productName,
            itemImageUrl: item.itemLogo,
          ),
          5.verticalSpace,
          BlocSelector<ValidationCubit, ValidationState, Map<String, dynamic>>(
            selector: (state) {
              return {
                'qtyToReorder':
                    state.fieldsValue['qtyToReorder_${item.itemId}'],
                'order_quality':
                    state.fieldsValue['order_quality_${item.itemId}'],
                'deliveryUrgencyDeadline':
                    state.fieldsValue['deliveryUrgencyDeadline'],
              };
            },
            builder: (context, values) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRowWidget(
                    context: context,
                    title: context.tr.qtyToReorder,
                    value:
                        (values['qtyToReorder'] != null &&
                            values['qtyToReorder'].toString().isNotEmpty)
                        ? '${values['qtyToReorder']} $unitText'
                        : '${item.qtyOrdered - item.qtyReceived} $unitText',
                  ),
                  10.verticalSpace,
                  _buildRowWidget(
                    context: context,
                    title: context.tr.quality,
                    value: values['order_quality'] != null
                        ? values['order_quality'].toString()
                        : '-',
                  ),
                  10.verticalSpace,
                  BlocSelector<ValidationCubit, ValidationState, String?>(
                    selector: (state) => state.fieldsValue['supplierName'],
                    builder: (context, supplierName) {
                      return _buildRowWidget(
                        context: context,
                        title: context.tr.reorderSource,
                        value: supplierName ?? '-',
                      );
                    },
                  ),
                  10.verticalSpace,
                  _buildRowWidget(
                    context: context,
                    title: context.tr.deliveryUrgencyDeadline,
                    value:
                        values['deliveryUrgencyDeadline'] != null &&
                            values['deliveryUrgencyDeadline']
                                .toString()
                                .isNotEmpty
                        ? DateFormatter.formatDateMDY(
                                DateTime.tryParse(
                                  values['deliveryUrgencyDeadline'],
                                ),
                              ) ??
                              '-'
                        : '-',
                  ),
                ],
              );
            },
          ),
          12.verticalSpace,
          if (item.selectedImage != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.attachPhotoEvidence,
                  style: AppStyles.s14W600.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                4.verticalSpace,
                AppFileImage(
                  image: item.selectedImage!.path,
                  borderRadius: BorderRadius.circular(12.r),
                  height: 200.r,
                  width: double.infinity,
                ),
              ],
            ),
          12.verticalSpace,
          if (item.note != null && item.note!.isNotEmpty)
            _buildAdditionalNoteWidget(context, item.note),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    ReceiveGoodsLocalItemModel item,
    String unitText,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SupplierItemPreviewWidget(
            itemName: item.productName,
            itemImageUrl: item.itemLogo,
          ),
          5.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.qtyOrdered,
            value: '${item.qtyOrdered} $unitText',
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.qtyReceived,
            value: '${item.qtyReceived} $unitText',
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.quality,
            value: item.quality.getString(context),
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.temperature,
            value: '${item.termperature}°C',
          ),
          10.verticalSpace,
          _buildRowWidget(
            context: context,
            title: context.tr.expirationDate,
            value:
                DateFormatter.formatDateMDY(
                  DateTime.tryParse(item.expirationDate),
                ) ??
                item.expirationDate,
          ),

          // Display image if available (required for variance, optional for normal)
          if (item.selectedImage != null) ...[
            12.verticalSpace,
            _buildItemImageWidget(context, item.selectedImage!),
          ],

          // Display note if available (required for variance, optional for normal)
          if (item.note != null && item.note!.isNotEmpty) ...[
            12.verticalSpace,
            _buildAdditionalNoteWidget(context, item.note),
          ],
        ],
      ),
    );
  }

  Widget _buildItemImageWidget(BuildContext context, MediaFile imageFile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.additionalNote, // Reusing translation or add specific one
          style: AppStyles.s14W600.copyWith(color: context.customColor.text3),
        ),
        4.verticalSpace,
        AppFileImage(
          image: imageFile.path,
          borderRadius: BorderRadius.circular(12.r),
          height: 200.r,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildRowWidget({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Expanded(
          child:
              customValue ??
              Text(
                value ?? '',
                textAlign: TextAlign.end,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildAdditionalNoteWidget(BuildContext context, String? note) {
    if (note == null || note.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.verticalSpace,
        Text(
          context.tr.additionalNote,
          style: AppStyles.s14W600.copyWith(color: context.customColor.text3),
        ),
        4.verticalSpace,
        Text(
          note,
          style: AppStyles.s14W400.copyWith(color: context.customColor.text1),
        ),
        10.verticalSpace,
      ],
    );
  }

  Widget _buildInvoiceAttachmentWidget(BuildContext context, MediaFile? file) {
    if (file == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      margin: EdgeInsets.only(top: 10.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          Text(
            context.tr.invoiceAttachment,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          FilePreviewWidget(
            file: file,
            onTapIcon: () {
              context.read<PagingCubit>().previousStep();
            },
            icon: AppAssets.refresh,
          ),
          10.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildVarianceSummary(BuildContext context) {
    return BlocSelector<
      ValidationCubit,
      ValidationState,
      List<ReceiveGoodsLocalItemModel>
    >(
      selector: (state) {
        final items =
            state.getListValue<ReceiveGoodsLocalItemModel>(
              'receiveGoodsItems',
            ) ??
            [];
        return items.where((item) => item.isVariance).toList();
      },
      builder: (context, varianceItems) {
        // Only show if there are variance items
        if (varianceItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
          margin: EdgeInsets.only(bottom: 10.r, top: 10.r),
          child: CustomScrollView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              Row(
                children: [
                  AppSvg(
                    assetName: AppAssets.warning,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.error,
                      BlendMode.srcIn,
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.varianceSummary,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ).sliverBoxAdapter,
              8.verticalSpace.sliverBoxAdapter,
              SliverList.builder(
                itemCount: varianceItems.length,
                itemBuilder: (context, index) {
                  final item = varianceItems[index];
                  final variance = item.qtyOrdered - item.qtyReceived;
                  final unitText = item.unit;

                  return Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.all(12.r),
                    margin: EdgeInsets.only(bottom: 8.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.itemNameVariance(item.productName),
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            5.horizontalSpace,
                            Icon(
                              Icons.circle,
                              size: 3.r,
                              color: context.customColor.text3,
                            ),
                            5.horizontalSpace,
                            Text(
                              context.tr.shortQuantityValue(
                                variance.toString(),
                                unitText,
                                (variance * item.unitPrice).toString(),
                              ),
                              style: AppStyles.s13W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionalNoteWidget(BuildContext context) {
    return BlocSelector<ValidationCubit, ValidationState, String?>(
      selector: (state) => state.fieldsValue['note'],
      builder: (context, note) {
        // Only show if note is not empty
        if (note == null || note.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            Text(
              context.tr.additionalNote,
              style: AppStyles.s14W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.verticalSpace,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
              child: Text(
                note,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
