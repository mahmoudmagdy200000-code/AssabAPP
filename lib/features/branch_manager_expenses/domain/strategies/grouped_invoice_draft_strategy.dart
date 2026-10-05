import 'dart:io';

import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/cubits/payment_method/payment_method_cubit.dart';
import 'package:assab/core/enums/payment_method.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/file_preview_widget.dart';
import '../../data/models/attachment_model.dart';
import '../../data/models/create_grouped_invoice_request_model.dart';
import '../../data/models/grouped_invoice_update_draft_request.dart';
import '../../presentation/cubit/grouped_invoice/grouped_invoice_cubit.dart';
import '../../presentation/cubit/suppliers/suppliers_cubit.dart';
import '../../presentation/widgets/expenses_empty_widget.dart';
import '../../presentation/widgets/grouped_invoice_attachments.dart';
import '../entities/grouped_invoice_entity.dart';

abstract class GroupedInvoiceDraftStrategy {
  void getDetails(BuildContext context, String? id) {}

  void addInitInvoice(BuildContext context) {}

  Widget buildAttachmentsSection(
    BuildContext context,
    List<AttachmentModel> attachments, {
    required String id,
  });

  Widget buildEmptyWidget(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildSummaryAttachmentSection(
    BuildContext context,
    List<AttachmentModel> apiAttachments, {
    required String id,
    required MediaCubit mediaCubit,
  }) {
    return const SizedBox.shrink();
  }

  void dispose() {}

  void validateAll(
    BuildContext context,
    GroupedInvoiceEntity groupedInvoiceEntity,
  ) {}

  void submit(
    BuildContext context, {
    required String id,
    required Map<String, MediaCubit> mediaCubits,
  });

  void saveDraft(
    BuildContext context, {
    required String id,
    required Map<String, MediaCubit> mediaCubits,
  });
}

class AddNewGroupedInvoiceDraftStrategy extends GroupedInvoiceDraftStrategy {
  @override
  Widget buildAttachmentsSection(
    BuildContext context,
    List<AttachmentModel> attachments, {
    required String id,
  }) {
    return GroupedInvoiceAttachments(id: id);
  }

  @override
  void addInitInvoice(BuildContext context) {
    super.addInitInvoice(context);
    context.read<AddItemCubit>().addItem('invoiceGroup');
  }

  @override
  Widget buildSummaryAttachmentSection(
    BuildContext context,
    List<AttachmentModel> apiAttachments, {
    required String id,
    required MediaCubit mediaCubit,
  }) {
    return BlocProvider.value(
      value: mediaCubit,
      child: GroupedInvoiceAttachments(id: id),
    );
  }

  void _createGroupedInvoiceExpense({
    required BuildContext context,
    required GroupedInvoiceRequestModel model,
  }) {
    context.read<GroupedInvoiceCubit>().createGroupedInvoiceExpense(
      model: model,
    );
  }

  String _getField(ValidationCubit validationCubit, String key) {
    return validationCubit.state.fieldsValue[key]?.toString() ?? '';
  }

