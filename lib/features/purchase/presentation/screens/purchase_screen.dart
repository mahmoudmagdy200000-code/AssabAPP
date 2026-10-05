import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/features/purchase/presentation/cubit/add_item_purchase/add_item_purchase_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../domain/strategies/create_order_strategy.dart';
import '../cubit/select_filter_item/select_filter_item_cubit.dart';
import '../widgets/purchase_app_bar.dart';
import 'new_purchase_order_screen.dart';
import 'purchase_choose_items_view.dart';

class PurchaseScreen extends StatefulWidget {
  final CreateOrderStrategy strategy;

  const PurchaseScreen({super.key, required this.strategy});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  void initState() {
    super.initState();

    widget.strategy.getDetails(context);
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
            child: BlocProvider(
              create: (context) => getIt<SelectFilterItemCubit>(),
              child: BlocSelector<PagingCubit, PagingState, int>(
                selector: (state) => state.currentIndex,
                builder: (context, state) {
                  return IndexedStack(
                    index: state,
                    children: [
                      PurchaseChooseItemsView(strategy: widget.strategy),
                      MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<AddItemPurchaseCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => getIt<AddItemCubit>(),
                          ),
                          BlocProvider(
                            create: (context) =>
                                ValidationCubit(requiredFields: {}),
                          ),
                        ],
                        child: NewPurchaseOrderScreen(
                          strategy: widget.strategy,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
