import 'dart:io';

import 'package:assab/core/cubits/payment_method/payment_method_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/enums/payment_method.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:assab/features/branch_manager_expenses/data/models/update_draft_quick_cash_request_model.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/quick_cash_entity.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/widgets/file_preview_widget.dart';
import '../../../../core/widgets/list_view_files_preview.dart';
import '../../../../core/widgets/network_file_preview_widget.dart';
import '../../data/models/attachment_model.dart';
import '../../data/models/create_quick_cash_request_model.dart';
import '../../data/models/quick_cash_expense_data_model.dart';
import '../../data/models/quick_cash_item_model.dart';
import '../../presentation/cubit/quick_cash/quick_cash_cubit.dart';
import '../../presentation/widgets/expenses_empty_widget.dart';
import '../../presentation/widgets/quick_cash_list_item_expense.dart';

abstract class QuickCashDraftStrategy {
  void getDetails(BuildContext context, String? id) {}

  Widget buildAttachmentsSection(
    BuildContext context,
    QuickCashEntity? quickCashEntity,
  );

  Widget buildEmptyWidget(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildQuickCashListItemExpense(
    BuildContext context,
    VoidCallback validateItemsAmount,
    QuickCashEntity? quickCashEntity,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildSummaryAttachmentSection(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData,
    List<AttachmentModel> apiAttachments,
  ) {
    return const SizedBox.shrink();
  }

  void dispose() {}

  void validateAll(BuildContext context, QuickCashEntity quickCashEntity) {}

  void submit(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData, {
    required String id,
  });

  void saveDraft(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData, {
    required String id,
  });
}

class AddNewQuickCashStrategy extends QuickCashDraftStrategy {
  @override
  Widget buildAttachmentsSection(
    BuildContext context,
    QuickCashEntity? quickCashEntity,
  ) {
    return ListViewFilesPreview(mediaCubit: context.read<MediaCubit>());
  }

  @override
  Widget buildSummaryAttachmentSection(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData,
    List<AttachmentModel> apiAttachments,
  ) {
    return SliverList.builder(
      itemCount: quickCashExpenseData.files.length,
      itemBuilder: (context, index) {
        return FilePreviewWidget(
          file: quickCashExpenseData.files[index],
          onTapIcon: () {},
          icon: AppAssets.eye,
          iconColor: context.customColor.text6,
        );
      },
    );
  }

  void _createQuickCashExpense(
    BuildContext context,
    CreateQuickCashRequestModel createQuickCashRequestModel,
  ) {
    context.read<QuickCashCubit>().createQuickCashExpense(
      model: createQuickCashRequestModel,
    );
  }

  CreateQuickCashRequestModel _createQuickCashRequestModel(
    QuickCashExpenseData quickCashExpenseData, {
    bool isDraft = false,
  }) {
    return CreateQuickCashRequestModel(
      invoiceReceipt: quickCashExpenseData.files.map((e) => e.toFile).toList(),
      expenseDate: quickCashExpenseData.expenseDate,
      expenseName: quickCashExpenseData.expenseTitle,
      totalAmount: quickCashExpenseData.totalAmount,
      items: quickCashExpenseData.listItems
          .map(
            (e) => QuickCashItemModel(
              title: e.itemTitle,
              amount: double.tryParse(e.itemAmount) ?? 0,
            ),
          )
          .toList(),
      paymentMethod: quickCashExpenseData.paymentMethod,
      paymentSupplierId: quickCashExpenseData.paymentSupplierId,
      isDraft: isDraft,
    );
  }

  @override
  void submit(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData, {
    required String id,
  }) {
    _createQuickCashExpense(
      context,
      _createQuickCashRequestModel(quickCashExpenseData),
    );
  }

  @override
  void saveDraft(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData, {
    required String id,
  }) {
    _createQuickCashExpense(
      context,
      _createQuickCashRequestModel(quickCashExpenseData, isDraft: true),
    );
  }

  @override
  Widget buildQuickCashListItemExpense(
    BuildContext context,
    VoidCallback validateItemsAmount,
    QuickCashEntity? quickCashEntity,
  ) {
    return QuickCashListItemExpense(validateItemsAmount: validateItemsAmount);
  }
}

class EditDraftQuickCashStrategy extends QuickCashDraftStrategy {
  EditDraftQuickCashStrategy();

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
  void getDetails(BuildContext context, String? id) {
    super.getDetails(context, id);

    context.read<ExpenseDetailsCubit>().getQuickCashExpensesDetails(
      id: id ?? '',
    );
  }

  @override
  Widget buildAttachmentsSection(
    BuildContext context,
    QuickCashEntity? quickCashEntity,
  ) {
    if (quickCashEntity == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

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
                itemCount: quickCashEntity.attachments.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final attachment = quickCashEntity.attachments[index];
                  final isDeleted = deletedSet.contains(attachment.id);

                  return NetworkFilePreviewWidget(
                    attachmentModel: attachment,
                    delete: !isDeleted,
                    onDelete: () {
                      _markAttachmentAsDeleted(attachment.id);
                      _recalculatePhotosValidation(
                        context,
                        quickCashEntity.attachments,
                      );
                    },
                    restore: isDeleted,
                    onRestore: () {
                      _unmarkAttachmentAsDeleted(attachment.id);
                      _recalculatePhotosValidation(
                        context,
                        quickCashEntity.attachments,
                      );
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

                _recalculatePhotosValidation(
                  context,
                  quickCashEntity.attachments,
                );

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

  @override
  Widget buildSummaryAttachmentSection(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData,
    List<AttachmentModel> apiAttachments,
  ) {
    return SliverToBoxAdapter(
      child: Column(
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
                    .where(
                      (element) => !deletedAttachments.contains(element.id),
                    )
                    .toList()[index];

                return NetworkFilePreviewWidget(attachmentModel: attachment);
              },
            ),
          if (quickCashExpenseData.files.isNotEmpty)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: quickCashExpenseData.files.length,
              itemBuilder: (context, index) {
                return FilePreviewWidget(
                  file: quickCashExpenseData.files[index],
                  onTapIcon: () {},
                  icon: AppAssets.eye,
                  iconColor: context.customColor.text6,
                );
              },
            ),
        ],
      ),
    );
  }

  void _validateField({
    required BuildContext context,
    required String fieldName,
    required bool isValid,
    required dynamic value,
  }) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: fieldName,
      isValid: isValid,
      value: value,
    );
  }

