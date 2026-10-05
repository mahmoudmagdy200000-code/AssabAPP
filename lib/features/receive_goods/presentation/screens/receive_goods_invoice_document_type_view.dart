import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/payment_terms_enum.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_calendar.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/file_preview_widget.dart';
import '../widgets/receive_goods_variance_summary_widget.dart';

class ReceiveGoodsInvoiceDocumentTypeView extends StatefulWidget {
  const ReceiveGoodsInvoiceDocumentTypeView({super.key});

  @override
  State<ReceiveGoodsInvoiceDocumentTypeView> createState() =>
      _ReceiveGoodsInvoiceDocumentTypeViewState();
}

class _ReceiveGoodsInvoiceDocumentTypeViewState
    extends State<ReceiveGoodsInvoiceDocumentTypeView> {
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();
    _addDynamicField();
  }

  @override
  void dispose() {
    _validationCubit.removeDynamicFields({
      'invoiceNumber',
      'invoiceDate',
      'paymentTerms',
      'dueDate',
      'file',
      'note',
    });
    super.dispose();
  }

  void _addDynamicField() {
    _validationCubit.addDynamicFields({
      'invoiceNumber',
      'invoiceDate',
      'paymentTerms',
      'dueDate',
      'file',
      'note',
    });

    _validationCubit.toggleFieldRequirement('note', isRequired: false);
  }

  List<PaymentTermsEnum> get _paymentTerms => [
    PaymentTermsEnum.net7days,
    PaymentTermsEnum.net15days,
    PaymentTermsEnum.net30days,
    PaymentTermsEnum.net45days,
  ];

  int _getDaysFromPaymentTerms(PaymentTermsEnum paymentTerms) {
    switch (paymentTerms) {
      case PaymentTermsEnum.net7days:
        return 7;
      case PaymentTermsEnum.net15days:
        return 15;
      case PaymentTermsEnum.net30days:
        return 30;
      case PaymentTermsEnum.net45days:
        return 45;
      default:
        return 0;
    }
  }

  void _calculateAndStoreDueDate() {
    final invoiceDateStr = _validationCubit.state.fieldsValue['invoiceDate'];
    final paymentTermsStr = _validationCubit.state.fieldsValue['paymentTerms'];

    if (invoiceDateStr != null && paymentTermsStr != null) {
      final invoiceDate = DateTime.tryParse(invoiceDateStr);
      final paymentTerms = PaymentTermsEnum.fromString(paymentTermsStr);

      if (invoiceDate != null) {
        final days = _getDaysFromPaymentTerms(paymentTerms);
        final dueDate = invoiceDate.add(Duration(days: days));

        _validationCubit.validateFieldAndStoreValue(
          fieldName: 'dueDate',
          value: dueDate.toIso8601String(),
          isValid: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  context.tr.completeTheRequiredInvoiceRegistrationFields,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                12.verticalSpace,
                const CustomDivider(),
                12.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    color: context.customColor.text2,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.r,
                    horizontal: 16.r,
                  ),
                  child: Column(
                    children: [
                      _buildRowWidget(
                        context: context,
                        title: context.tr.invoiceNumber,
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
                                  hintText: '[2024/11/22-485]',
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _validationCubit.validateFieldAndStoreValue(
                                      fieldName: 'invoiceNumber',
                                      value: value,
                                      isValid: value.isNotEmpty,
                                    );
                                  },
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
                      _buildRowWidget(
                        context: context,
                        title: context.tr.date,
                        customValue: AppGestureDetectorButton(
                          onTap: () {
                            AppBottomSheet.pageRoute(context, (context) {
                              return Expanded(
                                child: AppPaddingWidget(
                                  child: CustomCalendar(
                                    onDateSelected: (selectedDate) {
                                      _validationCubit
                                          .validateFieldAndStoreValue(
                                            fieldName: 'invoiceDate',
                                            value: selectedDate
                                                .toIso8601String(),
                                            isValid: true,
                                          );

                                      // Calculate due date after invoice date is selected
                                      _calculateAndStoreDueDate();

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
                                        selector: (state) =>
                                            state.fieldsValue['invoiceDate'],
                                        builder: (context, state) {
                                          return Text(
                                            DateFormatter.formatDateMDY(
                                                  DateTime.tryParse(
                                                    state ?? '',
                                                  ),
                                                ) ??
                                                'June 20, 2026',
                                            style: AppStyles.s12W500.copyWith(
                                              color: state != null
                                                  ? context.customColor.text1
                                                  : context.customColor.text3,
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
                      _buildRowWidget(
                        context: context,
                        title: context.tr.supplier,
                        value:
                            context
                                .read<ValidationCubit>()
                                .state
                                .fieldsValue['supplierName'] ??
                            '',
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.r,
                    horizontal: 16.r,
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
                      5.verticalSpace,
                      BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        List<dynamic>
                      >(
                        selector: (state) =>
                            state.getListValue('receiveGoodsItems') ?? [],
                        builder: (context, items) {
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
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.r,
                    horizontal: 16.r,
                  ),
                  child: Column(
                    children: [
                      _buildRowWidget(
                        context: context,
                        title: context.tr.paymentTerms,
                        customValue: CustomDropdown<PaymentTermsEnum>(
                          items: _paymentTerms,
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
                          backgroundColor:
                              context.customColor.reversedTextColor,
                          iconSize: 15.r,
                          borderRadius: 10.r,
                          onChanged: (value) {
                            _validationCubit.validateFieldAndStoreValue(
                              fieldName: 'paymentTerms',
                              value: value.toString(),
                              isValid: true,
                            );

                            // Calculate due date after payment terms is selected
                            _calculateAndStoreDueDate();
                          },
                          itemBuilder: (context, item, isSelected) {
                            return Container(
                              padding: EdgeInsets.all(16.r),
                              child: Text(
                                item.getString(context),
                                style: AppStyles.s12W500.copyWith(
                                  color: isSelected
                                      ? context.theme.primaryColor
                                      : context.customColor.text1,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      10.verticalSpace,
                      _buildRowWidget(
                        context: context,
                        title: context.tr.dueDate,
                        customValue:
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              String?
                            >(
                              selector: (state) => state.fieldsValue['dueDate'],
                              builder: (context, dueDate) {
                                return Text(
                                  dueDate != null
                                      ? DateFormatter.formatDateMDY(
                                              DateTime.tryParse(dueDate),
                                            ) ??
                                            ''
                                      : '',
                                  textAlign: TextAlign.end,
                                  style: AppStyles.s13W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
                LabelTextField(
                  text: context.tr.uploadInvoice,
                  style: AppStyles.s14W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                4.verticalSpace,
                BlocSelector<MediaCubit, MediaState, MediaFile?>(
                  selector: (state) {
                    if (state is MediaLoaded) {
                      final file = state.allFiles.cast<MediaFile?>().firstWhere(
                        (f) => f!.selected,
                        orElse: () => null,
                      );

                      // Store file in ValidationCubit and validate
                      _validationCubit
                          .validateFieldAndStoreTypedValue<MediaFile?>(
                            fieldName: 'file',
                            value: file,
                            isValid: file != null,
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
                          // Also remove from ValidationCubit
                          _validationCubit
                              .validateFieldAndStoreTypedValue<MediaFile?>(
                                fieldName: 'file',
                                value: null,
                                isValid: false,
                              );
                        },
                        icon: AppAssets.trashSvg,
                      );
                    }

                    return const UploadExpenseInvoiceReceipt();
                  },
                ),
                BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) {
                    final isVariance = state.fieldsValueTyped['isVariance'];
                    return isVariance is bool ? isVariance : false;
                  },
                  builder: (context, isVariance) {
                    if (!isVariance) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        12.verticalSpace,
                        const ReceiveGoodsVarianceSummaryWidget(),
                        12.verticalSpace,
                      ],
                    );
                  },
                ),
                ContainerCustomTextField(
                  label: context.tr.additionalNote,
                  isLabelOptional: true,
                  isLabelRequired: false,
                  child: CustomTextField(
                    maxLines: 4,
                    hintText: context.tr.optionalNote,
                    onChanged: (value) {
                      // Store the note without validation since it's optional
                      _validationCubit.validateFieldAndStoreValue(
                        fieldName: 'note',
                        value: value,
                        isValid: null, // null means don't validate
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        20.verticalSpace,
        BlocSelector<ValidationCubit, ValidationState, bool>(
          selector: (state) {
            final isVariance = state.fieldsValueTyped['isVariance'];
            final hasVariance = isVariance is bool ? isVariance : false;

            final baseValidation =
                state.fieldsValidity['invoiceNumber'] == true &&
                state.fieldsValidity['invoiceDate'] == true &&
                state.fieldsValidity['paymentTerms'] == true &&
                state.fieldsValidity['file'] == true;

            // Only require varianceRequiredAction if there's a variance
            if (hasVariance) {
              return baseValidation &&
                  state.fieldsValidity['varianceRequiredAction'] == true;
            }

            return baseValidation;
          },
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
    );
  }

  Widget _buildRowWidget({
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
