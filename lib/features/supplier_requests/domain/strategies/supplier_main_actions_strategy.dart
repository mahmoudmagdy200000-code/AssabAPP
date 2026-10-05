import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../data/models/supplier_items_response.dart';
import '../../data/models/supplier_orders_response.dart';
import '../../presentation/cubit/get_supplier_items/get_supplier_items_cubit.dart';
import '../../presentation/cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart';
import '../../presentation/widgets/supplier_alternative_product_item_bottom_sheet.dart';
import '../../presentation/widgets/supplier_confirm_item_bottom_sheet_widget.dart';
import '../../presentation/widgets/supplier_need_time_item_bottom_sheet_widget.dart';
import '../../presentation/widgets/supplier_partial_confirm_item_bottom_sheet_widget.dart';

abstract class SupplierMainActionsStrategy {
  void action(BuildContext context, SupplierOrderItem item, String orderId);
}

class ConfirmRequestedQuantityStrategyImpl extends SupplierMainActionsStrategy {
  @override
  void action(BuildContext context, SupplierOrderItem item, String orderId) {
    AppBottomSheet.show(
      context,
      (context) => BlocProvider(
        create: (context) => getIt<SupplierConfirmOrRejectOrderOrItemCubit>(),
        child: SupplierConfirmItemBottomSheetWidget(
          item: item,
          orderId: orderId,
        ),
      ),
    );
  }
}

class ProposeNewQuantityStrategyImpl extends SupplierMainActionsStrategy {
  @override
  void action(BuildContext context, SupplierOrderItem item, String orderId) {
    AppBottomSheet.customPageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ValidationCubit(requiredFields: {'newQty', 'note'}),
          ),
        ],
        child: SupplierPartialConfirmItemBottomSheetWidget(
          item: item,
          orderId: orderId,
        ),
      ),
    );
  }
}

class LowStockNeedTimeStrategyImpl extends SupplierMainActionsStrategy {
  @override
  void action(BuildContext context, SupplierOrderItem item, String orderId) {
    AppBottomSheet.customPageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                getIt<SupplierConfirmOrRejectOrderOrItemCubit>(),
          ),
          BlocProvider(
            create: (context) =>
                ValidationCubit(requiredFields: {'newDate', 'note'}),
          ),
        ],
        child: SupplierNeedTimeItemBottomSheetWidget(
          item: item,
          orderId: orderId,
        ),
      ),
    );
  }
}

class ProposeAlternativeProductStrategyImpl
    extends SupplierMainActionsStrategy {
  @override
  void action(BuildContext context, SupplierOrderItem item, String orderId) {
    AppBottomSheet.customPageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ValidationCubit(requiredFields: {'items', 'note'}),
          ),
          BlocProvider(create: (context) => getIt<GetSupplierItemsCubit>()),
          BlocProvider(create: (context) => SearchCubit<SupplierItem>()),
          BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
          BlocProvider(
            create: (context) =>
                getIt<SupplierConfirmOrRejectOrderOrItemCubit>(),
          ),
        ],
        child: SupplierAlternativeProductItemBottomSheet(
          item: item,
          orderId: orderId,
        ),
      ),
    );
  }
}
