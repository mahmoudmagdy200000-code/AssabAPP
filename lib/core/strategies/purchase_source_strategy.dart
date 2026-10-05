import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/purchase/presentation/screens/direct_supplier_summary_view.dart';
import 'package:assab/features/purchase/presentation/screens/purchasing_officer_summary_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/branch_manager_requests/presentation/cubit/get_order_details/get_order_details_cubit.dart';
import '../../features/branch_manager_requests/presentation/widgets/branch_direct_supplier_request_details_view.dart';
import '../../features/branch_manager_requests/presentation/widgets/branch_request_details_screen_approval_view.dart';
import '../../features/branch_manager_requests/presentation/widgets/branch_request_details_screen_details_view.dart';
import '../../features/branch_manager_requests/presentation/widgets/direct_supplier_request_details_screen_approval_view.dart';
import '../../features/branch_manager_requests/presentation/widgets/purchase_officer_request_details_screen_approval_view.dart';
import '../../features/branch_manager_requests/presentation/widgets/purchasing_officer_request_details_screen_details_view.dart';
import '../../features/purchase/data/models/compare_price_response.dart';
import '../../features/purchase/data/models/purchase_branch_items_response.dart';
import '../../features/purchase/data/models/purchase_create_order_request.dart';
import '../../features/purchase/data/models/source_local_model.dart';
import '../../features/purchase/presentation/cubit/get_purchase_products_branch_details/get_purchase_products_branch_details_cubit.dart';
import '../../features/purchase/presentation/cubit/get_purchase_products_officer_details/get_purchase_products_officer_details_cubit.dart';
import '../../features/purchase/presentation/cubit/get_purchase_products_supplier_details/get_purchase_products_supplier_details_cubit.dart';
import '../../features/purchase/presentation/cubit/purchasing_officer_select_processing_time/purchasing_officer_select_processing_time_cubit.dart';
import '../../features/purchase/presentation/cubit/purchasing_officer_select_quality/purchasing_officer_select_quality_cubit.dart';
import '../../features/purchase/presentation/screens/choose_branch_summary_view.dart';
import '../../features/purchase/presentation/screens/purchasing_officer_screen.dart';
import '../../features/purchase/presentation/widgets/choose_supplier_options_bottom_sheet.dart';
import '../../features/purchase/presentation/widgets/row_order_type_widget.dart';
import '../cubits/select_priority/select_priority_cubit.dart';
import '../di/dependency_injection.dart';
import '../enums/purchase_sources_types.dart';
import '../services/navigation/navigation_service.dart';