  GroupedInvoiceRequestModel _collectGroupedInvoiceData({
    required BuildContext context,
    required Map<String, MediaCubit> mediaCubits,
    required bool isDraft,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    final supplierId = _getField(validationCubit, 'supplierId');
    final paymentType = _getField(validationCubit, 'paymentType');
    final paymentMethod = _getField(validationCubit, 'paymentMethod');
    final paymentSupplierId = _getField(validationCubit, 'paymentSupplierId');
    final dueDate = _getField(validationCubit, 'dueDate');

    final addItemCubit = context.read<AddItemCubit>();
    final invoiceGroupIds =
        addItemCubit.state.lists['invoiceGroup'] ?? <String>[];

    final invoices = <GroupedInvoiceInvoiceModel>[];

    for (final id in invoiceGroupIds) {
      final mediaCubit = mediaCubits[id];

      final attachments =
          mediaCubit?.allFilesSelected.map((e) => e.toFile).toList() ?? [];

      final invoiceSupplierId = _getField(validationCubit, 'supplierId_$id');
      final invoiceNumber = _getField(validationCubit, 'invoiceNumber_$id');
      final issueDate = _getField(validationCubit, 'issueDate_$id');
      final taxId = _getField(validationCubit, 'taxId_$id');
      final taxSupplierName = _getField(validationCubit, 'taxSupplierName_$id');
      final netAmount = _getField(validationCubit, 'netAmount_$id');
      final vatAmount = _getField(validationCubit, 'vatAmount_$id');
      final totalIncVat = _getField(validationCubit, 'totalIncVat_$id');
      final isTaxInvoice =
          taxId.isNotEmpty &&
          taxSupplierName.isNotEmpty &&
          netAmount.isNotEmpty &&
          vatAmount.isNotEmpty &&
          totalIncVat.isNotEmpty;

      final purchases = addItemCubit.state.lists['purchases_$id'] ?? <String>[];

      final items = purchases.map<GroupedInvoiceItemRequestModel>((purchaseId) {
        return GroupedInvoiceItemRequestModel(
          categoryId: _getField(
            validationCubit,
            'itemPurchasedId_${id}_$purchaseId',
          ),
          name: _getField(
            validationCubit,
            'itemPurchasedName_${id}_$purchaseId',
          ),
          quantity: _getField(validationCubit, 'purchaseQty_${id}_$purchaseId'),
          unitPrice: _getField(
            validationCubit,
            'purchaseUnitPrice_${id}_$purchaseId',
          ),
        );
      }).toList();

      invoices.add(
        GroupedInvoiceInvoiceModel(
          supplierId: invoiceSupplierId,
          invoiceNumber: invoiceNumber,
          issueDate: issueDate,
          isTaxInvoice: isTaxInvoice,
          taxId: taxId,
          items: items,
          netAmount: netAmount,
          supplierName: taxSupplierName,
          vatAmount: vatAmount,
          totalAmount: totalIncVat,
          invoiceReceipts: attachments,
        ),
      );
    }

    return GroupedInvoiceRequestModel(
      supplierId: supplierId,
      paymentType: paymentType,
      paymentMethod: paymentMethod,
      paymentSupplierId: paymentSupplierId,
      dueDate: dueDate,
      isDraft: isDraft,
      invoices: invoices,
    );
  }

  @override
  void submit(
    BuildContext context, {
    required String id,
    required Map<String, MediaCubit> mediaCubits,
  }) {
    final model = _collectGroupedInvoiceData(
      context: context,
      mediaCubits: mediaCubits,
      isDraft: false,
    );

    _createGroupedInvoiceExpense(context: context, model: model);
  }

  @override
  void saveDraft(
    BuildContext context, {
    required String id,
    required Map<String, MediaCubit> mediaCubits,
  }) {
    final model = _collectGroupedInvoiceData(
      context: context,
      mediaCubits: mediaCubits,
      isDraft: true,
    );

    _createGroupedInvoiceExpense(context: context, model: model);
  }
}

class EditDraftGroupedInvoiceDraftStrategy extends GroupedInvoiceDraftStrategy {
  @override
  void getDetails(BuildContext context, String? id) {
    super.getDetails(context, id);
    context.read<ExpenseDetailsCubit>().getGroupedInvoiceExpensesDetails(
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

  final ValueNotifier<Map<String, Set<String>>> deletedAttachmentsNotifier =
      ValueNotifier<Map<String, Set<String>>>({});

  Set<String> deletedAttachments(String invoiceId) {
    return deletedAttachmentsNotifier.value['deleted_$invoiceId'] ?? <String>{};
  }

  Set<String> get _getAllDeletedAttachments {
    final allDeleted = <String>{};

    for (final deletedSet in deletedAttachmentsNotifier.value.values) {
      allDeleted.addAll(deletedSet);
    }

    return allDeleted;
  }

  void _markAttachmentAsDeleted(String attachmentId, String invoiceId) {
    final newMap = Map<String, Set<String>>.from(
      deletedAttachmentsNotifier.value,
    );
    newMap
        .putIfAbsent('deleted_$invoiceId', () => <String>{})
        .add(attachmentId);
    deletedAttachmentsNotifier.value = newMap;
    AppLogger.log('Marked attachment $attachmentId as deleted_$invoiceId');
  }

  void _unmarkAttachmentAsDeleted(String attachmentId, String invoiceId) {
    final newMap = Map<String, Set<String>>.from(
      deletedAttachmentsNotifier.value,
    );
    newMap
        .putIfAbsent('deleted_$invoiceId', () => <String>{})
        .remove(attachmentId);
    deletedAttachmentsNotifier.value = newMap;
    AppLogger.log('Unmarked attachment $attachmentId as deleted_$invoiceId');
  }

  void _recalculatePhotosValidation(
    BuildContext context,
    List<AttachmentModel> attachments, {
    required String id,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    final hasOldPhotos = attachments.length != deletedAttachments(id).length;
    final hasNewPhotos = context.read<MediaCubit>().allFilesSelected.isNotEmpty;

    validationCubit.validateField('photos_$id', hasOldPhotos || hasNewPhotos);
  }

  @override
  Widget buildAttachmentsSection(
    BuildContext context,
    List<AttachmentModel> attachments, {
    required String id,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<Map<String, Set<String>>>(
          valueListenable: deletedAttachmentsNotifier,
          builder: (context, deletedMap, _) {
            final deletedSet = deletedMap['deleted_$id'] ?? <String>{};

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
                    _markAttachmentAsDeleted(attachment.id, id);
                    _recalculatePhotosValidation(context, attachments, id: id);
                  },
                  restore: isDeleted,
                  onRestore: () {
                    _unmarkAttachmentAsDeleted(attachment.id, id);
                    _recalculatePhotosValidation(context, attachments, id: id);
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

              _recalculatePhotosValidation(context, attachments, id: id);

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

  final apiInvoicesIds = <String, String>{};

  void _setAndValidateInvoices(
    BuildContext context,
    GroupedInvoiceEntity groupedInvoiceEntity,
    ValidationCubit validationCubit,
    AddItemCubit addItemCubit,
  ) {
    for (int i = 0; i < groupedInvoiceEntity.invoices.length; i++) {
      addItemCubit.addItem('invoiceGroup');
    }

    final dynamicFields =
        addItemCubit.state.lists['invoiceGroup']
            ?.expand(
              (id) => {
                'supplierId_$id',
                'supplierName_$id',
                'invoiceNumber_$id',
                'issueDate_$id',
                'photos_$id',
              },
            )
            .toSet() ??
        <String>{};

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (key) =>
              key.startsWith('supplierId_') ||
              key.startsWith('supplierName_') ||
              key.startsWith('invoiceNumber_') ||
              key.startsWith('issueDate_') ||
              key.startsWith('photos_'),
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

    final invoicesIds = addItemCubit.state.lists['invoiceGroup'] ?? [];

    for (int i = 0; i < invoicesIds.length; i++) {
      if (i > groupedInvoiceEntity.invoices.length - 1) {
        break;
      }

      final item = groupedInvoiceEntity.invoices[i];
      final invoiceId = invoicesIds[i];
      apiInvoicesIds[invoiceId] = item.id;

      validationCubit
        ..validateFieldAndStoreValue(
          fieldName: 'supplierId_$invoiceId',
          value: item.supplier.id,
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'supplierName_$invoiceId',
          value: item.supplier.name,
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'invoiceNumber_$invoiceId',
          value: item.invoiceNumber,
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'issueDate_$invoiceId',
          value: item.issuedDate,
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'vatAmount_$invoiceId',
          value: item.tax.vatAmount,
          isValid: item.tax.vatAmount != 'N/A',
        )
        ..validateFieldAndStoreValue(
          fieldName: 'totalIncVat_$invoiceId',
          value: item.tax.totalIncVat,
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'taxId_$invoiceId',
          value: item.tax.taxId,
          isValid: item.tax.taxId != 'N/A',
        )
        ..validateFieldAndStoreValue(
          fieldName: 'taxSupplierName_$invoiceId',
          value: item.tax.supplierName,
          isValid: item.tax.supplierName != 'N/A',
        )
        ..validateFieldAndStoreValue(
          fieldName: 'netAmount_$invoiceId',
          value: item.tax.netAmount,
          isValid: item.tax.netAmount != 'N/A',
        )
        ..validateField('photos_$invoiceId', item.attachments.isNotEmpty);

      _setAndValidatePurchaseItems(
        context,
        groupedInvoiceEntity,
        validationCubit,
        addItemCubit,
        i: i,
        invoicesIds: invoicesIds,
      );
    }
  }

  void _setAndValidatePurchaseItems(
    BuildContext context,
    GroupedInvoiceEntity groupedInvoiceEntity,
    ValidationCubit validationCubit,
    AddItemCubit addItemCubit, {
    required int i,
    required List<String> invoicesIds,
  }) {
    final item = groupedInvoiceEntity.invoices[i];

    final invoiceId = invoicesIds[i];

    for (
      int j = 0;
      j < groupedInvoiceEntity.invoices[i].purchases.length;
      j++
    ) {
      addItemCubit.addItem('purchases_$invoiceId');
    }

    final dynamicFields =
        addItemCubit.state.lists['purchases_$invoiceId']
            ?.expand(
              (purchaseId) => {
                'itemPurchasedId_${invoiceId}_$purchaseId',
                'itemPurchasedName_${invoiceId}_$purchaseId',
                'purchaseQty_${invoiceId}_$purchaseId',
                'purchaseUnitPrice_${invoiceId}_$purchaseId',
              },
            )
            .toSet() ??
        <String>{};

    final existingDynamic = validationCubit.state.fieldsValidity.keys
        .where(
          (key) =>
              key.startsWith('itemPurchasedId_${invoiceId}_') ||
              key.startsWith('itemPurchasedName_${invoiceId}_') ||
              key.startsWith('purchaseQty_${invoiceId}_') ||
              key.startsWith('purchaseUnitPrice_${invoiceId}_'),
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

    final purchasesIds = addItemCubit.state.lists['purchases_$invoiceId'] ?? [];

    for (int i = 0; i < purchasesIds.length; i++) {
      if (i > item.purchases.length - 1) {
        break;
      }

      final purchaseItem = item.purchases[i];
      final purchaseId = purchasesIds[i];

      validationCubit
        ..validateFieldAndStoreValue(
          fieldName: 'itemPurchasedId_${invoiceId}_$purchaseId',
          value: purchaseItem.categoryId,
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'itemPurchasedName_${invoiceId}_$purchaseId',
          value: purchaseItem.name,
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'purchaseQty_${invoiceId}_$purchaseId',
          value: purchaseItem.quantity,
          isValid: true,
        )
        ..validateFieldAndStoreValue(
          fieldName: 'purchaseUnitPrice_${invoiceId}_$purchaseId',
          value: purchaseItem.unitPrice,
          isValid: true,
        );
    }
  }

  @override
  void validateAll(
    BuildContext context,
    GroupedInvoiceEntity groupedInvoiceEntity,
  ) {
    super.validateAll(context, groupedInvoiceEntity);

    final validationCubit = context.read<ValidationCubit>();
    final addItemCubit = context.read<AddItemCubit>();

    _setAndValidateInvoices(
      context,
      groupedInvoiceEntity,
      validationCubit,
      addItemCubit,
    );

    final defaultSupplier = groupedInvoiceEntity.defaultSupplier;
    final defaultSupplierId = defaultSupplier.id.toString();
    final defaultSupplierName = defaultSupplier.name;

    context.read<SuppliersCubit>().selectSupplier(
      defaultSupplierId,
      defaultSupplierName,
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'supplierId',
      value: defaultSupplierId,
      isValid: defaultSupplierId != 'N/A' || defaultSupplierId.isNotEmpty,
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'supplierName',
      value: defaultSupplierName,
      isValid: defaultSupplierName != 'N/A' || defaultSupplierName.isNotEmpty,
    );

    // Restore payment type
    final paymentType = groupedInvoiceEntity.paymentType;
    if (paymentType != 'N/A') {
      _validate(
        validationCubit: validationCubit,
        fieldName: 'paymentType',
        value: paymentType,
        isValid: true,
      );
    }

    // Restore payment method and supplier
    final paymentMethodStr = groupedInvoiceEntity.paymentMethod;
    if (paymentMethodStr != 'N/A' && paymentMethodStr.isNotEmpty) {
      final paymentMethod = paymentMethodStr.toPaymentMethod();
      final paymentMethodCubit = context.read<PaymentMethodCubit>();
      paymentMethodCubit.selectMethod(paymentMethod);

      _validate(
        validationCubit: validationCubit,
        fieldName: 'paymentMethod',
        value: paymentMethodStr,
        isValid: true,
      );

      if (paymentMethod == PaymentMethod.supplier) {
        final supplier = groupedInvoiceEntity.paymentSupplier;
        paymentMethodCubit.selectSupplier(supplier);

        _validate(
          validationCubit: validationCubit,
          fieldName: 'paymentSupplierId',
          value: supplier.id.toString(),
          isValid: true,
        );
      }
    }

    // Restore due date (for deferred payment)
    final dueDate = groupedInvoiceEntity.dueDate;
    if (dueDate != 'N/A' && dueDate.isNotEmpty) {
      _validate(
        validationCubit: validationCubit,
        fieldName: 'dueDate',
        value: dueDate,
        isValid: true,
      );
    }
  }

  @override
  Widget buildSummaryAttachmentSection(
    BuildContext context,
    List<AttachmentModel> apiAttachments, {
    required String id,
    required MediaCubit mediaCubit,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (apiAttachments.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: apiAttachments.length - deletedAttachments(id).length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final attachment = apiAttachments
                  .where(
                    (element) => !deletedAttachments(id).contains(element.id),
                  )
                  .toList()[index];

              return NetworkFilePreviewWidget(attachmentModel: attachment);
            },
          ),
        BlocProvider.value(
          value: mediaCubit,
          child: BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
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
                    onTapIcon: () {},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _updateDraftGroupedInvoiceExpense({
    required BuildContext context,
    required GroupedInvoiceUpdateDraftRequest model,
    required String id,
    required List<Map<String, List<File>>> attachments,
  }) {
    context.read<GroupedInvoiceCubit>().updateDraftGroupedInvoiceExpense(
      model: model,
      id: id,
      attachments: attachments,
    );
  }

  String _getField(ValidationCubit validationCubit, String key) {
    return validationCubit.state.fieldsValue[key]?.toString() ?? '';
  }

  GroupedInvoiceUpdateDraftRequest _groupedInvoiceUpdateDraftRequest({
    required BuildContext context,
    required Map<String, MediaCubit> mediaCubits,
    required bool isDraft,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    final supplierId = _getField(validationCubit, 'supplierId');
    final paymentType = _getField(validationCubit, 'paymentType');
    final paymentMethod = _getField(validationCubit, 'paymentMethod');
    final paymentSupplierId = _getField(validationCubit, 'paymentSupplierId');
    final dueDate = _getField(validationCubit, 'dueDate');

    final addItemCubit = context.read<AddItemCubit>();

    final invoiceGroupIds =
        addItemCubit.state.lists['invoiceGroup'] ?? <String>[];

    final invoices = <GroupedInvoiceUpdateDraftRequestInvoice>[];

    for (final id in invoiceGroupIds) {
      final invoiceSupplierId = _getField(validationCubit, 'supplierId_$id');
      final invoiceNumber = _getField(validationCubit, 'invoiceNumber_$id');
      final issueDate = _getField(validationCubit, 'issueDate_$id');
      final taxId = _getField(validationCubit, 'taxId_$id');
      final taxSupplierName = _getField(validationCubit, 'taxSupplierName_$id');
      final netAmount = _getField(validationCubit, 'netAmount_$id');
      final vatAmount = _getField(validationCubit, 'vatAmount_$id');
      final totalIncVat = _getField(validationCubit, 'totalIncVat_$id');
      final isTaxInvoice =
          taxId.isNotEmpty &&
          taxSupplierName.isNotEmpty &&
          netAmount.isNotEmpty &&
          vatAmount.isNotEmpty &&
          totalIncVat.isNotEmpty;

      final purchases = addItemCubit.state.lists['purchases_$id'] ?? <String>[];

      final items = purchases.map<GroupedInvoiceUpdateDraftRequestItem>((
        purchaseId,
      ) {
        return GroupedInvoiceUpdateDraftRequestItem(
          categoryId: _getField(
            validationCubit,
            'itemPurchasedId_${id}_$purchaseId',
          ),
          name: _getField(
            validationCubit,
            'itemPurchasedName_${id}_$purchaseId',
          ),
          quantity:
              double.tryParse(
                _getField(validationCubit, 'purchaseQty_${id}_$purchaseId'),
              ) ??
              0,
          unitPrice:
              double.tryParse(
                _getField(
                  validationCubit,
                  'purchaseUnitPrice_${id}_$purchaseId',
                ),
              ) ??
              0,
        );
      }).toList();

      invoices.add(
        GroupedInvoiceUpdateDraftRequestInvoice(
          id: apiInvoicesIds[id] ?? '0',
          supplierId: invoiceSupplierId,
          invoiceNumber: invoiceNumber,
          issueDate: issueDate,
          isTaxInvoice: isTaxInvoice,
          taxId: taxId,
          items: items,
          deleteAttachments: deletedAttachments(id).toList(),
          taxInvoiceDetails: GroupedInvoiceUpdateDraftRequestTaxInvoiceDetails(
            netAmount: netAmount,
            supplierName: taxSupplierName,
            vatAmount: vatAmount,
            totalAmount: totalIncVat,
          ),
        ),
      );
    }

    return GroupedInvoiceUpdateDraftRequest(
      defaultSupplierId: supplierId,
      paymentType: paymentType,
      paymentMethod: paymentMethod,
      paymentSupplierId: paymentSupplierId,
      dueDate: dueDate,
      isDraft: isDraft,
      invoices: invoices,
    );
  }

  @override
  void submit(
    BuildContext context, {
    required String id,
    required Map<String, MediaCubit> mediaCubits,
  }) {
    final model = _groupedInvoiceUpdateDraftRequest(
      context: context,
      mediaCubits: mediaCubits,
      isDraft: false,
    );

    final attachments = mediaCubits.entries.map((entry) {
      final invoiceId = entry.key;
      final mediaCubit = entry.value;

      final files = mediaCubit.allFilesSelected.map((e) => e.toFile).toList();

      final apiInvoiceId = apiInvoicesIds[invoiceId] ?? '0';

      return {apiInvoiceId: files};
    }).toList();

    _updateDraftGroupedInvoiceExpense(
      context: context,
      model: model,
      id: id,
      attachments: attachments,
    );
  }

  @override
  void saveDraft(
    BuildContext context, {
    required String id,
    required Map<String, MediaCubit> mediaCubits,
  }) {
    final model = _groupedInvoiceUpdateDraftRequest(
      context: context,
      mediaCubits: mediaCubits,
      isDraft: true,
    );

    final attachments = mediaCubits.entries.map((entry) {
      final invoiceId = entry.key;
      final mediaCubit = entry.value;

      final files = mediaCubit.allFilesSelected.map((e) => e.toFile).toList();

      final apiInvoiceId = apiInvoicesIds[invoiceId] ?? '0';

      return {apiInvoiceId: files};
    }).toList();

    _updateDraftGroupedInvoiceExpense(
      context: context,
      model: model,
      id: id,
      attachments: attachments,
    );
  }

  @override
  void dispose() {
    deletedAttachmentsNotifier.dispose();
    super.dispose();
  }
}
