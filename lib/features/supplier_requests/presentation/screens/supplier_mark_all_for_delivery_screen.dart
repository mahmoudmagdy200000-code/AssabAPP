import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_start_track_order/supplier_start_track_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/services/time_picker_service.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/selected_image_preview.dart';
import '../../../../core/widgets/upload_expense_invoice_receipt.dart';
import '../../data/models/supplier_mark_as_delivery_request.dart';
import '../cubit/supplier_start_track_order/supplier_start_track_order_cubit.dart';
import '../widgets/supplier_order_approved_bottom_sheet.dart';

class SupplierMarkAllForDeliveryScreen extends StatelessWidget {
  final String orderId;

  const SupplierMarkAllForDeliveryScreen({super.key, required this.orderId});

  void _validate({
    required BuildContext context,
    required String fieldName,
    required String value,
    required bool isValid,
  }) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: fieldName,
      value: value,
      isValid: isValid,
    );
  }

  void _supplierMarkOrderAsDelivery(
    BuildContext context,
    SupplierMarkAsDeliveryRequest body,
  ) {
    context.read<SupplierStartTrackOrderCubit>().supplierMarkOrderAsDelivery(
      orderId: orderId,
      body: body,
    );
  }

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
                  context.tr.markAllForDelivery,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.reversedTextColor,
                  ),
                ),
                Text(
                  context.tr.pleaseCompleteTheDeliveryDetailsBelow,
                  style: AppStyles.s12W400.copyWith(
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
              child: AppPaddingWidget(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 63.h,
                          width: 4.w,
                          color: context.theme.primaryColor,
                        ),
                        16.horizontalSpace,
                        Expanded(
                          child: Text(
                            context
                                .tr
                                .reviewCarefullyBeforeConfirmingChangesCantBeMadeAfterThis,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    32.verticalSpace,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ContainerCustomTextField(
                              label: context.tr.deliveryAddress,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16.r,
                                    color: context.theme.primaryColor,
                                  ),
                                  12.horizontalSpace,
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: context.tr.deliveryAddress,
                                      onChanged: (value) {
                                        _validate(
                                          context: context,
                                          fieldName: 'deliveryAddress',
                                          value: value,
                                          isValid: value.isNotEmpty,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            12.verticalSpace,
                            ContainerCustomTextField(
                              label: context.tr.driversName,
                              child: CustomTextField(
                                hintText: context.tr.firstNameLastName,
                                onChanged: (value) {
                                  _validate(
                                    context: context,
                                    fieldName: 'deliveryName',
                                    value: value,
                                    isValid: value.isNotEmpty,
                                  );
                                },
                              ),
                            ),
                            12.verticalSpace,
                            ContainerCustomTextField(
                              label: context.tr.vehicleNumber,
                              child: CustomTextField(
                                hintText: context.tr.plateNumberEgAbj8742,
                                onChanged: (value) {
                                  _validate(
                                    context: context,
                                    fieldName: 'vehicleNumber',
                                    value: value,
                                    isValid: value.isNotEmpty,
                                  );
                                },
                              ),
                            ),
                            12.verticalSpace,
                            AppGestureDetectorButton(
                              onTap: () async {
                                await TimePickerService.showTimePickerDialog(
                                  context,
                                  onTimePicked: (time) {
                                    context
                                        .read<ValidationCubit>()
                                        .validateFieldAndStoreValue(
                                          fieldName: 'deliveryTime',
                                          value: time?.format(context) ?? '',
                                          isValid: time != null,
                                        );
                                  },
                                );
                              },
                              child: ContainerCustomTextField(
                                label: context.tr.expectedDeliveryTime,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 20.r,
                                      color: context.customColor.text3,
                                    ),
                                    12.horizontalSpace,
                                    Expanded(
                                      child:
                                          BlocSelector<
                                            ValidationCubit,
                                            ValidationState,
                                            String?
                                          >(
                                            selector: (state) => state
                                                .fieldsValue['deliveryTime'],
                                            builder: (context, state) {
                                              return Text(
                                                state ?? context.tr.pickTime,
                                                style: AppStyles.s12W400
                                                    .copyWith(
                                                      color: (state != null)
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
                                    12.horizontalSpace,
                                    Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 20.r,
                                      color: context.customColor.text3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            12.verticalSpace,
                            LabelTextField(
                              text: context.tr.driversPicture,
                              isLabelOptional: true,
                              isLabelRequired: false,
                            ),
                            BlocSelector<MediaCubit, MediaState, MediaFile?>(
                              selector: (state) {
                                if (state is MediaLoaded) {
                                  final file = state.allFiles
                                      .cast<MediaFile?>()
                                      .firstWhere(
                                        (f) => f!.selected,
                                        orElse: () => null,
                                      );

                                  return file;
                                }

                                return null;
                              },
                              builder: (context, state) {
                                if (state != null) {
                                  return SelectedImagePreview(
                                    mediaFile: state,
                                    singleSelectionMode: true,
                                  );
                                }

                                return const UploadExpenseInvoiceReceipt(
                                  singleSelectionMode: true,
                                );
                              },
                            ),
                            12.verticalSpace,
                            ContainerCustomTextField(
                              label: context.tr.deliveryNotes,
                              isLabelOptional: true,
                              isLabelRequired: false,
                              child: CustomTextField(
                                hintText: context.tr.optionalNote,
                                maxLines: 5,
                                onChanged: (value) {
                                  _validate(
                                    context: context,
                                    fieldName: 'deliveryNotes',
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
                    BlocConsumer<
                      SupplierStartTrackOrderCubit,
                      SupplierStartTrackOrderState
                    >(
                      listener: (context, state) {
                        if (state is SupplierStartTrackOrderSuccess) {
                          NavigationService.I.popToFirst();

                          AppBottomSheet.customPageRoute(
                            context,
                            (context) => SupplierOrderApprovedBottomSheet(
                              title: context.tr.orderStatusUpdated,
                              titleDesc: context
                                  .tr
                                  .youHaveSuccessfullyMarkedOrderAsOutForDelivery,
                              oldStatus: context.tr.outForDelivery,
                              newStatus: context.tr.delivered,
                              description: context
                                  .tr
                                  .addDeliveryDetailsBeforeDispatching,
                              assetName: AppAssets.returnsManagement,
                              iconColor: AppColors.lightGreen,
                              dot1: context.tr.finalDeliveryReceiptOrInvoice,
                            ),
                          );
                        } else if (state is SupplierStartTrackOrderFailure) {
                          AppDialog.showErrorDialog(
                            context: context,
                            failure: state.failure,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is SupplierStartTrackOrderLoading) {
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
                                padding: EdgeInsets.symmetric(vertical: 18.r),
                                borderRadius: 15.r,
                                textColor: context.customColor.text1,
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    bool
                                  >(
                                    selector: (state) => state.enableButton,
                                    builder: (context, state) {
                                      return AppButton(
                                        onClick: () {
                                          final validationCubit = context
                                              .read<ValidationCubit>();

                                          _supplierMarkOrderAsDelivery(
                                            context,
                                            SupplierMarkAsDeliveryRequest(
                                              driverName: validationCubit
                                                  .getFieldValue(
                                                    'deliveryName',
                                                  ),
                                              deliveryAddress: validationCubit
                                                  .getFieldValue(
                                                    'deliveryAddress',
                                                  ),
                                              expectedDeliveryAt:
                                                  validationCubit.getFieldValue(
                                                    'deliveryTime',
                                                  ),
                                              vehicleNumber: validationCubit
                                                  .getFieldValue(
                                                    'vehicleNumber',
                                                  ),
                                              driverPhoto: context
                                                  .read<MediaCubit>()
                                                  .allFilesSelected
                                                  .firstOrNull
                                                  ?.toFile,
                                              notes: validationCubit
                                                  .state
                                                  .fieldsValue['deliveryNotes'],
                                            ),
                                          );
                                        },
                                        text: context.tr.updateStatus,
                                        enabled: state,
                                        background: state
                                            ? AppColors.orange
                                            : context.customColor.text2,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 18.r,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
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
            ),
          ),
        ],
      ),
    );
  }
}