  @override
  void validateAll(BuildContext context, QuickCashEntity quickCashEntity) {
    super.validateAll(context, quickCashEntity);

    final validations = <String, bool>{
      'date': quickCashEntity.expenseDate != 'N/A',
      'expenseTitle': quickCashEntity.expenseName != 'N/A',
      'totalAmount': quickCashEntity.totalAmount != 'N/A',
      'paymentMethod': quickCashEntity.paymentMethod != 'N/A',
      'photos':
          quickCashEntity.attachments.isNotEmpty ||
          (quickCashEntity.attachments.length != deletedAttachments.length) ||
          context.read<MediaCubit>().allFilesSelected.isNotEmpty,
    };

    if (quickCashEntity.paymentMethod ==
        PaymentMethod.supplier.paymentMethodToString()) {
      validations['paymentSupplierId'] =
          quickCashEntity.paymentSupplier.id != '0';
    }

    final validationCubit = context.read<ValidationCubit>();

    if (quickCashEntity.expenseItems.isNotEmpty) {
      for (var i = 0; i < quickCashEntity.expenseItems.length; i++) {
        context.read<AddItemCubit>().addItem('quick_cash_expense_items');
      }

      context.read<ValidationCubit>().toggleFieldRequirement(
        'itemsAmount',
        isRequired: true,
      );

      final dynamicFields =
          context
              .read<AddItemCubit>()
              .state
              .lists['quick_cash_expense_items']
              ?.expand((id) => {'item_title_$id', 'item_amount_$id'})
              .toSet() ??
          <String>{};

      final existingDynamic = validationCubit.state.fieldsValidity.keys
          .where(
            (k) => k.startsWith('item_title_') || k.startsWith('item_amount_'),
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

      final expenseItemsIds =
          context
              .read<AddItemCubit>()
              .state
              .lists['quick_cash_expense_items'] ??
          [];

      for (int i = 0; i < expenseItemsIds.length; i++) {
        if (i > quickCashEntity.expenseItems.length - 1) {
          break;
        }

        final item = quickCashEntity.expenseItems[i];
        final title = item.title;
        final amount = item.amount;

        validationCubit
          ..validateFieldAndStoreValue(
            fieldName: 'item_title_${expenseItemsIds[i]}',
            value: title,
            isValid: true,
          )
          ..validateFieldAndStoreValue(
            fieldName: 'item_amount_${expenseItemsIds[i]}',
            value: amount.toString(),
            isValid: true,
          );
      }
    }

    validationCubit.validateField('itemsAmount', true);

    final paymentMethodCubit = context.read<PaymentMethodCubit>();

    final paymentMethod = quickCashEntity.paymentMethod.toPaymentMethod();
    paymentMethodCubit.selectMethod(paymentMethod);

    if (paymentMethod == PaymentMethod.supplier) {
      final supplier = quickCashEntity.paymentSupplier;

      paymentMethodCubit.selectSupplier(supplier);
    }

    _validateField(
      context: context,
      fieldName: 'date',
      isValid: validations['date'] ?? false,
      value: quickCashEntity.expenseDate,
    );

    _validateField(
      context: context,
      fieldName: 'expenseTitle',
      isValid: validations['expenseTitle'] ?? false,
      value: quickCashEntity.expenseName,
    );

    _validateField(
      context: context,
      fieldName: 'totalAmount',
      isValid: validations['totalAmount'] ?? false,
      value: quickCashEntity.totalAmount,
    );

    _validateField(
      context: context,
      fieldName: 'paymentMethod',
      isValid: validations['paymentMethod'] ?? false,
      value: quickCashEntity.paymentMethod,
    );

    if (validations.containsKey('paymentSupplierId')) {
      _validateField(
        context: context,
        fieldName: 'paymentSupplierId',
        isValid: validations['paymentSupplierId'] ?? false,
        value: quickCashEntity.paymentSupplier.id,
      );
    }

    _recalculatePhotosValidation(context, quickCashEntity.attachments);
  }

  @override
  Widget buildQuickCashListItemExpense(
    BuildContext context,
    VoidCallback validateItemsAmount,
    QuickCashEntity? quickCashEntity,
  ) {
    return QuickCashListItemExpense(
      validateItemsAmount: validateItemsAmount,
      expenseTitles:
          quickCashEntity?.expenseItems.map((e) => e.title).toList() ?? [],
      expenseAmounts:
          quickCashEntity?.expenseItems
              .map((e) => e.amount.toString())
              .toList() ??
          [],
    );
  }

  void _updateDraftQuickCashExpense(
    BuildContext context,
    UpdateDraftQuickCashRequestModel updateDraftQuickCashRequestModel, {
    required String id,
    required List<File> attachments,
  }) {
    context.read<QuickCashCubit>().updateDraftQuickCashExpense(
      id: id,
      model: updateDraftQuickCashRequestModel,
      attachments: attachments,
    );
  }

  UpdateDraftQuickCashRequestModel _updateDraftQuickCashRequestModel(
    QuickCashExpenseData quickCashExpenseData, {
    bool isDraft = false,
  }) {
    return UpdateDraftQuickCashRequestModel(
      expenseDate: quickCashExpenseData.expenseDate,
      expenseName: quickCashExpenseData.expenseTitle,
      totalAmount: quickCashExpenseData.totalAmount,
      items: quickCashExpenseData.listItems
          .map(
            (e) => QuickCashItemModel(
              title: e.itemTitle,
              amount: double.tryParse(e.itemAmount) ?? 0,
            ),
          )
          .toList(),
      paymentMethod: quickCashExpenseData.paymentMethod,
      paymentSupplierId: quickCashExpenseData.paymentSupplierId,
      isDraft: isDraft,
      deleteAttachments: deletedAttachments.toList(),
    );
  }

  @override
  void submit(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData, {
    required String id,
  }) {
    _updateDraftQuickCashExpense(
      context,
      _updateDraftQuickCashRequestModel(quickCashExpenseData),
      id: id,
      attachments: quickCashExpenseData.files.map((e) => e.toFile).toList(),
    );
  }

  @override
  void saveDraft(
    BuildContext context,
    QuickCashExpenseData quickCashExpenseData, {
    required String id,
  }) {
    _updateDraftQuickCashExpense(
      context,
      _updateDraftQuickCashRequestModel(quickCashExpenseData, isDraft: true),
      id: id,
      attachments: quickCashExpenseData.files.map((e) => e.toFile).toList(),
    );
  }

  @override
  void dispose() {
    deletedAttachmentsNotifier.dispose();
  }
}
