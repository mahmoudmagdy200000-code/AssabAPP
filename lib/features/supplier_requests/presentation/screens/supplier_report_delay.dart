import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/time_picker_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/file_preview_widget.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_start_track_order/supplier_start_track_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/enums/supplier_new_expected_delivery_date_type.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/custom_calendar.dart';
import '../../data/models/supplier_report_delay_request.dart';
import '../cubit/supplier_start_track_order/supplier_start_track_order_cubit.dart';
import '../widgets/report_delayed_success_view.dart';

class SupplierReportDelay extends StatefulWidget {
  final String orderId;

  const SupplierReportDelay({super.key, required this.orderId});

  @override
  State<SupplierReportDelay> createState() => _SupplierReportDelayState();
}

class _SupplierReportDelayState extends State<SupplierReportDelay> {
  late final ValueNotifier<int> _selectedDateIndex;

  @override
  void initState() {
    super.initState();
    _selectedDateIndex = ValueNotifier<int>(-1);
  }

  @override
  void dispose() {
    _selectedDateIndex.dispose();
    super.dispose();
  }

  void _supplierRepostDelayOrder(SupplierReportDelayRequest body) {
    context.read<SupplierStartTrackOrderCubit>().supplierRepostDelayOrder(
      orderId: widget.orderId,
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.reportDelay,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      context
                          .tr
                          .ifYoureExperiencingADelayPleaseCompleteTheRequiredFields,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    Text(
                      context.tr.beClearAndSpecificSoTheyCanAdjustAccordingly,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    16.verticalSpace,
                    const CustomDivider(),
                    16.verticalSpace,
                    ContainerCustomTextField(
                      label: context.tr.delayDetails,
                      child: CustomTextField(
                        hintText:
                            context.tr.egStockIssueTransportBreakdownWeatherEtc,
                        maxLines: 3,
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreValue(
                                fieldName: 'details',
                                value: value,
                                isValid: value.isNotEmpty,
                              );
                        },
                      ),
                    ),
                    16.verticalSpace,
                    LabelTextField(text: context.tr.newExpectedDeliveryDate),
                    Row(
                      children: List.generate(2, (index) {
                        final text = [context.tr.today, context.tr.custom];

                        return Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: ValueListenableBuilder(
                                  valueListenable: _selectedDateIndex,
                                  builder: (context, value, child) {
                                    final isSelected = value == index;

                                    return CustomTextButton(
                                      text: text[index],
                                      onTap: () {
                                        _selectedDateIndex.value = index;

                                        final validationCubit = context
                                            .read<ValidationCubit>();

                                        if (index == 1 &&
                                            !validationCubit.fieldIsExists(
                                              'newDate',
                                            )) {
                                          validationCubit.addDynamicFields({
                                            'newDate',
                                          });
                                        }
                                      },
                                      borderColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.border,
                                      textColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text3,
                                    );
                                  },
                                ),
                              ),
                              if (index == 0) 8.horizontalSpace,
                            ],
                          ),
                        );
                      }),
                    ),
                    5.verticalSpace,
                    ValueListenableBuilder(
                      valueListenable: _selectedDateIndex,
                      builder: (context, value, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: value == 0
                              ? _buildNewTime(context)
                              : value == 1
                              ? Column(
                                  children: [
                                    _buildNewDate(),
                                    5.verticalSpace,
                                    _buildNewTime(context),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        );
                      },
                    ),
                    16.verticalSpace,
                    LabelTextField(
                      text: context.tr.attachment,
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
                          return FilePreviewWidget(
                            file: state,
                            onTapIcon: () {
                              context.read<MediaCubit>().unselectFile(state);
                            },
                            icon: AppAssets.trashSvg,
                          );
                        }

                        return const UploadExpenseInvoiceReceipt(
                          singleSelectionMode: true,
                        );
                      },
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
                    (context) => const ReportDelayedSuccessView(),
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

                return BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) => state.enableButton,
                  builder: (context, state) {
                    return AppButton(
                      onClick: () {
                        _supplierRepostDelayOrder(
                          SupplierReportDelayRequest(
                            message: context
                                .read<ValidationCubit>()
                                .getFieldValue('details'),
                            newExpectedDeliveryDateType:
                                _selectedDateIndex.value == 0
                                ? NewExpectedDeliveryDateType.today
                                : NewExpectedDeliveryDateType.custom,
                            newTime: context
                                .read<ValidationCubit>()
                                .getFieldValue('newTime'),
                            newDate: _selectedDateIndex.value == 1
                                ? context.read<ValidationCubit>().getFieldValue(
                                    'newDate',
                                  )
                                : null,
                            photo: context
                                .read<MediaCubit>()
                                .allFilesSelected
                                .firstOrNull
                                ?.toFile,
                          ),
                        );
                      },
                      enabled: state,
                      text: context.tr.submitUpdate,
                      borderRadius: BorderRadius.circular(12.r),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewTime(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () async {
        TimePickerService.showTimePickerDialog(
          context,
          onTimePicked: (time) {
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'newTime',
              value: time?.format(context) ?? '',
              isValid: time != null,
            );
          },
        );
      },
      child: ContainerCustomTextField(
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: 20.r,
              color: context.customColor.text3,
            ),
            5.horizontalSpace,
            Expanded(
              child: BlocSelector<ValidationCubit, ValidationState, String?>(
                selector: (state) => state.fieldsValue['newTime'],
                builder: (context, state) {
                  return Text(
                    state ?? context.tr.newTime,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  );
                },
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              size: 20.r,
              color: context.customColor.text3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewDate() {
    return AppGestureDetectorButton(
      onTap: () {
        final validationCubit = context.read<ValidationCubit>();

        AppBottomSheet.pageRoute(context, (context) {
          return Expanded(
            child: AppPaddingWidget(
              child: CustomCalendar(
                onDateSelected: (selectedDate) {
                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'newDate',
                    value: selectedDate.toIso8601String(),
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
        child: Row(
          children: [
            AppSvg(assetName: AppAssets.calendar, width: 20.r),
            5.horizontalSpace,
            Expanded(
              child: BlocSelector<ValidationCubit, ValidationState, String?>(
                selector: (state) => state.fieldsValue['newDate'],
                builder: (context, state) {
                  return Text(
                    DateFormatter.formatDateMDY(
                          DateTime.tryParse(state ?? ''),
                        ) ??
                        context.tr.newDate,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  );
                },
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              size: 20.r,
              color: context.customColor.text3,
            ),
          ],
        ),
      ),
    );
  }
}
