import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/cubits/payment_method/payment_method_cubit.dart';
import 'package:assab/core/cubits/switch_button/switch_button_cubit.dart';
import 'package:assab/core/enums/payment_method.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:assab/features/branch_manager_expenses/data/models/single_invoice_update_draft_request.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/helpers/payment_method_validator.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/file_preview_widget.dart';
import '../../../../core/widgets/list_view_files_preview.dart';
import '../../data/models/attachment_model.dart';
import '../../data/models/create_single_invoice_request_model.dart';
import '../../presentation/cubit/single_expense/single_expense_cubit.dart';
import '../../presentation/widgets/expenses_empty_widget.dart';
import '../entities/single_invoice_entity.dart';

abstract class SingleInvoiceDraftStrategy {
  void getDetails(BuildContext context, String? id) {}

  void addInitPurchaseItem(BuildContext context) {}

  void addInitExpenseItem(BuildContext context) {}

  Widget buildAttachmentsSection(
    BuildContext context,
    List<AttachmentModel> attachments,
  );

  Widget buildEmptyWidget(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildSummaryAttachmentSection(
    BuildContext context,
    List<AttachmentModel> apiAttachments,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildReusePastRequest(BuildContext context, VoidCallback onClick) {
    return const SizedBox.shrink();
  }

  void dispose() {}

  void validateAll(
    BuildContext context,
    SingleInvoiceEntity singleInvoiceEntity,
  ) {}

  void submit(
    BuildContext context, {
    required String id,
    required List<PaymentMethodValidator> paymentMethodValidators,
    required ValueNotifier<int> currentIndexPaymentNotifier,
  });

  void saveDraft(
    BuildContext context, {
    required String id,
    required List<PaymentMethodValidator> paymentMethodValidators,
    required ValueNotifier<int> currentIndexPaymentNotifier,
  });
}

class AddNewSingleInvoiceStrategy extends SingleInvoiceDraftStrategy {
  @override
  Widget buildAttachmentsSection(
    BuildContext context,
    List<AttachmentModel> attachments,
  ) {
    return ListViewFilesPreview(mediaCubit: context.read<MediaCubit>());
  }

  @override
  void addInitPurchaseItem(BuildContext context) {
    super.addInitPurchaseItem(context);
    context.read<AddItemCubit>().addItem('purchases');
  }

  @override
  void addInitExpenseItem(BuildContext context) {
    super.addInitExpenseItem(context);
    context.read<AddItemCubit>().addItem('expenses');
  }

  @override
  Widget buildSummaryAttachmentSection(
    BuildContext context,
    List<AttachmentModel> apiAttachments,
  ) {
    return BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
      selector: (state) {
        if (state is MediaLoaded) {
          final files = state.allFiles.where((f) => f.selected).toList();

          context.read<ValidationCubit>().validateField(
            'photos',
            files.isNotEmpty,
          );

          return files;
        }

        return const [];
      },
      builder: (context, allFiles) {
        return ListView.builder(
          itemCount: allFiles.length,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return FilePreviewWidget(
              file: allFiles[index],
              icon: AppAssets.eye,
              onTapIcon: () =>
                  context.read<MediaCubit>().removeFile(allFiles[index]),
            );
          },
        );
      },
    );
  }

  void _createSingleInvoiceExpense(
    BuildContext context,
    CreateSingleInvoiceRequestModel createSingleInvoiceRequestModel,
  ) {
    context.read<SingleExpenseCubit>().createSingleExpense(
      model: createSingleInvoiceRequestModel,
    );
  }

  String _getField(ValidationCubit validationCubit, String key) {
    return validationCubit.state.fieldsValue[key]?.toString() ?? '';
  }

  List<ItemSingleInvoiceModel> _buildItemList(
    ValidationCubit validationCubit,
    List items,
  ) {
    return items.map((id) {
      return ItemSingleInvoiceModel(
        categoryId: _getField(validationCubit, 'itemPurchasedId_$id'),
        name: _getField(validationCubit, 'itemPurchasedName_$id'),
        quantity: _getField(validationCubit, 'purchaseQty_$id'),
        unitPrice: _getField(validationCubit, 'purchaseUnitPrice_$id'),
      );
    }).toList();
  }

