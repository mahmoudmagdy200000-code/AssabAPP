import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/enums/payment_method.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/strategies/priority_registry.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:assab/features/branch_manager_expenses/data/models/pre_approval_update_draft_request.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/payment_method/payment_method_cubit.dart';
import '../../../../core/cubits/select_priority/select_priority_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/file_preview_widget.dart';
import '../../../../core/widgets/list_view_files_preview.dart';
import '../../data/models/attachment_model.dart';
import '../../data/models/create_pre_approval_request_model.dart';
import '../../presentation/cubit/pre_approval/pre_approval_cubit.dart';
import '../../presentation/widgets/expenses_empty_widget.dart';
import '../entities/pre_approval_entity.dart';

abstract class PreApprovalDraftStrategy {
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

  void validateAll(BuildContext context, PreApprovalEntity preApprovalEntity) {}

  void submit(BuildContext context, {required String id});

  void saveDraft(BuildContext context, {required String id});
}

class AddNewPreApprovalDraftStrategy extends PreApprovalDraftStrategy {
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
  Widget buildAttachmentsSection(
    BuildContext context,
    List<AttachmentModel> attachments,
  ) {
    return ListViewFilesPreview(mediaCubit: context.read<MediaCubit>());
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

  void _createPreApprovalRequest(
    BuildContext context,
    CreatePreApprovalRequestModel createPreApprovalRequestModel,
  ) {
    context.read<PreApprovalCubit>().createPreApprovalExpense(
      model: createPreApprovalRequestModel,
    );
  }

  String _getField(ValidationCubit validationCubit, String key) {
    return validationCubit.state.fieldsValue[key]?.toString() ?? '';
  }

  List<ItemPreApprovalModel> _buildItemList(
    ValidationCubit validationCubit,
    List items,
  ) {
    return items.map((id) {
      return ItemPreApprovalModel(
        categoryId: _getField(validationCubit, 'itemPurchasedId_$id'),
        name: _getField(validationCubit, 'itemPurchasedName_$id'),
        quantity: _getField(validationCubit, 'purchaseQty_$id'),
        unitPrice: _getField(validationCubit, 'purchaseUnitPrice_$id'),
      );
    }).toList();
  }

  List<ExpensePreApprovalModel> _buildExpenseList(
    ValidationCubit validationCubit,
    List expenses,
  ) {
    return expenses.map((id) {
      return ExpensePreApprovalModel(
        categoryId: _getField(validationCubit, 'expenseItemId_$id'),
        name: _getField(validationCubit, 'expenseItemName_$id'),
        price: _getField(validationCubit, 'expenseUnitPrice_$id'),
      );
    }).toList();
  }

  CreatePreApprovalRequestModel _createPreApprovalRequestModel({
    required BuildContext context,
    required bool isDraft,
  }) {
    final validationCubit = context.read<ValidationCubit>();
    final addItemCubit = context.read<AddItemCubit>();
    final mediaCubit = context.read<MediaCubit>();

    final items = addItemCubit.state.lists['purchases'] ?? [];
    final expenses = addItemCubit.state.lists['expenses'] ?? [];

    final listItems = _buildItemList(validationCubit, items);
    final listExpenses = _buildExpenseList(validationCubit, expenses);

    final invoiceReceipt = mediaCubit.allFilesSelected
        .map((e) => e.toFile)
        .toList();

    return CreatePreApprovalRequestModel(
      purpose: _getField(validationCubit, 'purpose'),
      estimatedAmount: _getField(validationCubit, 'estimatedAmount'),
      supplierId: _getField(validationCubit, 'supplierId'),
      paymentMethod: _getField(validationCubit, 'paymentMethod'),
      paymentSupplierId: _getField(validationCubit, 'paymentSupplierId'),
      items: listItems,
      expenses: listExpenses,
      priority: _getField(validationCubit, 'priority'),
      invoiceReceipt: invoiceReceipt,
      isDraft: isDraft,
    );
  }

  @override
  void submit(BuildContext context, {required String id}) {
    _createPreApprovalRequest(
      context,
      _createPreApprovalRequestModel(context: context, isDraft: false),
    );
  }

  @override
  void saveDraft(BuildContext context, {required String id}) {
    _createPreApprovalRequest(
      context,
      _createPreApprovalRequestModel(context: context, isDraft: true),
    );
  }
}

class EditDraftPreApprovalDraftStrategy extends PreApprovalDraftStrategy {
  @override
  void getDetails(BuildContext context, String? id) {
    super.getDetails(context, id);
    context.read<ExpenseDetailsCubit>().getPreApprovalExpensesDetails(
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

  void _setAndValidatePurchaseItems(
    BuildContext context,
    PreApprovalEntity preApprovalEntity,
    ValidationCubit validationCubit,
    AddItemCubit addItemCubit,
  ) {
    for (int i = 0; i < preApprovalEntity.items.length; i++) {
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
      if (i > preApprovalEntity.items.length - 1) {
        break;
      }

      final item = preApprovalEntity.items[i];
      final id = item.categoryId;
      final title = item.category;
      final quantity = item.quantity;
      final unitPrice = item.rate;

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
    PreApprovalEntity preApprovalEntity,
    ValidationCubit validationCubit,
    AddItemCubit addItemCubit,
  ) {
    for (int i = 0; i < preApprovalEntity.expenses.length; i++) {
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
      if (i > preApprovalEntity.expenses.length - 1) {
        break;
      }

      final item = preApprovalEntity.expenses[i];
      final id = item.categoryId;
      final name = item.category;
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
  void validateAll(BuildContext context, PreApprovalEntity preApprovalEntity) {
    super.validateAll(context, preApprovalEntity);

    final validationCubit = context.read<ValidationCubit>();
    final addItemCubit = context.read<AddItemCubit>();

    _setAndValidatePurchaseItems(
      context,
      preApprovalEntity,
      validationCubit,
      addItemCubit,
    );

    _setAndValidateExpenseItems(
      context,
      preApprovalEntity,
      validationCubit,
      addItemCubit,
    );

    final paymentMethodCubit = context.read<PaymentMethodCubit>();

    final paymentMethod = preApprovalEntity.paymentMethod.toPaymentMethod();
    paymentMethodCubit.selectMethod(paymentMethod);

    if (paymentMethod == PaymentMethod.supplier) {
      final supplier = preApprovalEntity.paymentSupplier;

      paymentMethodCubit.selectSupplier(supplier);

      _validate(
        validationCubit: validationCubit,
        fieldName: 'paymentSupplierId',
        value: supplier.id,
        isValid: supplier.id != '0',
      );
    }

    context.read<SelectPriorityCubit>().selectPriority(
      PriorityRegistry.fromType(preApprovalEntity.priority.value ?? ''),
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'purpose',
      value: preApprovalEntity.purpose,
      isValid: true,
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'estimatedAmount',
      value: preApprovalEntity.estimatedAmount,
      isValid: true,
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'paymentMethod',
      value: preApprovalEntity.paymentMethod,
      isValid: true,
    );

    _validate(
      validationCubit: validationCubit,
      fieldName: 'priority',
      value: preApprovalEntity.priority.value ?? '',
      isValid: true,
    );

    _recalculatePhotosValidation(context, preApprovalEntity.attachments);
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

  void _updateDraftPreApprovalExpense(
    BuildContext context,
    PreApprovalUpdateDraftRequest preApprovalUpdateDraftRequest,
    String id,
  ) {
    context.read<PreApprovalCubit>().updateDraftPreApprovalExpense(
      model: preApprovalUpdateDraftRequest,
      id: id,
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

  List<PreApprovalUpdateDraftRequestItem> _buildItemList(
    ValidationCubit validationCubit,
    List items,
  ) {
    return items.map((id) {
      return PreApprovalUpdateDraftRequestItem(
        categoryId: _getField(validationCubit, 'itemPurchasedId_$id'),
        description: _getField(validationCubit, 'itemPurchasedName_$id'),
        quantity:
            double.tryParse(_getField(validationCubit, 'purchaseQty_$id')) ?? 0,
        rate:
            double.tryParse(
              _getField(validationCubit, 'purchaseUnitPrice_$id'),
            ) ??
            0,
      );
    }).toList();
  }

  List<PreApprovalUpdateDraftRequestExpense> _buildExpenseList(
    ValidationCubit validationCubit,
    List expenses,
  ) {
    return expenses.map((id) {
      return PreApprovalUpdateDraftRequestExpense(
        categoryId: _getField(validationCubit, 'expenseItemId_$id'),
        description: _getField(validationCubit, 'expenseItemName_$id'),
        price:
            double.tryParse(
              _getField(validationCubit, 'expenseUnitPrice_$id'),
            ) ??
            0,
      );
    }).toList();
  }

  PreApprovalUpdateDraftRequest _preApprovalUpdateDraftRequest({
    required BuildContext context,
    required bool isDraft,
  }) {
    final validationCubit = context.read<ValidationCubit>();
    final addItemCubit = context.read<AddItemCubit>();

    final items = addItemCubit.state.lists['purchases'] ?? [];
    final expenses = addItemCubit.state.lists['expenses'] ?? [];

    final listItems = _buildItemList(validationCubit, items);
    final listExpenses = _buildExpenseList(validationCubit, expenses);

    return PreApprovalUpdateDraftRequest(
      purpose: _getField(validationCubit, 'purpose'),
      estimatedAmount:
          double.tryParse(_getField(validationCubit, 'estimatedAmount')) ?? 0,
      supplierId: _getField(validationCubit, 'supplierId'),
      paymentMethod: _getField(validationCubit, 'paymentMethod'),
      paymentSupplierId: _getField(validationCubit, 'paymentSupplierId'),
      items: listItems,
      expenses: listExpenses,
      priority: _getField(validationCubit, 'priority'),
      deleteAttachments: deletedAttachments.toList(),
      isDraft: isDraft,
    );
  }

  @override
  void submit(BuildContext context, {required String id}) {
    _updateDraftPreApprovalExpense(
      context,
      _preApprovalUpdateDraftRequest(context: context, isDraft: false),
      id,
    );
  }

  @override
  void saveDraft(BuildContext context, {required String id}) {
    _updateDraftPreApprovalExpense(
      context,
      _preApprovalUpdateDraftRequest(context: context, isDraft: true),
      id,
    );
  }

  @override
  void dispose() {
    deletedAttachmentsNotifier.dispose();
    super.dispose();
  }
}