abstract class PurchaseSourceStrategy {
  Widget buildSource(
    BuildContext context,
    String sourceNameFieldName,
    String sourceTypeFieldName,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildSummary(
    BuildContext context,
    SourceLocalModel source,
    PurchaseCreateOrderRequest createOrderRequest,
    int sourceIndex,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildRowType(BuildContext context) {
    return const SizedBox.shrink();
  }

  void useRecommendedSource(
    BuildContext context,
    PurchaseComparePriceResponseUseRecommendation useRecommendation,
    String sourceTypeFieldName,
    String sourceIdFieldName,
    String sourceNameFieldName,
    String choosedSourceItemIdFieldName,
    String itemId,
    PurchaseBranchItemData item,
    int quantity,
    String addedItemMainId,
  ) {}

  Widget buildDetailsView(bool isBranchOrderTypeStrategy) {
    return const SizedBox.shrink();
  }

  void getDetails(BuildContext context, String id) {}

  Widget buildApproval(String id) {
    return const SizedBox.shrink();
  }

  String getName(BuildContext context);

  String approvalViewTitle(BuildContext context) {
    return context.tr.approval;
  }
}

class NonPurchaseSourceStrategy extends PurchaseSourceStrategy {
  @override
  Widget buildSource(
    BuildContext context,
    String sourceNameFieldName,
    String sourceTypeFieldName,
  ) {
    return Text(
      context.tr.chooseOrderSource,
      style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
    );
  }

  @override
  String getName(BuildContext context) {
    return context.tr.noSource;
  }
}

class BranchPurchaseSourceStrategy extends PurchaseSourceStrategy {
  @override
  void getDetails(BuildContext context, String id) {
    super.getDetails(context, id);
    context.read<GetOrderDetailsCubit>().getBranchOrdersDetails(id: id);
  }

  @override
  Widget buildSource(
    BuildContext context,
    String sourceNameFieldName,
    String sourceTypeFieldName,
  ) {
    return BlocSelector<ValidationCubit, ValidationState, String?>(
      selector: (state) => state.fieldsValue[sourceNameFieldName],
      builder: (context, state) {
        if (state == null || state.isEmpty) {
          return Text(
            context.tr.chooseOrderSource,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          );
        }

        return Row(
          children: [
            AppSvg(assetName: AppAssets.branch, width: 20.w, height: 20.w),
            10.horizontalSpace,
            Expanded(
              child: Text(
                '${context.tr.transferFrom} $state',
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSummary(
    BuildContext context,
    SourceLocalModel source,
    PurchaseCreateOrderRequest createOrderRequest,
    int sourceIndex,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SelectPriorityCubit>()),
        BlocProvider(
          create: (context) => getIt<GetPurchaseProductsBranchDetailsCubit>(),
        ),
      ],
      child: ChooseBranchSummaryView(
        branch: source,
        createOrderRequest: createOrderRequest,
      ),
    );
  }

  @override
  Widget buildRowType(BuildContext context) {
    return RowOrderTypeWidget(
      assetName: AppAssets.myLedger,
      title: context.tr.internalTransferFromAnotherBranch,
    );
  }

  @override
  void useRecommendedSource(
    BuildContext context,
    PurchaseComparePriceResponseUseRecommendation useRecommendation,
    String sourceTypeFieldName,
    String sourceIdFieldName,
    String sourceNameFieldName,
    String choosedSourceItemIdFieldName,
    String itemId,
    PurchaseBranchItemData item,
    int quantity,
    String addedItemMainId,
  ) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.validateFieldAndStoreValue(
      fieldName: sourceTypeFieldName,
      value: PurchaseSourcesTypes.branch.toString(),
      isValid: true,
    );

    validationCubit.validateFieldAndStoreValue(
      fieldName: sourceIdFieldName,
      value: useRecommendation.sourceId!,
      isValid: true,
    );

    validationCubit.validateFieldAndStoreValue(
      fieldName: choosedSourceItemIdFieldName,
      value: itemId,
      isValid: true,
    );

    validationCubit.validateFieldAndStoreValue(
      fieldName: sourceNameFieldName,
      value: useRecommendation.sourceName,
      isValid: true,
    );

    NavigationService.I.pop();
  }

  @override
  Widget buildDetailsView(bool isBranchOrderTypeStrategy) {
    return BranchRequestDetailsScreenDetailsView(
      isBranchOrderTypeStrategy: isBranchOrderTypeStrategy,
    );
  }

  @override
  Widget buildApproval(String id) {
    return const BranchRequestDetailsScreenApprovalView();
  }

  @override
  String getName(BuildContext context) {
    return context.tr.internalTransferFromAnotherBranch;
  }
}

class DirectSupplierPurchaseSourceStrategy extends PurchaseSourceStrategy {
  @override
  Widget buildSource(
    BuildContext context,
    String sourceNameFieldName,
    String sourceTypeFieldName,
  ) {
    return BlocSelector<ValidationCubit, ValidationState, String?>(
      selector: (state) => state.fieldsValue[sourceNameFieldName],
      builder: (context, state) {
        if (state == null || state.isEmpty) {
          return Text(
            context.tr.chooseOrderSource,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          );
        }

        return Row(
          children: [
            AppSvg(assetName: AppAssets.personSvg, width: 20.w, height: 20.w),
            10.horizontalSpace,
            Expanded(
              child: Text(
                '$state (${context.tr.directSupplier})',
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSummary(
    BuildContext context,
    SourceLocalModel source,
    PurchaseCreateOrderRequest createOrderRequest,
    int sourceIndex,
  ) {
    return BlocProvider(
      create: (context) => getIt<GetPurchaseProductsSupplierDetailsCubit>(),
      child: DirectSupplierSummaryView(
        source: source,
        createOrderRequest: createOrderRequest,
        sourceIndex: sourceIndex,
        sourceType: this,
      ),
    );
  }

  @override
  Widget buildRowType(BuildContext context) {
    return RowOrderTypeWidget(
      assetName: AppAssets.personSvg,
      title: context.tr.orderViaSupplier,
    );
  }

  @override
  void useRecommendedSource(
    BuildContext context,
    PurchaseComparePriceResponseUseRecommendation useRecommendation,
    String sourceTypeFieldName,
    String sourceIdFieldName,
    String sourceNameFieldName,
    String choosedSourceItemIdFieldName,
    String itemId,
    PurchaseBranchItemData item,
    int quantity,
    String addedItemMainId,
  ) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.customPageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [BlocProvider.value(value: validationCubit)],
        child: Scaffold(
          body: Column(
            children: [
              30.verticalSpace,
              Expanded(
                child: ChooseSupplierOptionsBottomSheet(
                  sourceTypeFieldName: sourceTypeFieldName,
                  sourceIdFieldName: sourceIdFieldName,
                  sourceNameFieldName: sourceNameFieldName,
                  choosedSourceItemIdFieldName: choosedSourceItemIdFieldName,
                  addedItemMainId: addedItemMainId,
                  onConfirmed: () {
                    validationCubit.validateFieldAndStoreValue(
                      fieldName: sourceIdFieldName,
                      value: useRecommendation.sourceId!,
                      isValid: true,
                    );

                    validationCubit.validateFieldAndStoreValue(
                      fieldName: choosedSourceItemIdFieldName,
                      value: itemId,
                      isValid: true,
                    );

                    validationCubit.validateFieldAndStoreValue(
                      fieldName: sourceNameFieldName,
                      value: useRecommendation.sourceName,
                      isValid: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  String getName(BuildContext context) {
    return context.tr.orderViaSupplier;
  }

  @override
  void getDetails(BuildContext context, String id) {
    super.getDetails(context, id);
    context.read<GetOrderDetailsCubit>().getDirectSupplierOrdersDetails(id: id);
  }

  @override
  Widget buildDetailsView(bool isBranchOrderTypeStrategy) {
    return const BranchDirectSupplierRequestDetailsView();
  }

  @override
  String approvalViewTitle(BuildContext context) {
    return context.tr.supplier;
  }

  @override
  Widget buildApproval(String id) {
    return const DirectSupplierRequestDetailsScreenApprovalView();
  }
}

class OfficerPurchaseSourceStrategy extends PurchaseSourceStrategy {
  @override
  Widget buildSource(
    BuildContext context,
    String sourceNameFieldName,
    String sourceTypeFieldName,
  ) {
    return BlocSelector<ValidationCubit, ValidationState, String?>(
      selector: (state) => state.fieldsValue[sourceTypeFieldName],
      builder: (context, state) {
        if (state == null || state.isEmpty) {
          return Text(
            context.tr.chooseOrderSource,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          );
        }

        return Row(
          children: [
            AppSvg(assetName: AppAssets.personSvg, width: 20.w, height: 20.w),
            10.horizontalSpace,
            Expanded(
              child: Text(
                context.tr.orderViaPurchasingOfficer,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSummary(
    BuildContext context,
    SourceLocalModel source,
    PurchaseCreateOrderRequest createOrderRequest,
    int sourceIndex,
  ) {
    return BlocProvider(
      create: (context) => getIt<GetPurchaseProductsOfficerDetailsCubit>(),
      child: PurchasingOfficerSummaryView(
        source: source,
        createOrderRequest: createOrderRequest,
        sourceIndex: sourceIndex,
        sourceType: this,
      ),
    );
  }

  @override
  Widget buildRowType(BuildContext context) {
    return RowOrderTypeWidget(
      assetName: AppAssets.personSvg,
      title: context.tr.orderViaPurchasingOfficer,
    );
  }

  @override
  void useRecommendedSource(
    BuildContext context,
    PurchaseComparePriceResponseUseRecommendation useRecommendation,
    String sourceTypeFieldName,
    String sourceIdFieldName,
    String sourceNameFieldName,
    String choosedSourceItemIdFieldName,
    String itemId,
    PurchaseBranchItemData item,
    int quantity,
    String addedItemMainId,
  ) {
    NavigationService.I.pop();

    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.customPageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<PurchasingOfficerSelectQualityCubit>(),
          ),
          BlocProvider(
            create: (context) =>
                getIt<PurchasingOfficerSelectProcessingTimeCubit>(),
          ),
          BlocProvider.value(value: validationCubit),
        ],
        child: PurchasingOfficerScreen(
          item: item,
          quantity: quantity,
          addedItemMainId: addedItemMainId,
        ),
      ),
    );
  }

  @override
  String getName(BuildContext context) {
    return context.tr.orderViaPurchasingOfficer;
  }

  @override
  void getDetails(BuildContext context, String id) {
    super.getDetails(context, id);
    context.read<GetOrderDetailsCubit>().getOfficerOrdersDetails(id: id);
  }

  @override
  Widget buildDetailsView(bool isBranchOrderTypeStrategy) {
    return const PurchasingOfficerRequestDetailsScreenDetailsView();
  }

  @override
  Widget buildApproval(String id) {
    return const PurchaseOfficerRequestDetailsScreenApprovalView();
  }

  @override
  String approvalViewTitle(BuildContext context) {
    return context.tr.officer;
  }
}