  List<ExpenseSingleInvoiceModel> _buildExpenseList(
    ValidationCubit validationCubit,
    List expenses,
  ) {
    return expenses.map((id) {
      return ExpenseSingleInvoiceModel(
        categoryId: _getField(validationCubit, 'expenseItemId_$id'),
        name: _getField(validationCubit, 'expenseItemName_$id'),
        price: _getField(validationCubit, 'expenseUnitPrice_$id'),
      );
    }).toList();
  }

  double _calculateTotalAmount(
    ValidationCubit validationCubit,
    List items,
    List expenses,
  ) {
    double total = 0;

    for (final id in items) {
      final qty =
          double.tryParse(_getField(validationCubit, 'purchaseQty_$id')) ?? 0;
      final unit =
          double.tryParse(
            _getField(validationCubit, 'purchaseUnitPrice_$id'),
          ) ??
          0;
      total += qty * unit;
    }

    for (final id in expenses) {
      final price =
          double.tryParse(_getField(validationCubit, 'expenseUnitPrice_$id')) ??
          0;
      total += price;
    }

    return total;
  }

  CreateSingleInvoiceRequestModel _createSingleInvoiceRequestModel({
    required BuildContext context,
    required bool isDraft,
    required List<PaymentMethodValidator> paymentMethodValidators,
    required ValueNotifier<int> currentIndexPaymentNotifier,
  }) {
    final validationCubit = context.read<ValidationCubit>();
    final addItemCubit = context.read<AddItemCubit>();
    final switchCubit = context.read<SwitchButtonCubit>();
    final mediaCubit = context.read<MediaCubit>();

    final supplierId = _getField(validationCubit, 'supplierId');
    final invoiceNumber = _getField(validationCubit, 'invoiceNum');
    final issueDate = _getField(validationCubit, 'issueDate');
    final taxId = _getField(validationCubit, 'taxId');
    final isTaxInvoice = switchCubit.state;

    final items = addItemCubit.state.lists['purchases'] ?? [];
    final expenses = addItemCubit.state.lists['expenses'] ?? [];

    final listItems = _buildItemList(validationCubit, items);
    final listExpenses = _buildExpenseList(validationCubit, expenses);

    final totalAmount = _calculateTotalAmount(validationCubit, items, expenses);

    final paymentType =
        paymentMethodValidators[currentIndexPaymentNotifier.value].paymentType;
    final paymentMethod = _getField(validationCubit, 'singlePaymentMethod');
    final paymentSupplierId = _getField(validationCubit, 'paymentSupplierId');
    final partialPaidAmount = _getField(validationCubit, 'partialPaidAmount');
    final dueDate = _getField(validationCubit, 'singleDueDate');
    final invoiceReceipt = mediaCubit.allFilesSelected
        .map((e) => e.toFile)
        .toList();

    final vatSupplierName = _getField(validationCubit, 'taxSupplierName');
    final netAmount = _getField(validationCubit, 'netAmount');
    final vatAmount = _getField(validationCubit, 'vatAmount');
    final totalIncVat = _getField(validationCubit, 'totalIncVat');

    return CreateSingleInvoiceRequestModel(
      supplierId: supplierId,
      invoiceNumber: invoiceNumber,
      issueDate: issueDate,
      isTaxInvoice: isTaxInvoice,
      totalAmount: totalAmount.toStringAsFixed(2),
      taxId: taxId,
      items: listItems,
      expenses: listExpenses,
      paymentType: paymentType,
      paymentMethod: paymentMethod,
      paymentSupplierId: paymentSupplierId,
      paidAmount: partialPaidAmount,
      dueDate: dueDate,
      invoiceReceipt: invoiceReceipt,
      vatSupplierName: vatSupplierName,
      netAmount: netAmount,
      vatAmount: vatAmount,
      vatTotalAmount: totalIncVat,
      isDraft: isDraft,
    );
  }

