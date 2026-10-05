import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/list_view_files_preview.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:assab/features/fixed_assets/presentation/screens/fixed_assets_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/custody_preferred_receipt_method.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_calendar.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../custody/presentation/cubit/get_custody_recipients/get_custody_recipients_cubit.dart';
import '../../../custody/presentation/screens/custody_handover_to_cashier_choose_recipient_bottom_sheet_widget.dart';
import '../../../custody/presentation/widgets/custody_app_bar.dart';
import '../../../custody/presentation/widgets/custody_request_preferred_receipt_method_section.dart';
import '../../data/models/brand_owner_payment_request.dart';
import '../cubit/brand_owner_payment/brand_owner_payment_cubit.dart';
import '../cubit/brand_owner_payment/brand_owner_payment_state.dart';

class BrandOwnerPaymentScreen extends StatelessWidget {
  const BrandOwnerPaymentScreen({super.key});

  void _showCalendarBottomSheet(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.pageRoute(
      context,
      (context) => Expanded(
        child: AppPaddingWidget(
          top: 0,
          child: CustomCalendar(
            onDateSelected: (value) {
              NavigationService.I.pop();

              validationCubit.validateFieldAndStoreValue(
                fieldName: 'handoverOrTransferDate',
                value: value.toIso8601String(),
                isValid: true,
              );
            },
          ),
        ),
      ),
    );
  }

