import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/add_item/add_item_state.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/entities/grouped_invoice_entity.dart';
import '../../domain/strategies/grouped_invoice_draft_strategy.dart';
import '../widgets/grouped_invoices_widget.dart';

class GroupedInvoiceInvoicesView extends StatefulWidget {
  final GroupedInvoiceDraftStrategy strategy;
  final GroupedInvoiceEntity? groupedInvoiceEntity;
  final Map<String, MediaCubit> mediaCubits;

  const GroupedInvoiceInvoicesView({
    super.key,
    required this.mediaCubits,
    required this.strategy,
    required this.groupedInvoiceEntity,
  });

  @override
  State<GroupedInvoiceInvoicesView> createState() =>
      _GroupedInvoiceInvoicesViewState();
}

class _GroupedInvoiceInvoicesViewState extends State<GroupedInvoiceInvoicesView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Map<String, MediaCubit> mediaCubits = {};

  MediaCubit _getMediaCubit(String id) {
    return widget.mediaCubits.putIfAbsent(id, () => getIt<MediaCubit>());
  }

  @override
  void initState() {
    widget.strategy.addInitInvoice(context);
    super.initState();
  }

  @override
  void dispose() {
    for (final cubit in mediaCubits.values) {
      cubit.close();
    }
    super.dispose();
  }

  void _onAddNewInvoiceGroup() {
    context.read<AddItemCubit>().addItem('invoiceGroup');
  }

  void _syncDynamicValidationFields({
    required BuildContext context,
    required ValidationCubit validationCubit,
    required List<String> invoicesGroup,
  }) {
    final dynamicFields = invoicesGroup
        .expand(
          (id) => {
            'supplierId_$id',
            'supplierName_$id',
            'invoiceNumber_$id',
            'issueDate_$id',
            'photos_$id',
          },
        )
        .toSet();

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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocSelector<AddItemCubit, AddItemState, List<String>>(
            selector: (state) => state.lists['invoiceGroup'] ?? [],
            builder: (context, invoiceGroupItems) {
              _syncDynamicValidationFields(
                context: context,
                validationCubit: context.read<ValidationCubit>(),
                invoicesGroup: invoiceGroupItems,
              );

              return Column(
                children: List.generate(invoiceGroupItems.length, (index) {
                  final id = invoiceGroupItems[index];

                  return KeyedSubtree(
                    key: UniqueKey(),
                    child: BlocProvider.value(
                      value: _getMediaCubit(id),
                      child: Column(
                        children: [
                          GroupedInvoicesWidget(
                            id: id,
                            index: index,
                            onRemove: () => mediaCubits.remove(id)?.close(),
                            strategy: widget.strategy,
                            groupedInvoiceEntity: widget.groupedInvoiceEntity,
                          ),
                          if (index != invoiceGroupItems.length - 1)
                            10.verticalSpace,
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          20.verticalSpace,
          Row(
            children: [
              ButtonTextIcon(
                onTap: () => _onAddNewInvoiceGroup(),
                label: context.tr.addNewInvoiceGroup,
                padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 12.r),
                borderColor: context.theme.primaryColor,
                textColor: context.theme.primaryColor,
                icon: Icon(
                  Icons.add,
                  size: 20.r,
                  color: context.theme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
