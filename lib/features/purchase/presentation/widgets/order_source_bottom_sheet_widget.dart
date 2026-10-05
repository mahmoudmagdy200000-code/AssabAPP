import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/purchase/presentation/cubit/purchasing_officer_select_processing_time/purchasing_officer_select_processing_time_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/purchasing_officer_select_quality/purchasing_officer_select_quality_cubit.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/enums/purchase_sources_types.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../../data/models/purchase_branches_response.dart';
import '../../data/models/purchase_suppliers_response.dart';
import '../cubit/filter_branches/filter_branches_cubit.dart';
import '../cubit/get_purchase_branches/get_purchase_branches_cubit.dart';
import '../cubit/get_purchase_suppliers/get_purchase_suppliers_cubit.dart';
import '../screens/choose_branch_screen.dart';
import '../screens/choose_direct_supplier_screen.dart';
import '../screens/purchasing_officer_screen.dart';
import 'choose_order_source_widget.dart';

class OrderSourceBottomSheetWidget extends StatelessWidget {
  final PurchaseBranchItemData item;
  final int itemQuantity;
  final String sourceTypeFieldName;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;
  final String addedItemMainId;

  const OrderSourceBottomSheetWidget({
    super.key,
    required this.item,
    required this.itemQuantity,
    required this.sourceTypeFieldName,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
    required this.addedItemMainId,
  });

  void _chooseSource(BuildContext context, Widget screen) {
    AppBottomSheet.customPageRoute(context, (context) => screen);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.orderSource,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.verticalSpace,
            Text(
              context.tr.selectWhereOrHowThisItemWillBePurchased,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.verticalSpace,
            PurchaseItemPreviewWidget(
              itemImage: item.itemLogo,
              itemName:
                  '${item.itemName} (${item.itemUnit})',
              itemPrice: item.itemPrice,
              itemQuantity: itemQuantity,
              itemUnit: item.itemUnit,
            ),
            12.verticalSpace,
            const CustomDivider(),
            12.verticalSpace,
            ChooseOrderSourceWidget(
              itemId: item.id,
              sourceTypeFieldName: sourceTypeFieldName,
              sourceType: PurchaseSourcesTypes.supplier,
              choosedSourceItemIdFieldName: choosedSourceItemIdFieldName,
              sourceIdFieldName: sourceIdFieldName,
              sourceNameFieldName: sourceNameFieldName,
              addedItemMainId: addedItemMainId,
              item: item,
              quantity: itemQuantity,
              onChoose: () {
                final validationCubit = context.read<ValidationCubit>();

                _chooseSource(
                  context,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => getIt<GetPurchaseSuppliersCubit>(),
                      ),
                      BlocProvider(
                        create: (context) =>
                            SearchCubit<PurchaseSuppliersData>(),
                      ),
                      BlocProvider(
                        create: (context) => getIt<ChooseItemCubit>(),
                      ),
                      BlocProvider.value(value: validationCubit),
                    ],
                    child: ChooseDirectSupplierScreen(
                      item: item,
                      quantity: itemQuantity,
                      sourceTypeFieldName: sourceTypeFieldName,
                      sourceIdFieldName: sourceIdFieldName,
                      sourceNameFieldName: sourceNameFieldName,
                      choosedSourceItemIdFieldName:
                          choosedSourceItemIdFieldName,
                      addedItemMainId: addedItemMainId,
                    ),
                  ),
                );
              },
              assetName: AppAssets.directSupplier,
              title: context.tr.directSupplierOrder,
              desc1: context.tr.traditionalSupplierOrder,
              desc2: context.tr.individualPricingFastDelivery,
              desc3: context.tr.suitableForSmallQuantities,
            ),
            8.verticalSpace,
            ChooseOrderSourceWidget(
              itemId: item.id,
              sourceTypeFieldName: sourceTypeFieldName,
              sourceType: PurchaseSourcesTypes.officer,
              choosedSourceItemIdFieldName: choosedSourceItemIdFieldName,
              sourceIdFieldName: sourceIdFieldName,
              sourceNameFieldName: sourceNameFieldName,
              item: item,
              quantity: itemQuantity,
              addedItemMainId: addedItemMainId,
              onChoose: () {
                final validationCubit = context.read<ValidationCubit>();

                _chooseSource(
                  context,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            getIt<PurchasingOfficerSelectQualityCubit>(),
                      ),
                      BlocProvider(
                        create: (context) =>
                            getIt<PurchasingOfficerSelectProcessingTimeCubit>(),
                      ),
                      BlocProvider.value(value: validationCubit),
                    ],
                    child: PurchasingOfficerScreen(
                      item: item,
                      quantity: itemQuantity,
                      addedItemMainId: addedItemMainId,
                    ),
                  ),
                );
              },
              assetName: AppAssets.personSvg,
              title: context.tr.orderViaPurchasingOfficer,
              desc1: context.tr.consolidatedOrdersBetterPrices,
              desc2: context.tr.bulkDiscounts1020,
              desc3: context.tr.guaranteedQualityReliableSupplier,
            ),
            8.verticalSpace,
            ChooseOrderSourceWidget(
              itemId: item.id,
              sourceTypeFieldName: sourceTypeFieldName,
              sourceType: PurchaseSourcesTypes.branch,
              choosedSourceItemIdFieldName: choosedSourceItemIdFieldName,
              sourceIdFieldName: sourceIdFieldName,
              sourceNameFieldName: sourceNameFieldName,
              item: item,
              quantity: itemQuantity,
              addedItemMainId: addedItemMainId,
              onChoose: () {
                final validationCubit = context.read<ValidationCubit>();

                _chooseSource(
                  context,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => getIt<GetPurchaseBranchesCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => SearchCubit<PurchaseBranchData>(),
                      ),
                      BlocProvider(
                        create: (context) => getIt<FilterBranchesCubit>(),
                      ),
                      BlocProvider(
                        create: (context) => getIt<ChooseItemCubit>(),
                      ),
                      BlocProvider.value(value: validationCubit),
                    ],
                    child: ChooseBranchScreen(
                      item: item,
                      quantity: itemQuantity,
                      sourceTypeFieldName: sourceTypeFieldName,
                      sourceIdFieldName: sourceIdFieldName,
                      sourceNameFieldName: sourceNameFieldName,
                      choosedSourceItemIdFieldName:
                          choosedSourceItemIdFieldName,
                    ),
                  ),
                );
              },
              assetName: AppAssets.branch,
              title: context.tr.internalTransferFromAnotherBranch,
              desc1: context.tr.stockTransferNoCost,
              desc2: context.tr.fastDeliveryLimitedQuantities,
              desc3: context.tr.suitableForEmergencies,
            ),
          ],
        ),
      ),
    );
  }
}