  void _submitPayment(BuildContext context) {
    final validationState = context.read<ValidationCubit>();

    final request = BrandOwnerPaymentRequest(
      branchId: validationState.getTypedValue<String>('handoverRecipientId')!,
      amount: double.parse(validationState.getFieldValue('handoverAmount')),
      handoverDate: validationState.getFieldValue('handoverOrTransferDate'),
      paymentMethod: validationState.getFieldValue('preferredReceiptMethod'),
      note: validationState.getFieldValue('additionalNote'),
      purpose: validationState.getFieldValue('purposeOfTransfer'),
      receiptImage: context.read<MediaCubit>().allFilesSelected.isEmpty
          ? null
          : context.read<MediaCubit>().allFilesSelected.first.toFile,
      transferDate: validationState.getFieldValue('handoverOrTransferDate'),
    );

    context.read<BrandOwnerPaymentCubit>().submitOwnerPaymentForm(
      body: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Column(
        children: [
          CustodyAppBar(title: context.tr.ownerPaymentForm),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 20.r),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.error_outline_outlined,
                                color: context.theme.primaryColor,
                                size: 20.r,
                              ),
                              5.horizontalSpace,
                              Flexible(
                                child: Text(
                                  context.tr.sendFundsToBranchManager,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          const CustomDivider(),
                          12.verticalSpace,
                          AppGestureDetectorButton(
                            onTap: () {
                              final validationCubit = context
                                  .read<ValidationCubit>();
                              final chooseItemCubit = context
                                  .read<ChooseItemCubit>();

                              chooseItemCubit.initTempSelection();

                              AppBottomSheet.pageRoute(
                                context,
                                (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) =>
                                          getIt<GetCustodyRecipientsCubit>(),
                                    ),
                                    BlocProvider.value(value: validationCubit),
                                    BlocProvider.value(value: chooseItemCubit),
                                  ],
                                  child:
                                      const CustodyHandoverToCashierChooseRecipientBottomSheetWidget(),
                                ),
                              );
                            },
                            child: ContainerCustomTextField(
                              label: context.tr.branch,
                              child: Row(
                                children: [
                                  Expanded(
                                    child:
                                        BlocSelector<
                                          ValidationCubit,
                                          ValidationState,
                                          String?
                                        >(
                                          selector: (state) =>
                                              state.getTypedValue<String>(
                                                'handoverRecipientName',
                                              ),
                                          builder: (context, state) {
                                            return Text(
                                              state ??
                                                  context
                                                      .tr
                                                      .whoAreYouHandingOverTo,
                                              style: AppStyles.s14W400.copyWith(
                                                color: state == null
                                                    ? context.customColor.text3
                                                    : context.customColor.text1,
                                                fontWeight: state == null
                                                    ? FontWeight.w400
                                                    : FontWeight.w500,
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                  10.horizontalSpace,
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 16.r,
                                    color: context.customColor.text1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          16.verticalSpace,
                          ContainerCustomTextField(
                            label: context.tr.amount,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    hintText: context.tr.amount,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      context
                                          .read<ValidationCubit>()
                                          .validateFieldAndStoreValue(
                                            fieldName: 'handoverAmount',
                                            value: value,
                                            isValid:
                                                double.tryParse(value) !=
                                                    null &&
                                                double.tryParse(value)! > 0,
                                          );
                                    },
                                  ),
                                ),
                                10.horizontalSpace,
                                const SaudiRiyalSvgWidget(),
                              ],
                            ),
                          ),
                          16.verticalSpace,
                          CustodyRequestPreferredReceiptMethodSection(
                            title: context.tr.paymentMethod,
                          ),
                          16.verticalSpace,
                          BlocSelector<
                            ValidationCubit,
                            ValidationState,
                            String?
                          >(
                            selector: (state) =>
                                state.fieldsValue['preferredReceiptMethod'],
                            builder: (context, state) {
                              if (state ==
                                  CustodyPreferredReceiptMethod
                                      .cashHandover
                                      .value) {
                                return AppGestureDetectorButton(
                                  onTap: () =>
                                      _showCalendarBottomSheet(context),
                                  child: ContainerCustomTextField(
                                    label: context.tr.handoverDate,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:
                                              BlocSelector<
                                                ValidationCubit,
                                                ValidationState,
                                                String?
                                              >(
                                                selector: (state) {
                                                  return state
                                                      .fieldsValue['handoverOrTransferDate'];
                                                },
                                                builder: (context, state) {
                                                  return Text(
                                                    DateFormatter.formatDateMDY(
                                                          DateTime.tryParse(
                                                            state ?? '',
                                                          ),
                                                        ) ??
                                                        context.tr.choose,
                                                    style: AppStyles.s12W400
                                                        .copyWith(
                                                          color: state == null
                                                              ? context
                                                                    .customColor
                                                                    .text3
                                                              : context
                                                                    .customColor
                                                                    .text1,
                                                          fontWeight:
                                                              state == null
                                                              ? FontWeight.w400
                                                              : FontWeight.w500,
                                                        ),
                                                  );
                                                },
                                              ),
                                        ),
                                        10.horizontalSpace,
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 16.r,
                                          color: context.customColor.text1,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (state ==
                                  CustodyPreferredReceiptMethod
                                      .bankTransfer
                                      .value) {
                                return Column(
                                  children: [
                                    AppGestureDetectorButton(
                                      onTap: () =>
                                          _showCalendarBottomSheet(context),
                                      child: ContainerCustomTextField(
                                        label: context.tr.transferDate,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child:
                                                  BlocSelector<
                                                    ValidationCubit,
                                                    ValidationState,
                                                    String?
                                                  >(
                                                    selector: (state) {
                                                      return state
                                                          .fieldsValue['handoverOrTransferDate'];
                                                    },
                                                    builder: (context, state) {
                                                      return Text(
                                                        DateFormatter.formatDateMDY(
                                                              DateTime.tryParse(
                                                                state ?? '',
                                                              ),
                                                            ) ??
                                                            context.tr.choose,
                                                        style: AppStyles.s12W400
                                                            .copyWith(
                                                              color:
                                                                  state == null
                                                                  ? context
                                                                        .customColor
                                                                        .text3
                                                                  : context
                                                                        .customColor
                                                                        .text1,
                                                              fontWeight:
                                                                  state == null
                                                                  ? FontWeight
                                                                        .w400
                                                                  : FontWeight
                                                                        .w500,
                                                            ),
                                                      );
                                                    },
                                                  ),
                                            ),
                                            10.horizontalSpace,
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 16.r,
                                              color: context.customColor.text1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    ContainerCustomTextField(
                                      label: context.tr.purposeOfTransfer,
                                      isLabelOptional: true,
                                      isLabelRequired: false,
                                      child: CustomTextField(
                                        hintText:
                                            'e.g transfer to branch treasury',
                                        onChanged: (value) {
                                          context
                                              .read<ValidationCubit>()
                                              .validateFieldAndStoreValue(
                                                fieldName: 'purposeOfTransfer',
                                                value: value,
                                                isValid: true,
                                              );
                                        },
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                          16.verticalSpace,
                          LabelTextField(
                            text: context.tr.uploadInvoiceReceipt,
                            isLabelOptional: true,
                            isLabelRequired: false,
                          ),
                          const UploadExpenseInvoiceReceipt(),
                          10.verticalSpace,
                          ListViewFilesPreview(
                            mediaCubit: context.read<MediaCubit>(),
                            isSilver: false,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                          16.verticalSpace,
                          ContainerCustomTextField(
                            label: context.tr.additionalNote,
                            isLabelRequired: false,
                            isLabelOptional: true,
                            child: CustomTextField(
                              hintText: context.tr.optionalNotes,
                              maxLines: 6,
                              keyboardType: TextInputType.multiline,
                              onChanged: (value) {
                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreValue(
                                      fieldName: 'additionalNote',
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
                  BlocListener<BrandOwnerPaymentCubit, BrandOwnerPaymentState>(
                    listener: (context, state) {
                      if (state is BrandOwnerPaymentSuccess) {
                        NavigationService.I.pop();

                        final validationState = context.read<ValidationCubit>();

                        AppBottomSheet.customPageRoute(
                          context,
                          (context) => FixedAssetsSuccessScreen(
                            title: 'Cash Handover Recorded',
                            message:
                                '${validationState.getFieldValue('handoverAmount')} SAR has been added to the branch manager’s custody balance and logged in your payment history.',
                          ),
                        );
                      } else if (state is BrandOwnerPaymentFailure) {
                        AppDialog.showErrorDialog(
                          context: context,
                          failure: state.failure,
                        );
                      }
                    },
                    child:
                        BlocBuilder<
                          BrandOwnerPaymentCubit,
                          BrandOwnerPaymentState
                        >(
                          builder: (context, state) {
                            if (state is BrandOwnerPaymentLoading) {
                              return const AppButtonLoading();
                            }

                            return BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              bool
                            >(
                              selector: (state) {
                                return state.enableButton;
                              },
                              builder: (context, state) {
                                return AppButton(
                                  onClick: () => _submitPayment(context),
                                  enabled: state,
                                  text: context.tr.confirmHandover,
                                  padding: EdgeInsets.symmetric(vertical: 18.r),
                                );
                              },
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
