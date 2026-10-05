import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/grouped_invoice_draft_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/switch_button/switch_button_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_calendar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../../../core/widgets/upload_expense_invoice_receipt.dart';
import '../../data/models/supplier_model.dart';
import '../cubit/suppliers/suppliers_cubit.dart';
import 'grouped_invoice_tax_widget.dart';
import 'supplier_list_bottom_sheet_widget.dart';

class GroupedInvoicesWidgetFields extends StatefulWidget {
  final GroupedInvoiceDraftStrategy strategy;
  final List<AttachmentModel> attachments;
  final String id;

  const GroupedInvoicesWidgetFields({
    super.key,
    required this.id,
    required this.strategy,
    required this.attachments,
  });

  @override
  State<GroupedInvoicesWidgetFields> createState() =>
      _GroupedInvoicesWidgetFieldsState();
}

class _GroupedInvoicesWidgetFieldsState
    extends State<GroupedInvoicesWidgetFields> {
  late final TextEditingController _invoiceNumberController;

  @override
  void initState() {
    super.initState();

    _invoiceNumberController = TextEditingController(
      text:
          context
              .read<ValidationCubit>()
              .state
              .fieldsValue['invoiceNumber_${widget.id}'] ??
          '',
    );
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    super.dispose();
  }

  void _showSupplierSelectionDialog(BuildContext context) {
    AppBottomSheet.show(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<SuppliersCubit>()),
          BlocProvider(create: (context) => SearchCubit<SupplierModel>()),
        ],
        child: SupplierListBottomSheetWidget(
          initState: () {
            final validationState = context.read<ValidationCubit>().state;

            final supplerId =
                validationState.fieldsValue['supplierId_${widget.id}'];
            final supplierName =
                validationState.fieldsValue['supplierName_${widget.id}'];

            final supplierIdIsValid =
                validationState.fieldsValidity['supplierId_${widget.id}'] ??
                false;
            final supplierNameIsValid =
                validationState.fieldsValidity['supplierName_${widget.id}'] ??
                false;

            if ((supplerId != null &&
                    supplerId.isNotEmpty &&
                    supplierIdIsValid) &&
                (supplierName != null &&
                    supplierName.isNotEmpty &&
                    supplierNameIsValid)) {
              context.read<SuppliersCubit>().selectSupplier(
                supplerId,
                supplierName,
              );
            }
          },
          onSelected: (value) {
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'supplierName_${widget.id}',
              value: value.name,
              isValid: true,
            );

            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'supplierId_${widget.id}',
              value: value.id.toString(),
              isValid: true,
            );
          },
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    AppBottomSheet.show(
      context,
      (context) => AppPaddingWidget(
        top: 0,
        child: CustomCalendar(
          onDateSelected: (date) {
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'issueDate_${widget.id}',
              value: date.toIso8601String(),
              isValid: true,
            );

            NavigationService.I.pop();
          },
        ),
      ),
    );
  }

  void _validateTaxField({
    required BuildContext context,
    required String netAmount,
    required String supplierName,
    required String taxId,
    required String totalIncVat,
    required String vatAmount,
  }) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'netAmount_${widget.id}',
      value: netAmount,
      isValid: netAmount.isNotEmpty,
    );
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'taxSupplierName_${widget.id}',
      value: supplierName,
      isValid: supplierName.isNotEmpty,
    );
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'taxId_${widget.id}',
      value: taxId,
      isValid: taxId.isNotEmpty,
    );
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'totalIncVat_${widget.id}',
      value: totalIncVat,
      isValid: totalIncVat.isNotEmpty,
    );
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'vatAmount_${widget.id}',
      value: vatAmount,
      isValid: vatAmount.isNotEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(10.r),
      child: Column(
        children: [
          AppGestureDetectorButton(
            onTap: () => _showSupplierSelectionDialog(context),
            child: ContainerCustomTextField(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocSelector<ValidationCubit, ValidationState, String?>(
                    selector: (state) =>
                        state.fieldsValue['supplierName_${widget.id}'],
                    builder: (context, state) {
                      return Text(
                        state ?? context.tr.supplier,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      );
                    },
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18.r,
                    color: context.customColor.text1,
                  ),
                ],
              ),
            ),
          ),
          10.verticalSpace,
          ContainerCustomTextField(
            child: CustomTextField(
              controller: _invoiceNumberController,
              hintText: context.tr.invoiceNumber,
              onChanged: (value) {
                context.read<ValidationCubit>().validateFieldAndStoreValue(
                  fieldName: 'invoiceNumber_${widget.id}',
                  value: value,
                  isValid: value.isNotEmpty,
                );
              },
            ),
          ),
          10.verticalSpace,
          AppGestureDetectorButton(
            onTap: () => _showDatePicker(context),
            child: ContainerCustomTextField(
              child: Row(
                children: [
                  AppSvg(assetName: AppAssets.calendar, width: 16.r),
                  6.horizontalSpace,
                  BlocSelector<ValidationCubit, ValidationState, String?>(
                    selector: (state) =>
                        state.fieldsValue['issueDate_${widget.id}'],
                    builder: (context, state) {
                      return Text(
                        DateFormatter.formatDateMDY(
                              DateTime.tryParse(state ?? ''),
                            ) ??
                            context.tr.issueDate,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18.r,
                    color: context.customColor.text1,
                  ),
                ],
              ),
            ),
          ),
          10.verticalSpace,
          BlocProvider(
            create: (context) => getIt<SwitchButtonCubit>(),
            child: GroupedInvoiceTaxWidget(
              invoiceId: widget.id,
              onDataChange:
                  (netAmount, supplierName, taxId, totalIncVat, vatAmount) =>
                      _validateTaxField(
                        context: context,
                        netAmount: netAmount,
                        supplierName: supplierName,
                        taxId: taxId,
                        totalIncVat: totalIncVat,
                        vatAmount: vatAmount,
                      ),
            ),
          ),
          10.verticalSpace,
          LabelTextField(text: context.tr.uploadInvoiceReceipt),
          8.verticalSpace,
          const UploadExpenseInvoiceReceipt(),
          8.verticalSpace,
          widget.strategy.buildAttachmentsSection(
            context,
            widget.attachments,
            id: widget.id,
          ),
        ],
      ),
    );
  }
}
