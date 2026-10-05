import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/strategies/purchase_source_strategy.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../purchase/data/models/draft_order_data.dart';
import '../../../purchase/data/models/purchase_branch_items_response.dart';
import '../../../purchase/domain/strategies/create_order_strategy.dart';
import '../../../purchase/presentation/cubit/add_item_purchase/add_item_purchase_cubit.dart';
import '../../../purchase/presentation/cubit/delete_order_draft/delete_order_draft_cubit.dart';
import '../../../purchase/presentation/cubit/get_purchase_branch_items/get_purchase_branch_items_cubit.dart';
import '../../../purchase/presentation/screens/purchase_screen.dart';
import '../cubit/get_order_details/get_order_details_cubit.dart';
import '../cubit/get_order_details/get_order_details_state.dart';
import '../widgets/branch_request_delete_draft_bottom_sheet.dart';

class OrderDraftDetailsScreen extends StatefulWidget {
  final String id;
  final PurchaseSourceStrategy strategy;

  const OrderDraftDetailsScreen({
    super.key,
    required this.id,
    required this.strategy,
  });

  @override
  State<OrderDraftDetailsScreen> createState() =>
      _OrderDraftDetailsScreenState();
}

class _OrderDraftDetailsScreenState extends State<OrderDraftDetailsScreen> {
  @override
  void initState() {
    super.initState();

    _getDetails();
  }

  void _getDetails() {
    widget.strategy.getDetails(context, widget.id);
  }

  DraftOrderData? _extractDraftData(GetOrderDetailsState state) {
    if (state is GetBranchOrderDetailsSuccess) {
      return DraftOrderData.fromBranchDetails(
        orderId: widget.id,
        response: state.orderDetails,
      );
    } else if (state is GetDirectSupplierOrderDetailsSuccess) {
      return DraftOrderData.fromDirectSupplierDetails(
        orderId: widget.id,
        response: state.orderDetails,
      );
    } else if (state is GetOfficerOrderDetailsSuccess) {
      return DraftOrderData.fromOfficerDetails(
        orderId: widget.id,
        response: state.orderDetails,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPaddingWidget(
            top: 40.r,
            bottom: 0,
            child: BlocBuilder<GetOrderDetailsCubit, GetOrderDetailsState>(
              builder: (context, state) {
                if (state is GetOrderDetailsLoading) {
                  return const AppLoadingWidget();
                } else if (state is GetOrderDetailsFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: _getDetails,
                    withBorder: false,
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.purchaseRequestDetails,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      context
                          .tr
                          .viewEveryActionAndUpdateMadeToThisRequestFromCreationToFinalApproval,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    // 18.verticalSpace,
                    // Text(
                    //   context.tr.youSavedThisRequestToDraftOn(
                    //     '12 Aug, 2023 - 10:30 AM',
                    //   ),
                    //   style: AppStyles.s13W500.copyWith(
                    //     color: context.theme.primaryColor,
                    //   ),
                    // ),
                    14.verticalSpace,
                    const CustomDivider(),
                    14.verticalSpace,
                  ],
                );
              },
            ),
          ),
          Expanded(child: widget.strategy.buildDetailsView(true)),
          AppPaddingWidget(
            top: 0,
            child: Row(
              children: [
                Expanded(
                  child: ButtonTextIcon(
                    onTap: () {
                      final detailsState = context
                          .read<GetOrderDetailsCubit>()
                          .state;

                      final draftData = _extractDraftData(detailsState);

                      if (draftData == null) return;

                      final strategy = UpdateDraftOrderCreateOrderStrategy(
                        draftData: draftData,
                      );

                      NavigationService.I.push(
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) =>
                                    getIt<AddItemPurchaseCubit>(),
                              ),
                              BlocProvider(
                                create: (context) =>
                                    ValidationCubit(requiredFields: {'items'}),
                              ),
                              BlocProvider(
                                create: (context) =>
                                    getIt<GetPurchaseBranchItemsCubit>(),
                              ),
                              BlocProvider(
                                create: (context) =>
                                    SearchCubit<PurchaseBranchItemData>(),
                              ),
                              BlocProvider(
                                create: (context) => PagingCubit(totalSteps: 2),
                              ),
                            ],
                            child: PurchaseScreen(strategy: strategy),
                          ),
                        ),
                      );
                    },
                    label: context.tr.continueEditing,
                    icon: AppSvg(
                      assetName: AppAssets.edit,
                      width: 16.r,
                      colorFilter: ColorFilter.mode(
                        context.customColor.reversedTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    textColor: context.customColor.reversedTextColor,
                    backgroundColor: context.theme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 13.r),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: ButtonTextIcon(
                    onTap: () {
                      AppBottomSheet.showModal(
                        context,
                        (context) => BlocProvider(
                          create: (context) => getIt<DeleteOrderDraftCubit>(),
                          child: BranchRequestDeleteDraftBottomSheet(
                            id: widget.id,
                          ),
                        ),
                      );
                    },
                    label: context.tr.delete,
                    textColor: context.customColor.error,
                    icon: AppSvg(
                      assetName: AppAssets.trashSvg,
                      width: 16.r,
                      colorFilter: ColorFilter.mode(
                        context.customColor.error,
                        BlendMode.srcIn,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 13.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
