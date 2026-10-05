import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiveWithoutPriorOrderScreen extends StatelessWidget {
  const ReceiveWithoutPriorOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Form Fill',
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      'Complete form below to receive without prior order:',
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                    ContainerCustomTextField(
                      label: context.tr.supplierName,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.tr.supplierName,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: context.customColor.text1,
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    ContainerCustomTextField(
                      label: 'Delivery Reference No.',
                      customTextOption: 'If Available',
                      isLabelRequired: false,
                      isLabelOptional: true,
                      child: CustomTextField(
                        hintText: 'e.g #1472hy722',
                        onChanged: (value) {},
                      ),
                    ),
                    12.verticalSpace,
                    ContainerCustomTextField(
                      label: 'Product Name',
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Multiple product names not allowed',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                          5.horizontalSpace,
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: context.customColor.text1,
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    ContainerCustomTextField(
                      label: 'Unit Of Measurement',
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Choose unit',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                          5.horizontalSpace,
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: context.customColor.text1,
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    ContainerCustomTextField(
                      label: 'Quantity Received',
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'e.g 500',
                              onChanged: (value) {},
                            ),
                          ),
                          5.horizontalSpace,
                          Text(
                            'Unit',
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    ContainerCustomTextField(
                      label: 'Price Per Unit',
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'e.g 500',
                              onChanged: (value) {},
                            ),
                          ),
                          5.horizontalSpace,
                          const SaudiRiyalSvgWidget(),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    ContainerCustomTextField(
                      label: context.tr.paymentTerms,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'e.g. COD or 7 Days or 30 Days',
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ),
                          5.horizontalSpace,
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: context.customColor.text1,
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    const LabelTextField(
                      text: 'Upload Invoice or Delivery Note',
                    ),
                    const UploadExpenseInvoiceReceipt(),
                    12.verticalSpace,
                    ContainerCustomTextField(
                      label: 'Notes / Remarks',
                      isLabelRequired: false,
                      isLabelOptional: true,
                      child: CustomTextField(
                        hintText:
                            'Describe the inspections, including any discoveries or details',
                        onChanged: (value) {},
                        maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            BlocSelector<ValidationCubit, ValidationState, bool>(
              selector: (state) => state.enableButton,
              builder: (context, state) {
                return AppButton(
                  onClick: () {},
                  text: 'Continue To Inspection Details',
                  enabled: state,
                  borderRadius: BorderRadius.circular(15.r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
