import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/features/receive_goods/presentation/cubit/get_receive_order_inspection/get_receive_order_inspection_cubit.dart';
import 'package:assab/features/receive_goods/presentation/cubit/get_receive_order_inspection/get_receive_order_inspection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/receive_goods_quality_enum.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_calendar.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/receive_goods_local_item_model.dart';
import '../../data/models/receive_order_inspection_response.dart';
import '../widgets/receive_order_inspection_view_add_note_section_no_variance.dart';
import '../widgets/receive_order_inspection_view_add_note_section_variance.dart';
import '../widgets/receive_order_inspection_view_add_photo_section_no_variance.dart';
import '../widgets/receive_order_inspection_view_add_photo_section_variance.dart';
import '../widgets/receive_order_item_preview_widget.dart';

class ReceiveOrderInspectionView extends StatefulWidget {
  final String orderId;

  const ReceiveOrderInspectionView({super.key, required this.orderId});

  @override
  State<ReceiveOrderInspectionView> createState() =>
      _ReceiveOrderInspectionViewState();
}

class _ReceiveOrderInspectionViewState
    extends State<ReceiveOrderInspectionView> {
  List<ReceiveGoodsQualityEnum> get _qualities => [
    ReceiveGoodsQualityEnum.excellent,
    ReceiveGoodsQualityEnum.normal,
    ReceiveGoodsQualityEnum.poor,
  ];

  @override
  void initState() {
    super.initState();

    _getInspection();
  }

  void _getInspection() {
    context.read<GetReceiveOrderInspectionCubit>().getReceiveOrderInspection(
      orderId: widget.orderId,
    );
  }

  void _addDynamicFieldListViewItems(
    List<GoodsInspectionItem> goodsInspection,
  ) {
    final validationCubit = context.read<ValidationCubit>();

    for (final good in goodsInspection) {
      validationCubit.addDynamicFields({
        'qtyReceived_${good.itemId}',
        'quality_${good.itemId}',
        'temperature_${good.itemId}',
        'expirationDate_${good.itemId}',
        'note_${good.itemId}',
      });

      validationCubit.toggleFieldRequirement(
        'note_${good.itemId}',
        isRequired: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetReceiveOrderInspectionCubit,
      GetReceiveOrderInspectionState
    >(
      builder: (context, state) {
        if (state is GetReceiveOrderInspectionLoading) {
          return const AppLoadingWidget();
        } else if (state is GetReceiveOrderInspectionFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: _getInspection,
            withBorder: false,
          );
        } else if (state is GetReceiveOrderInspectionSuccess) {
          final inspection = state.response;

          // Store delivery details and order metadata for later summary view
          final validationCubit = context.read<ValidationCubit>();

          validationCubit.validateFieldAndStoreTypedValue<DeliveryDetails>(
            fieldName: 'deliveryDetails',
            value: inspection.data.deliveryDetails,
            isValid: true,
          );

          validationCubit.validateFieldAndStoreValue(
            fieldName: 'orderNumber',
            value: inspection.data.orderNumber,
            isValid: inspection.data.orderNumber.isNotEmpty,
          );

          // Store supplier name for later steps
          validationCubit.validateFieldAndStoreValue(
            fieldName: 'supplierName',
            value: inspection.data.supplierName,
            isValid: inspection.data.supplierName.isNotEmpty,
          );

          _addDynamicFieldListViewItems(inspection.data.goodsInspection);

          return Column(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  context.tr.deliveryDetails,
                                  style: AppStyles.s14W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                12.horizontalSpace,
                                Icon(
                                  Icons.error_outline_outlined,
                                  size: 15.r,
                                  color: context.customColor.text1,
                                ),
                              ],
                            ),
                            _rowDeliveryDetailItem(
                              context,
                              context.tr.driver,
                              inspection.data.deliveryDetails.driverName,
                            ),
                            10.verticalSpace,
                            _rowDeliveryDetailItem(
                              context,
                              context.tr.contactNumber,
                              '${inspection.data.deliveryDetails.contactNumber}',
                            ),
                            10.verticalSpace,
                            _rowDeliveryDetailItem(
                              context,
                              context.tr.vehicle,
                              inspection.data.deliveryDetails.vehicleNumber,
                            ),
                            10.verticalSpace,
                            _rowDeliveryDetailItem(
                              context,
                              context.tr.arrivalTime,
                              '${DateFormatter.formatDateMDY(DateTime.tryParse(inspection.data.deliveryDetails.arrivalTime))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(inspection.data.deliveryDetails.arrivalTime))}',
                            ),
                          ],
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
                        itemCount: inspection.data.goodsInspection.length,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final item = inspection.data.goodsInspection[index];
                          final itemUnit = item.unit;

                          return Container(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.all(15.r),
                            margin: EdgeInsets.only(bottom: 10.r),
                            child: Column(
                              children: [
                                ReceiveOrderItemPreviewWidget(
                                  itemName: item.productName,
                                  itemImageUrl: item.itemLogo,
                                ),
                                10.verticalSpace,
                                CustomDivider(
                                  color: context.customColor.border,
                                ),
                                10.verticalSpace,
                                _buildRowListViewItemWidget(
                                  context: context,
                                  title: context.tr.qtyOrdered,
                                  value: '${item.qtyOrdered} $itemUnit',
                                ),
                                10.verticalSpace,
                                CustomDivider(
                                  color: context.customColor.border,
                                ),
                                10.verticalSpace,
                                _buildRowListViewItemWidget(
                                  context: context,
                                  title: context.tr.qtyReceived,
                                  customValue: ContainerCustomTextField(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.r,
                                      vertical: 5.r,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                    backgroundColor:
                                        context.customColor.reversedTextColor,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            hintText: '0',
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              context
                                                  .read<ValidationCubit>()
                                                  .validateFieldAndStoreValue(
                                                    fieldName:
                                                        'qtyReceived_${item.itemId}',
                                                    value: value,
                                                    isValid: value.isNotEmpty,
                                                  );
                                            },
                                          ),
                                        ),
                                        2.horizontalSpace,
                                        Text(
                                          '/${context.tr.kg}',
                                          style: AppStyles.s10W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                        4.horizontalSpace,
                                        AppSvg(
                                          assetName: AppAssets.edit,
                                          width: 10.r,
                                          colorFilter: ColorFilter.mode(
                                            context.theme.primaryColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                CustomDivider(
                                  color: context.customColor.border,
                                ),
                                10.verticalSpace,
                                _buildRowListViewItemWidget(
                                  context: context,
                                  title: context.tr.quality,
                                  value: 'as',
                                  customValue:
                                      CustomDropdown<ReceiveGoodsQualityEnum>(
                                        items: _qualities,
                                        displayTextBuilder: (value) =>
                                            value?.getString(context) ??
                                            context.tr.selectQuality,
                                        displayTextSize: 12.r,
                                        displayTextWeight: FontWeight.w500,
                                        hint: context.tr.selectQuality,
                                        dropdownHeight: 150.r,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.r,
                                          vertical: 5.r,
                                        ),
                                        backgroundColor: context
                                            .customColor
                                            .reversedTextColor,
                                        iconSize: 15.r,
                                        borderRadius: 10.r,
                                        onChanged: (value) {
                                          context
                                              .read<ValidationCubit>()
                                              .validateFieldAndStoreValue(
                                                fieldName:
                                                    'quality_${item.itemId}',
                                                value: value.toString(),
                                                isValid: true,
                                              );
                                        },
                                        itemBuilder:
                                            (context, item, isSelected) {
                                              return Container(
                                                padding: EdgeInsets.all(16.r),
                                                child: Text(
                                                  item.getString(context),
                                                  style: AppStyles.s12W500
                                                      .copyWith(
                                                        color: isSelected
                                                            ? context
                                                                  .theme
                                                                  .primaryColor
                                                            : context
                                                                  .customColor
                                                                  .text1,
                                                      ),
                                                ),
                                              );
                                            },
                                      ),
                                ),
                                10.verticalSpace,
                                CustomDivider(
                                  color: context.customColor.border,
                                ),
                                10.verticalSpace,
                                _buildRowListViewItemWidget(
                                  context: context,
                                  title: context.tr.temperature,
                                  customValue: ContainerCustomTextField(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.r,
                                      vertical: 5.r,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                    backgroundColor:
                                        context.customColor.reversedTextColor,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                            hintText: '0',
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              context
                                                  .read<ValidationCubit>()
                                                  .validateFieldAndStoreValue(
                                                    fieldName:
                                                        'temperature_${item.itemId}',
                                                    value: value,
                                                    isValid: value.isNotEmpty,
                                                  );
                                            },
                                          ),
                                        ),
                                        2.horizontalSpace,
                                        Text(
                                          '/℃',
                                          style: AppStyles.s10W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                        4.horizontalSpace,
                                        AppSvg(
                                          assetName: AppAssets.edit,
                                          width: 10.r,
                                          colorFilter: ColorFilter.mode(
                                            context.theme.primaryColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                CustomDivider(
                                  color: context.customColor.border,
                                ),
                                10.verticalSpace,
                                _buildRowListViewItemWidget(
                                  context: context,
                                  title: context.tr.expirationDate,
                                  customValue: AppGestureDetectorButton(
                                    onTap: () {
                                      final validationCubit = context
                                          .read<ValidationCubit>();

                                      AppBottomSheet.pageRoute(context, (
                                        context,
                                      ) {
                                        return Expanded(
                                          child: AppPaddingWidget(
                                            child: CustomCalendar(
                                              onDateSelected: (selectedDate) {
                                                validationCubit
                                                    .validateFieldAndStoreValue(
                                                      fieldName:
                                                          'expirationDate_${item.itemId}',
                                                      value: selectedDate
                                                          .toIso8601String(),
                                                      isValid: true,
                                                    );

                                                NavigationService.I.pop();
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                    child: ContainerCustomTextField(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.r,
                                        vertical: 5.r,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                      backgroundColor:
                                          context.customColor.reversedTextColor,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child:
                                                BlocSelector<
                                                  ValidationCubit,
                                                  ValidationState,
                                                  String?
                                                >(
                                                  selector: (state) => state
                                                      .fieldsValue['expirationDate_${item.itemId}'],
                                                  builder: (context, state) {
                                                    return Text(
                                                      DateFormatter.formatDateMDY(
                                                            DateTime.tryParse(
                                                              state ?? '',
                                                            ),
                                                          ) ??
                                                          'June 20, 2026',
                                                      style: AppStyles.s12W500
                                                          .copyWith(
                                                            color: state != null
                                                                ? context
                                                                      .customColor
                                                                      .text1
                                                                : context
                                                                      .customColor
                                                                      .text3,
                                                          ),
                                                    );
                                                  },
                                                ),
                                          ),
                                          4.horizontalSpace,
                                          AppSvg(
                                            assetName: AppAssets.calendar,
                                            width: 15.r,
                                            colorFilter: ColorFilter.mode(
                                              context.theme.primaryColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                10.verticalSpace,
                                CustomDivider(
                                  color: context.customColor.border,
                                ),
                                10.verticalSpace,
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  bool
                                >(
                                  selector: (state) {
                                    final qtyReceived = state
                                        .fieldsValue['qtyReceived_${item.itemId}'];

                                    if (qtyReceived == null ||
                                        qtyReceived.isEmpty) {
                                      return false;
                                    }

                                    return (int.tryParse(qtyReceived) ?? 0) <
                                        item.qtyOrdered;
                                  },
                                  builder: (context, isVariance) {
                                    final validationCubit = context
                                        .read<ValidationCubit>();

                                    if (isVariance) {
                                      validationCubit.addDynamicFields({
                                        'photoMedia_${item.itemId}',
                                      });

                                      validationCubit.toggleFieldRequirement(
                                        'note_${item.itemId}',
                                        isRequired: true,
                                      );

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LabelTextField(
                                            text: context.tr.addPhotoOfItem,
                                          ),
                                          5.verticalSpace,
                                          ReceiveOrderInspectionViewAddPhotoSectionVariance(
                                            onPhotoAdded: (value) {
                                              validationCubit
                                                  .validateFieldAndStoreTypedValue<
                                                    MediaFile?
                                                  >(
                                                    fieldName:
                                                        'photoMedia_${item.itemId}',
                                                    value: value,
                                                    isValid: value != null,
                                                  );
                                            },
                                          ),
                                          10.verticalSpace,
                                          CustomDivider(
                                            color: context.customColor.border,
                                          ),
                                          10.verticalSpace,
                                          ReceiveOrderInspectionViewAddNoteSectionVariance(
                                            onChanged: (value) {
                                              validationCubit
                                                  .validateFieldAndStoreValue(
                                                    fieldName:
                                                        'note_${item.itemId}',
                                                    value: value,
                                                    isValid: value.isNotEmpty,
                                                  );
                                            },
                                          ),
                                        ],
                                      );
                                    }

                                    if (validationCubit.fieldIsExists(
                                      'photoMedia_${item.itemId}',
                                    )) {
                                      validationCubit.removeDynamicFields({
                                        'photoMedia_${item.itemId}',
                                      });
                                    }

                                    validationCubit.toggleFieldRequirement(
                                      'note_${item.itemId}',
                                      isRequired: false,
                                    );

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LabelTextField(
                                          text: context.tr.addPhotoOfItem,
                                          isLabelOptional: true,
                                          isLabelRequired: false,
                                        ),
                                        5.verticalSpace,
                                        ReceiveOrderInspectionViewAddPhotoSectionNoVariance(
                                          onPhotoAdded: (value) {
                                            validationCubit
                                                .validateFieldAndStoreTypedValue<
                                                  MediaFile?
                                                >(
                                                  fieldName:
                                                      'photoMedia_${item.itemId}',
                                                  value: value,
                                                  isValid:
                                                      true, // Optional for non-variance
                                                );
                                          },
                                        ),
                                        10.verticalSpace,
                                        CustomDivider(
                                          color: context.customColor.border,
                                        ),
                                        10.verticalSpace,
                                        ReceiveOrderInspectionViewAddNoteSectionNoVariance(
                                          onChanged: (value) {
                                            validationCubit
                                                .validateFieldAndStoreValue(
                                                  fieldName:
                                                      'note_${item.itemId}',
                                                  value: value,
                                                  isValid:
                                                      true, // Optional for non-variance
                                                );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              BlocSelector<ValidationCubit, ValidationState, bool>(
                selector: (state) {
                  final qtyAllValid = inspection.data.goodsInspection.every((
                    item,
                  ) {
                    final qtyReceived =
                        state.fieldsValue['qtyReceived_${item.itemId}'];

                    return qtyReceived != null && qtyReceived.isNotEmpty;
                  });

                  final qulityAllValid = inspection.data.goodsInspection.every((
                    item,
                  ) {
                    final quality = state.fieldsValue['quality_${item.itemId}'];

                    return quality != null && quality.isNotEmpty;
                  });

                  final temperatureAllValid = inspection.data.goodsInspection
                      .every((item) {
                        final temperature =
                            state.fieldsValue['temperature_${item.itemId}'];

                        return temperature != null && temperature.isNotEmpty;
                      });

                  final expirationDateAllValid = inspection.data.goodsInspection
                      .every((item) {
                        final expirationDate =
                            state.fieldsValue['expirationDate_${item.itemId}'];

                        return expirationDate != null &&
                            expirationDate.isNotEmpty;
                      });

                  // Validate variance items have image and note
                  bool varianceItemsValid = true;
                  if (qtyAllValid) {
                    // Check each item for variance
                    for (final item in inspection.data.goodsInspection) {
                      final qtyReceived =
                          state.fieldsValue['qtyReceived_${item.itemId}'];
                      final isVariance =
                          (int.tryParse(qtyReceived ?? '') ?? 0) <
                          item.qtyOrdered;

                      if (isVariance) {
                        // Check if image exists and is valid
                        final hasValidImage =
                            state.fieldsValidity['photoMedia_${item.itemId}'] ==
                            true;

                        // Check if note exists and is valid
                        final hasValidNote =
                            state.fieldsValidity['note_${item.itemId}'] == true;

                        if (!hasValidImage || !hasValidNote) {
                          varianceItemsValid = false;
                          break;
                        }
                      }
                    }

                    // Update isVariance in state
                    final hasVariance = inspection.data.goodsInspection.any((
                      item,
                    ) {
                      final qtyReceived =
                          state.fieldsValue['qtyReceived_${item.itemId}'];
                      return (int.tryParse(qtyReceived ?? '') ?? 0) <
                          item.qtyOrdered;
                    });

                    context
                        .read<ValidationCubit>()
                        .validateFieldAndStoreTypedValue<bool>(
                          fieldName: 'isVariance',
                          value: hasVariance,
                          isValid: true,
                        );
                  }

                  return qtyAllValid &&
                      qulityAllValid &&
                      temperatureAllValid &&
                      expirationDateAllValid &&
                      varianceItemsValid;
                },
                builder: (context, state) {
                  return AppButton(
                    onClick: () {
                      final validationCubit = context.read<ValidationCubit>();

                      // Build list of ReceiveGoodsLocalItemModel from inspection data
                      final items = _buildReceiveGoodsLocalItems(
                        inspection.data.goodsInspection,
                        validationCubit,
                      );

                      // Store the list in ValidationCubit
                      validationCubit.validateFieldAndStoreList<
                        ReceiveGoodsLocalItemModel
                      >(
                        fieldName: 'receiveGoodsItems',
                        value: items,
                        isValid: items.isNotEmpty,
                      );

                      final hasVariance = items.any((item) => item.isVariance);

                      validationCubit.validateFieldAndStoreTypedValue<bool>(
                        fieldName: 'isVariance',
                        value: hasVariance,
                        isValid: true,
                      );

                      validationCubit.addDynamicFields({'documentType'});

                      context.read<PagingCubit>().nextStep();
                    },
                    enabled: state,
                    text: context.tr.continueToDocumentRegistration,
                    borderRadius: BorderRadius.circular(15.r),
                  );
                },
              ),
            ],
          );
        }

        return AppLocalFailure(withBorder: false, onRetry: _getInspection);
      },
    );
  }

  List<ReceiveGoodsLocalItemModel> _buildReceiveGoodsLocalItems(
    List<GoodsInspectionItem> goodsInspection,
    ValidationCubit validationCubit,
  ) {
    return goodsInspection.map((item) {
      final qtyReceived = validationCubit.getFieldValue(
        'qtyReceived_${item.itemId}',
      );

      final isVariance = (int.tryParse(qtyReceived) ?? 0) < item.qtyOrdered;

      // Retrieve optional image and note
      final selectedImage = validationCubit.getTypedValue<MediaFile>(
        'photoMedia_${item.itemId}',
      );

      final note = validationCubit.getFieldValue('note_${item.itemId}');

      return ReceiveGoodsLocalItemModel(
        itemId: item.itemId,
        productName: item.productName,
        itemLogo: item.itemLogo,
        qtyOrdered: item.qtyOrdered,
        qtyReceived: int.tryParse(qtyReceived) ?? 0,
        unitPrice: item.unitPrice,
        quality: ReceiveGoodsQualityEnum.fromString(
          validationCubit.getFieldValue('quality_${item.itemId}'),
        ),
        termperature:
            int.tryParse(
              validationCubit.getFieldValue('temperature_${item.itemId}'),
            ) ??
            0,
        expirationDate: validationCubit.getFieldValue(
          'expirationDate_${item.itemId}',
        ),
        unit: item.unit,
        isVariance: isVariance,
        selectedImage: selectedImage,
        note: note.isNotEmpty == true ? note : null,
      );
    }).toList();
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

  Widget _buildRowListViewItemWidget({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customValue,
  }) {
    return Row(
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
}
