import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
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
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../supplier_requests/presentation/widgets/supplier_request_branch_view.dart';
import '../../data/models/supplier_return_goods_details_response.dart';
import '../cubit/get_return_details/get_return_details_cubit.dart';
import '../cubit/get_return_details/get_return_details_state.dart';
import '../widgets/supplier_item_return_details_original_order_info_bottom_sheet_widget.dart';
import 'supplier_item_return_details_details_view.dart';

class SupplierItemReturnDetailsScreen extends StatefulWidget {
  final String returnId;

  const SupplierItemReturnDetailsScreen({super.key, required this.returnId});

  @override
  State<SupplierItemReturnDetailsScreen> createState() =>
      _SupplierItemReturnDetailsScreenState();
}

class _SupplierItemReturnDetailsScreenState
    extends State<SupplierItemReturnDetailsScreen> {
  @override
  void initState() {
    super.initState();

    _getDetails();
  }

  void _getDetails() {
    context.read<SupplierGetReturnDetailsCubit>().getReturnDetails(
      id: widget.returnId,
    );
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
                            const SupplierItemReturnDetailsOriginalOrderInfoBottomSheetWidget(),
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
              child:
                  BlocBuilder<
                    SupplierGetReturnDetailsCubit,
                    SupplierGetReturnDetailsState
                  >(
                    builder: (context, state) {
                      if (state is SupplierGetReturnDetailsLoading) {
                        return const AppLoadingWidget();
                      } else if (state is SupplierGetReturnDetailsFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          withBorder: false,
                          onRetry: _getDetails,
                        );
                      } else if (state is SupplierGetReturnDetailsSuccess) {
                        final returnDetails = state.returnDetails;

                        context
                            .read<ValidationCubit>()
                            .validateFieldAndStoreTypedValue<
                              SupplierReturnGoodsDetailsResponse
                            >(
                              fieldName: 'info',
                              value: returnDetails,
                              isValid: true,
                            );

                        return Column(
                          children: [
                            13.verticalSpace,
                            DetailsTimelinesApprovalRowButtons(
                              titles: [
                                context.tr.details,
                                context.tr.timelines,
                                context.tr.branch,
                              ],
                            ),
                            12.verticalSpace,
                            Expanded(
                              child:
                                  BlocSelector<PagingCubit, PagingState, int>(
                                    selector: (state) => state.currentIndex,
                                    builder: (context, state) {
                                      return IndexedStack(
                                        index: state,
                                        children: [
                                          SupplierItemReturnDetailsDetailsView(
                                            returnDetails: returnDetails,
                                          ),
                                          TimeLinesView(
                                            timelines: returnDetails
                                                .data
                                                .timelines
                                                .timelines,
                                          ),
                                          SupplierRequestBranchView(
                                            branch: returnDetails.data.branch,
                                            branchManager: returnDetails
                                                .data
                                                .branchManager,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                            ),
                            13.verticalSpace,
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