  @override
  void submit(
    BuildContext context, {
    required String id,
    required List<PaymentMethodValidator> paymentMethodValidators,
    required ValueNotifier<int> currentIndexPaymentNotifier,
  }) {
    _createSingleInvoiceExpense(
      context,
      _createSingleInvoiceRequestModel(
        isDraft: false,
        context: context,
        currentIndexPaymentNotifier: currentIndexPaymentNotifier,
        paymentMethodValidators: paymentMethodValidators,
      ),
    );
  }

  @override
  void saveDraft(
    BuildContext context, {
    required String id,
    required List<PaymentMethodValidator> paymentMethodValidators,
    required ValueNotifier<int> currentIndexPaymentNotifier,
  }) {
    _createSingleInvoiceExpense(
      context,
      _createSingleInvoiceRequestModel(
        isDraft: true,
        context: context,
        currentIndexPaymentNotifier: currentIndexPaymentNotifier,
        paymentMethodValidators: paymentMethodValidators,
      ),
    );
  }

  @override
  Widget buildReusePastRequest(BuildContext context, VoidCallback onClick) {
    return CustomTextButton(
      text: context.tr.reusePastRequest,
      borderColor: context.theme.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 8.r),
      onTap: onClick,
    );
  }
}

class EditDraftSingleInvoiceStrategy extends SingleInvoiceDraftStrategy {
  @override
  void getDetails(BuildContext context, String? id) {
    super.getDetails(context, id);
    context.read<ExpenseDetailsCubit>().getSingleInvoiceExpensesDetails(
      id: id ?? 'ss',
    );
  }

