import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../purchase/presentation/widgets/purchase_app_bar.dart';
import '../../data/models/supplier_items_response.dart';
import '../../data/models/supplier_orders_response.dart';
import 'supplier_alternative_choose_item_view.dart';
import 'supplier_alternative_summary_view.dart';

class SupplierAlternativeProductItemBottomSheet extends StatefulWidget {
  final SupplierOrderItem item;
  final String orderId;

  const SupplierAlternativeProductItemBottomSheet({
    super.key,
    required this.item,
    required this.orderId,
  });

  @override
  State<SupplierAlternativeProductItemBottomSheet> createState() =>
      _SupplierAlternativeProductItemBottomSheetState();
}

class _SupplierAlternativeProductItemBottomSheetState
    extends State<SupplierAlternativeProductItemBottomSheet> {
  late final ValueNotifier<Map<SupplierItem, int>> _itemCountNotifier;

  @override
  void initState() {
    super.initState();

    _itemCountNotifier = ValueNotifier({});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.newPurchaseOrder,
            subtitle: context.tr.chooseProductsOrderSources,
          ),
          Expanded(
            child: BlocSelector<PagingCubit, PagingState, int>(
              selector: (state) => state.currentIndex,
              builder: (context, state) {
                return IndexedStack(
                  index: state,
                  children: [
                    SupplierAlternativeChooseItemView(
                      item: widget.item,
                      itemCountNotifier: _itemCountNotifier,
                    ),
                    if (_itemCountNotifier.value.isNotEmpty)
                      SupplierAlternativeSummaryView(
                        oldItem: widget.item,
                        newItem: _itemCountNotifier.value.keys.first,
                        newItemQty: _itemCountNotifier.value.values.first,
                        orderId: widget.orderId,
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
