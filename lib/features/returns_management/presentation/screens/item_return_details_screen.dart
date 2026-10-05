import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/details_timelines_approval_row_buttons.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../brand_owner_requests/presentation/cubits/branch_owner_approve_reject_cubit.dart';
import '../../../brand_owner_requests/presentation/cubits/branch_owner_approve_reject_state.dart';
import '../../data/models/return_goods_details_response.dart';
import '../../domain/strategies/item_return_status_strategy.dart';
import '../cubit/get_return_details/get_return_details_cubit.dart';
import '../cubit/get_return_details/get_return_details_state.dart';
import '../widgets/item_return_details_details_view.dart';
import '../widgets/item_return_details_original_order_info_bottom_sheet_widget.dart';
import '../widgets/item_return_details_supplier_view.dart';

class ItemReturnDetailsScreen extends StatefulWidget {
  final String returnId;
  final UserTypeStrategy? role;
  final void Function()? onEscalationUpdated;

  const ItemReturnDetailsScreen({
    super.key,
    required this.returnId,
    this.role,
    this.onEscalationUpdated,
  });

  @override
  State<ItemReturnDetailsScreen> createState() =>
      _ItemReturnDetailsScreenState();
}

class _ItemReturnDetailsScreenState extends State<ItemReturnDetailsScreen> {
  @override
  void initState() {
    super.initState();

    _getDetails();
  }

  void _getDetails() {
    context.read<GetReturnDetailsCubit>().getReturnDetails(id: widget.returnId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: PurchaseAppBar(
                  title: context.tr.itemReturnDetails,
                  subtitle: context.tr.viewDetailsTimelinesAndStatuses,
                  titleColor: context.customColor.text1,
                  iconColor: context.customColor.text1,
                ),
              ),
              10.horizontalSpace,
              if (widget.role == null)
                AppSvgButton(
                  assetName: AppAssets.receipt,
                  onTap: () {
                    final validationCubit = context.read<ValidationCubit>();

                    AppBottomSheet.pageRoute(
                      context,
                      (context) => Expanded(
                        child: BlocProvider.value(
                          value: validationCubit,
                          child:
                              const ItemReturnDetailsOriginalOrderInfoBottomSheetWidget(),
                        ),
                      ),
                    );
                  },
                  bgColor: context.customColor.reversedTextColor,
                  withBorder: false,
                  iconColor: context.customColor.text1,
                ),
              20.horizontalSpace,
            ],
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 13.r),
              child: BlocBuilder<GetReturnDetailsCubit, GetReturnDetailsState>(
                builder: (context, state) {
                  if (state is GetReturnDetailsLoading) {
                    return const AppLoadingWidget();
                  } else if (state is GetReturnDetailsFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      withBorder: false,
                      onRetry: _getDetails,
                    );
                  } else if (state is GetReturnDetailsSuccess) {
                    final returnDetails = state.returnDetails;

                    context
                        .read<ValidationCubit>()
                        .validateFieldAndStoreTypedValue<
                          ReturnGoodsDetailsResponse
                        >(
                          fieldName: 'info',
                          value: returnDetails,
                          isValid: true,
                        );

                    return Column(
                      children: [
                        DetailsTimelinesApprovalRowButtons(
                          titles: [
                            context.tr.details,
                            context.tr.timelines,
                            context.tr.supplier,
                          ],
                        ),
                        12.verticalSpace,
                        Expanded(
                          child: BlocSelector<PagingCubit, PagingState, int>(
                            selector: (state) => state.currentIndex,
                            builder: (context, state) {
                              return IndexedStack(
                                index: state,
                                children: [
                                  ItemReturnDetailsDetailsView(
                                    returnDetails: returnDetails,
                                  ),
                                  TimeLinesView(
                                    timelines:
                                        returnDetails.data.timelines.timelines,
                                  ),
                                  ItemReturnDetailsSupplierView(
                                    returnDetails: returnDetails,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        if (widget.role is BrandOwnerUserStrategy &&
                            returnDetails.data.status
                                is PendingResolutionItemReturnStatusStrategy) ...[
                          20.verticalSpace,
                          BlocProvider(
                            create: (context) =>
                                getIt<BranchOwnerApproveRejectCubit>(),
                            child:
                                BlocListener<
                                  BranchOwnerApproveRejectCubit,
                                  BranchOwnerApproveRejectState
                                >(
                                  listener: (context, state) {
                                    if (state
                                        is BranchOwnerApproveRejectEscalationSuccess) {
                                      _getDetails();
                                      widget.onEscalationUpdated?.call();
                                    } else if (state
                                        is BranchOwnerApproveRejectFailure) {
                                      AppDialog.showErrorDialog(
                                        context: context,
                                        failure: state.failure,
                                      );
                                    }
                                  },
                                  child:
                                      BlocBuilder<
                                        BranchOwnerApproveRejectCubit,
                                        BranchOwnerApproveRejectState
                                      >(
                                        builder: (context, state) {
                                          if (state
                                              is BranchOwnerApproveRejectLoading) {
                                            return const AppButtonLoading();
                                          }

                                          return Row(
                                            children: [
                                              Expanded(
                                                child: CustomTextButton(
                                                  text: context.tr.reject,
                                                  onTap: () {
                                                    context
                                                        .read<
                                                          BranchOwnerApproveRejectCubit
                                                        >()
                                                        .rejectEscalation(
                                                          returnId:
                                                              widget.returnId,
                                                        );
                                                  },
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 16.r,
                                                  ),
                                                  textColor:
                                                      context.customColor.error,
                                                  borderRadius: 20.r,
                                                ),
                                              ),
                                              12.horizontalSpace,
                                              Expanded(
                                                child: CustomTextButton(
                                                  text: context.tr.approve,
                                                  onTap: () {
                                                    context
                                                        .read<
                                                          BranchOwnerApproveRejectCubit
                                                        >()
                                                        .approveEscalation(
                                                          returnId:
                                                              widget.returnId,
                                                        );
                                                  },
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 16.r,
                                                  ),
                                                  textColor: context
                                                      .customColor
                                                      .reversedTextColor,
                                                  borderRadius: 20.r,
                                                  backgroundColor: context
                                                      .theme
                                                      .primaryColor,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                ),
                          ),
                        ],
                      ],
                    );
                  }

                  return AppLocalFailure(
                    onRetry: _getDetails,
                    withBorder: false,
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