  @override
  Widget buildEmptyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExpensesEmptyWidget(
          icon: AppAssets.expensesEmptyPNG,
          title: context.tr.noExpensesYet,
          desc: context.tr.noExpensesYetDesc,
        ),
      ],
    );
  }

  final ValueNotifier<Set<String>> deletedAttachmentsNotifier =
      ValueNotifier<Set<String>>(<String>{});

  Set<String> get deletedAttachments => deletedAttachmentsNotifier.value;

  void _markAttachmentAsDeleted(String attachmentId) {
    final newSet = Set<String>.from(deletedAttachmentsNotifier.value);
    newSet.add(attachmentId);
    deletedAttachmentsNotifier.value = newSet;
    AppLogger.log('Marked attachment $attachmentId as deleted');
  }

  void _unmarkAttachmentAsDeleted(String attachmentId) {
    final newSet = Set<String>.from(deletedAttachmentsNotifier.value);
    newSet.remove(attachmentId);
    deletedAttachmentsNotifier.value = newSet;
    AppLogger.log('Unmarked attachment $attachmentId as deleted');
  }

  void _recalculatePhotosValidation(
    BuildContext context,
    List<AttachmentModel> attachments,
  ) {
    final validationCubit = context.read<ValidationCubit>();

    final hasOldPhotos = attachments.length != deletedAttachments.length;
    final hasNewPhotos = context.read<MediaCubit>().allFilesSelected.isNotEmpty;

    validationCubit.validateField('photos', hasOldPhotos || hasNewPhotos);
  }

  @override
  Widget buildAttachmentsSection(
    BuildContext context,
    List<AttachmentModel> attachments,
  ) {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: deletedAttachmentsNotifier,
            builder: (context, deletedSet, _) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attachments.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final attachment = attachments[index];
                  final isDeleted = deletedSet.contains(attachment.id);

                  return NetworkFilePreviewWidget(
                    attachmentModel: attachment,
                    delete: !isDeleted,
                    onDelete: () {
                      _markAttachmentAsDeleted(attachment.id);
                      _recalculatePhotosValidation(context, attachments);
                    },
                    restore: isDeleted,
                    onRestore: () {
                      _unmarkAttachmentAsDeleted(attachment.id);
                      _recalculatePhotosValidation(context, attachments);
                    },
                  );
                },
              );
            },
          ),
          BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
            selector: (state) {
              if (state is MediaLoaded) {
                final files = state.allFiles.where((f) => f.selected).toList();

                _recalculatePhotosValidation(context, attachments);

                return files;
              }

              return const [];
            },
            builder: (context, allFiles) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allFiles.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => FilePreviewWidget(
                  file: allFiles[index],
                  icon: AppAssets.trashSvg,
                  onTapIcon: () {
                    context.read<MediaCubit>().removeFile(allFiles[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _validate({
    required ValidationCubit validationCubit,
    required String fieldName,
    required String value,
    required bool isValid,
  }) {
    validationCubit.validateFieldAndStoreValue(
      fieldName: fieldName,
      value: value,
      isValid: isValid,
    );
  }

  void _setAndValidateSupplier(
    BuildContext context,
    SingleInvoiceEntity singleInvoiceEntity,
    ValidationCubit validationCubit,
  ) {
    context.read<SuppliersCubit>().selectSupplier(
      singleInvoiceEntity.supplierId,
      singleInvoiceEntity.supplierName,
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'supplierName',
      value: singleInvoiceEntity.supplierName,
      isValid: true,
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'supplierId',
      value: singleInvoiceEntity.supplierId,
      isValid: true,
    );
  }

  void _validateTaxFields({
    required ValidationCubit validationCubit,
    required SingleInvoiceEntity singleInvoiceEntity,
  }) {
    _validate(
      validationCubit: validationCubit,
      fieldName: 'taxId',
      value: singleInvoiceEntity.taxId,
      isValid: true,
    );
    _validate(
      validationCubit: validationCubit,
      fieldName: 'taxSupplierName',
      value: singleInvoiceEntity.taxSupplierName,
      isValid: true,
    );
    _validate(
      validationCubit: validationCubit,
      fieldName: 'netAmount',
      value: singleInvoiceEntity.netAmount,
      isValid: true,
    );
    _validate(
      validationCubit: validationCubit,
      fieldName: 'vatAmount',
      value: singleInvoiceEntity.vatAmount,
      isValid: true,
    );
    final netAmountNum = double.tryParse(singleInvoiceEntity.netAmount) ?? 0;
    final vatAmountNum = double.tryParse(singleInvoiceEntity.vatAmount) ?? 0;
    _validate(
      validationCubit: validationCubit,
      fieldName: 'totalIncVat',
      value: (netAmountNum + vatAmountNum).toStringAsFixed(2),
      isValid: true,
    );
  }

  void _setAndValidatePurchaseItems(
    BuildContext context,
    SingleInvoiceEntity singleInvoiceEntity,
    ValidationCubit validationCubit,
    AddItemCubit addItemCubit,
  ) {
    for (int i = 0; i < singleInvoiceEntity.items.length; i++) {
      addItemCubit.addItem('purchases');
    }

    final dynamicFields =
        addItemCubit.state.lists['purchases']
            ?.expand(
              (id) => {
                'itemPurchasedId_$id',
                'itemPurchasedName_$id',
                'purchaseQty_$id',
                'purchaseUnitPrice_$id',
              },
            )
            .toSet() ??
        <String>{};

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (key) =>
              key.startsWith('itemPurchasedId_') ||
              key.startsWith('itemPurchasedName_') ||
              key.startsWith('purchaseQty_') ||
              key.startsWith('purchaseUnitPrice_'),
        )
        .toSet();

    final toRemove = existingDynamic.difference(dynamicFields);
    final toAdd = dynamicFields.difference(existingDynamic);

    if (toRemove.isNotEmpty) {
      validationCubit.removeDynamicFields(toRemove);
    }

    if (toAdd.isNotEmpty) {
      validationCubit.addDynamicFields(toAdd);
    }

    final expenseItemsIds = addItemCubit.state.lists['purchases'] ?? [];

    for (int i = 0; i < expenseItemsIds.length; i++) {
      if (i > singleInvoiceEntity.items.length - 1) {
        break;
      }

      final item = singleInvoiceEntity.items[i];
      final id = item.categoryId;
      final title = item.name;
      final quantity = item.quantity;
      final unitPrice = item.unitPrice;

      validationCubit
        ..validateFieldAndStoreValue(
          fieldName: 'itemPurchasedId_${expenseItemsIds[i]}',
          value: id.toString(),
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'itemPurchasedName_${expenseItemsIds[i]}',
          value: title.toString(),
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'purchaseQty_${expenseItemsIds[i]}',
          value: quantity.toString(),
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'purchaseUnitPrice_${expenseItemsIds[i]}',
          value: unitPrice.toString(),
          isValid: true,
        );
    }
  }

  void _setAndValidateExpenseItems(
    BuildContext context,
    SingleInvoiceEntity singleInvoiceEntity,
    ValidationCubit validationCubit,
    AddItemCubit addItemCubit,
  ) {
    for (int i = 0; i < singleInvoiceEntity.expenses.length; i++) {
      addItemCubit.addItem('expenses');
    }

    final dynamicFields =
        addItemCubit.state.lists['expenses']
            ?.expand(
              (id) => {
                'expenseItemId_$id',
                'expenseItemName_$id',
                'expenseUnitPrice_$id',
              },
            )
            .toSet() ??
        <String>{};

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (key) =>
              key.startsWith('expenseItemId_') ||
              key.startsWith('expenseItemName_') ||
              key.startsWith('expenseUnitPrice_'),
        )
        .toSet();

    final toRemove = existingDynamic.difference(dynamicFields);
    final toAdd = dynamicFields.difference(existingDynamic);

    if (toRemove.isNotEmpty) {
      validationCubit.removeDynamicFields(toRemove);
    }

    if (toAdd.isNotEmpty) {
      validationCubit.addDynamicFields(toAdd);
    }

    final expenseItemsIds = addItemCubit.state.lists['expenses'] ?? [];

    for (int i = 0; i < expenseItemsIds.length; i++) {
      if (i > singleInvoiceEntity.expenses.length - 1) {
        break;
      }

      final item = singleInvoiceEntity.expenses[i];
      final id = item.categoryId;
      final name = item.name;
      final price = item.price;

      validationCubit
        ..validateFieldAndStoreValue(
          fieldName: 'expenseItemId_${expenseItemsIds[i]}',
          value: id.toString(),
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'expenseItemName_${expenseItemsIds[i]}',
          value: name.toString(),
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'expenseUnitPrice_${expenseItemsIds[i]}',
          value: price.toString(),
          isValid: true,
        );
    }
  }

  @override
  void validateAll(
    BuildContext context,
    SingleInvoiceEntity singleInvoiceEntity,
  ) {
    super.validateAll(context, singleInvoiceEntity);

    final validationCubit = context.read<ValidationCubit>();

    final addItemCubit = context.read<AddItemCubit>();

    _setAndValidatePurchaseItems(
      context,
      singleInvoiceEntity,
      validationCubit,
      addItemCubit,
    );

    _setAndValidateExpenseItems(
      context,
      singleInvoiceEntity,
      validationCubit,
      addItemCubit,
    );

    _setAndValidateSupplier(context, singleInvoiceEntity, validationCubit);

    _validate(
      validationCubit: validationCubit,
      fieldName: 'invoiceNum',
      value: singleInvoiceEntity.invoiceNumber,
      isValid: true,
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'issueDate',
      value: singleInvoiceEntity.issueDate,
      isValid: true,
    );

    if (singleInvoiceEntity.isTaxInvoice) {
      context.read<SwitchButtonCubit>().toggle();
      _validateTaxFields(
        validationCubit: validationCubit,
        singleInvoiceEntity: singleInvoiceEntity,
      );
    }

    if (singleInvoiceEntity.paymentType != 'N/A') {
      _validate(
        validationCubit: validationCubit,
        fieldName: 'singlePaymentType',
        value: singleInvoiceEntity.paymentType,
        isValid: true,
      );
    }

    if (singleInvoiceEntity.paymentMethod != 'N/A') {
      final paymentMethod = singleInvoiceEntity.paymentMethod.toPaymentMethod();
      final paymentMethodCubit = context.read<PaymentMethodCubit>();
      paymentMethodCubit.selectMethod(paymentMethod);

      _validate(
        validationCubit: validationCubit,
        fieldName: 'singlePaymentMethod',
        value: singleInvoiceEntity.paymentMethod,
        isValid: true,
      );

      if (paymentMethod == PaymentMethod.supplier &&
          singleInvoiceEntity.paymentSupplier != null) {
        paymentMethodCubit.selectSupplier(singleInvoiceEntity.paymentSupplier!);
      }
    }

    if (singleInvoiceEntity.paymentSupplierId != 'N/A') {
      _validate(
        validationCubit: validationCubit,
        fieldName: 'paymentSupplierId',
        value: singleInvoiceEntity.paymentSupplierId,
        isValid: true,
      );
    }

    if (singleInvoiceEntity.totalAmountPaid != 'N/A') {
      _validate(
        validationCubit: validationCubit,
        fieldName: 'partialPaidAmount',
        value: singleInvoiceEntity.totalAmountPaid,
        isValid: true,
      );
    }

    if (singleInvoiceEntity.paymentType == 'partial' &&
        singleInvoiceEntity.totalAmount != 'N/A') {
      _validate(
        validationCubit: validationCubit,
        fieldName: 'partialTotalInvoiceAmount',
        value: singleInvoiceEntity.totalAmount,
        isValid: true,
      );
    }

    if (singleInvoiceEntity.paymentType == 'deferred' &&
        singleInvoiceEntity.totalAmount != 'N/A') {
      _validate(
        validationCubit: validationCubit,
        fieldName: 'deferredTotalInvoiceAmount',
        value: singleInvoiceEntity.totalAmount,
        isValid: true,
      );
    }

    if (singleInvoiceEntity.dueDate != 'N/A') {
      _validate(
        validationCubit: validationCubit,
        fieldName: 'singleDueDate',
        value: singleInvoiceEntity.dueDate,
        isValid: true,
      );
    }

    _recalculatePhotosValidation(context, singleInvoiceEntity.attachments);
  }

  @override
  Widget buildSummaryAttachmentSection(
    BuildContext context,
    List<AttachmentModel> apiAttachments,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (apiAttachments.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: apiAttachments.length - deletedAttachments.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final attachment = apiAttachments
                  .where((element) => !deletedAttachments.contains(element.id))
                  .toList()[index];

              return NetworkFilePreviewWidget(attachmentModel: attachment);
            },
          ),
        BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
          selector: (state) {
            if (state is MediaLoaded) {
              return state.allFiles.where((f) => f.selected).toList();
            }

            return const [];
          },
          builder: (context, allFiles) {
            if (allFiles.isEmpty) {
              return const SizedBox.shrink();
            }

            return ListView.builder(
              itemCount: allFiles.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return FilePreviewWidget(
                  file: allFiles[index],
                  icon: AppAssets.eye,
                  onTapIcon: () =>
                      context.read<MediaCubit>().removeFile(allFiles[index]),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _updateDraftSingleInvoiceExpense(
    BuildContext context,
    SingleInvoiceUpdateDraftRequest singleInvoiceUpdateDraftRequest,
    String id,
  ) {
    context.read<SingleExpenseCubit>().updateDraftSingleExpense(
      id: id,
      model: singleInvoiceUpdateDraftRequest,
      attachments: context
          .read<MediaCubit>()
          .allFilesSelected
          .map((e) => e.toFile)
          .toList(),
    );
  }

  String _getField(ValidationCubit validationCubit, String key) {
    return validationCubit.state.fieldsValue[key]?.toString() ?? '';
  }

  List<SingleInvoiceUpdateDraftRequestItem> _buildItemList(
    ValidationCubit validationCubit,
    List items,
  ) {
    return items.map((id) {
      return SingleInvoiceUpdateDraftRequestItem(
        categoryId: _getField(validationCubit, 'itemPurchasedId_$id'),
        name: _getField(validationCubit, 'itemPurchasedName_$id'),
        quantity:
            double.tryParse(_getField(validationCubit, 'purchaseQty_$id')) ?? 0,
        unitPrice:
            double.tryParse(
              _getField(validationCubit, 'purchaseUnitPrice_$id'),
            ) ??
            0,
      );
    }).toList();
  }

  List<SingleInvoiceUpdateDraftRequestExpense> _buildExpenseList(
    ValidationCubit validationCubit,
    List expenses,
  ) {
    return expenses.map((id) {
      return SingleInvoiceUpdateDraftRequestExpense(
        categoryId: _getField(validationCubit, 'expenseItemId_$id'),
        name: _getField(validationCubit, 'expenseItemName_$id'),
        price:
            double.tryParse(
              _getField(validationCubit, 'expenseUnitPrice_$id'),
            ) ??
            0,
      );
    }).toList();
  }

  SingleInvoiceUpdateDraftRequest _singleInvoiceUpdateDraftRequest({
    required BuildContext context,
    required bool isDraft,
    required List<PaymentMethodValidator> paymentMethodValidators,
    required ValueNotifier<int> currentIndexPaymentNotifier,
  }) {
    final validationCubit = context.read<ValidationCubit>();
    final addItemCubit = context.read<AddItemCubit>();
    final switchCubit = context.read<SwitchButtonCubit>();

    final supplierId = _getField(validationCubit, 'supplierId');
    final invoiceNumber = _getField(validationCubit, 'invoiceNum');
    final issueDate = _getField(validationCubit, 'issueDate');
    final taxId = _getField(validationCubit, 'taxId');
    final isTaxInvoice = switchCubit.state;

    final items = addItemCubit.state.lists['purchases'] ?? [];
    final expenses = addItemCubit.state.lists['expenses'] ?? [];

    final listItems = _buildItemList(validationCubit, items);
    final listExpenses = _buildExpenseList(validationCubit, expenses);

    final paymentType =
        paymentMethodValidators[currentIndexPaymentNotifier.value].paymentType;
    final paymentMethod = _getField(validationCubit, 'singlePaymentMethod');
    final paymentSupplierId = _getField(validationCubit, 'paymentSupplierId');
    final partialPaidAmount = _getField(validationCubit, 'partialPaidAmount');
    final dueDate = _getField(validationCubit, 'singleDueDate');

    final vatSupplierName = _getField(validationCubit, 'taxSupplierName');
    final netAmount = _getField(validationCubit, 'netAmount');
    final vatAmount = _getField(validationCubit, 'vatAmount');
    final totalIncVat = _getField(validationCubit, 'totalIncVat');

    final taxInvoiceDetails = SingleInvoiceUpdateDraftRequestTaxInvoiceDetails(
      supplierName: vatSupplierName,
      netAmount: double.tryParse(netAmount) ?? 0,
      vatAmount: double.tryParse(vatAmount) ?? 0,
      totalAmount: double.tryParse(totalIncVat) ?? 0,
    );

    return SingleInvoiceUpdateDraftRequest(
      supplierId: supplierId,
      invoiceNumber: invoiceNumber,
      issueDate: issueDate,
      isTaxInvoice: isTaxInvoice,
      taxId: taxId,
      items: listItems,
      expenses: listExpenses,
      paymentType: paymentType,
      paymentMethod: paymentMethod,
      paymentSupplierId: paymentSupplierId,
      paidAmount: double.tryParse(partialPaidAmount) ?? 0,
      dueDate: dueDate,
      isDraft: isDraft,
      deleteAttachments: deletedAttachments.toList(),
      taxInvoiceDetails: taxInvoiceDetails,
    );
  }

  @override
  void submit(
    BuildContext context, {
    required String id,
    required List<PaymentMethodValidator> paymentMethodValidators,
    required ValueNotifier<int> currentIndexPaymentNotifier,
  }) {
    _updateDraftSingleInvoiceExpense(
      context,
      _singleInvoiceUpdateDraftRequest(
        isDraft: false,
        context: context,
        currentIndexPaymentNotifier: currentIndexPaymentNotifier,
        paymentMethodValidators: paymentMethodValidators,
      ),
      id,
    );
  }

  @override
  void saveDraft(
    BuildContext context, {
    required String id,
    required List<PaymentMethodValidator> paymentMethodValidators,
    required ValueNotifier<int> currentIndexPaymentNotifier,
  }) {
    _updateDraftSingleInvoiceExpense(
      context,
      _singleInvoiceUpdateDraftRequest(
        isDraft: true,
        context: context,
        currentIndexPaymentNotifier: currentIndexPaymentNotifier,
        paymentMethodValidators: paymentMethodValidators,
      ),
      id,
    );
  }

  @override
  void dispose() {
    deletedAttachmentsNotifier.dispose();
    super.dispose();
  }
}
