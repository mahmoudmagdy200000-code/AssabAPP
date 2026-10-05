import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../data/models/supplier_model.dart';
import '../cubit/suppliers/suppliers_cubit.dart';
import '../widgets/supplier_list_bottom_sheet_widget.dart';
import 'grouped_invoices_payment_view.dart';

class GroupedInvoiceSessionSetupView extends StatefulWidget {
  final int initialPaymentIndex;

  const GroupedInvoiceSessionSetupView({
    super.key,
    this.initialPaymentIndex = 0,
  });

  @override
  State<GroupedInvoiceSessionSetupView> createState() =>
      _GroupedInvoiceSessionSetupViewState();
}

class _GroupedInvoiceSessionSetupViewState
    extends State<GroupedInvoiceSessionSetupView> {
  @override
  void initState() {
    _onPaymentTypeChange(context, widget.initialPaymentIndex);
    super.initState();
  }

  void _onPaymentTypeChange(BuildContext context, int index) {
    switch (index) {
      case 0:
        _validatePaymentTypeField(context, 'full');
        _addPaymentMethodField(context);
        _removeDueDateField(context);
      case 1:
        _validatePaymentTypeField(context, 'partial');
        _addPaymentMethodField(context);
        _removeDueDateField(context);
        break;
      case 2:
        _validatePaymentTypeField(context, 'deferred');
        _addDueDateField(context);
        _removePaymentFields(context);
        break;
      default:
    }
  }

  void _validatePaymentTypeField(BuildContext context, String value) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'paymentType',
      value: value,
      isValid: true,
    );
  }

  void _addPaymentMethodField(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({'paymentMethod'});
  }

  void _addDueDateField(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({'dueDate'});
  }

  void _removePaymentFields(BuildContext context) {
    context.read<ValidationCubit>().removeDynamicFields({'paymentMethod'});
  }

  void _removeDueDateField(BuildContext context) {
    context.read<ValidationCubit>().removeDynamicFields({'dueDate'});
  }

  void _openSupplierListBottomSheet(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final suppliersCubit = context.read<SuppliersCubit>();

    AppBottomSheet.show(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: validationCubit),
          BlocProvider.value(value: suppliersCubit),
          BlocProvider(create: (context) => SearchCubit<SupplierModel>()),
        ],
        child: SupplierListBottomSheetWidget(
          onSelected: (supplier) {
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'supplierName',
              value: supplier.name,
              isValid: true,
            );
            context.read<ValidationCubit>().validateFieldAndStoreValue(
              fieldName: 'supplierId',
              value: supplier.id.toString(),
              isValid: true,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LabelTextField(text: context.tr.defaultSupplier),
          Text(
            context.tr.defaultSupplierDesc,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          8.verticalSpace,
          AppGestureDetectorButton(
            onTap: () => _openSupplierListBottomSheet(context),
            child: ContainerCustomTextField(
              child: Row(
                children: [
                  Expanded(
                    child:
                        BlocSelector<ValidationCubit, ValidationState, String?>(
                          selector: (state) =>
                              state.fieldsValue['supplierName'],
                          builder: (context, state) {
                            return Text(
                              state ?? context.tr.choose,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            );
                          },
                        ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 16.r,
                    color: context.customColor.text1,
                  ),
                ],
              ),
            ),
          ),
          12.verticalSpace,
          const CustomDivider(),
          12.verticalSpace,
          BlocProvider(
            create: (context) => PagingCubit(
              totalSteps: 3,
              initialIndex: widget.initialPaymentIndex,
            ),
            child: GroupedInvoicesPaymentView(
              whenPaymentTypeChange: (value) =>
                  _onPaymentTypeChange(context, value),
            ),
          ),
        ],
      ),
    );
  }
}
