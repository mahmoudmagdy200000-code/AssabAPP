import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/purchase_product_branch_details_response.dart';
import '../../data/models/source_local_model.dart';
import '../cubit/get_purchase_products_branch_details/get_purchase_products_branch_details_cubit.dart';
import '../cubit/get_purchase_products_branch_details/get_purchase_products_branch_details_state.dart';

class ChooseBranchSummaryViewTransportDetailsSection extends StatelessWidget {
  final SourceLocalModel branch;

  const ChooseBranchSummaryViewTransportDetailsSection({
    super.key,
    required this.branch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 16.r),
      child:
          BlocBuilder<
            GetPurchaseProductsBranchDetailsCubit,
            GetPurchaseProductsBranchDetailsState
          >(
            builder: (context, state) {
              PurchaseProductBranchDetailsTransportSummary?
              purchaseProductBranchDetailsTransportSummary;

              if (state is GetPurchaseProductsBranchDetailsLoading) {
                return const AppLoadingWidget();
              } else if (state is GetPurchaseProductsBranchDetailsFailure) {
                return AppFailureWidget(
                  failure: state.failure,
                  withBorder: false,
                  onRetry: () {
                    context
                        .read<GetPurchaseProductsBranchDetailsCubit>()
                        .getPurchaseProductsBranchDetails(
                          branchId: branch.sourceId,
                        );
                  },
                ).sliverBoxAdapter;
              } else if (state is GetPurchaseProductsBranchDetailsSuccess) {
                purchaseProductBranchDetailsTransportSummary =
                    state.purchaseProductBranchDetailsResponse.transportSummary;
              }

              if (purchaseProductBranchDetailsTransportSummary == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  Row(
                    children: [
                      AppSvg(
                        assetName: AppAssets.transport,
                        width: 20.w,
                        height: 20.w,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          context.tr.transportDetails,
                          style: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  _buildDetailRow(
                    context,
                    context.tr.method,
                    '${purchaseProductBranchDetailsTransportSummary.method} (${purchaseProductBranchDetailsTransportSummary.cost})',
                  ),
                  8.verticalSpace,
                  const CustomDivider(),
                  8.verticalSpace,
                  _buildDetailRow(
                    context,
                    context.tr.estimatedDeliveryTime,
                    '${purchaseProductBranchDetailsTransportSummary.estimatedTimeHours} hours',
                  ),
                  8.verticalSpace,
                  const CustomDivider(),
                  8.verticalSpace,
                  _buildDetailRow(
                    context,
                    context.tr.driver,
                    purchaseProductBranchDetailsTransportSummary.driver
                        .toString(),
                  ),
                  8.verticalSpace,
                  const CustomDivider(),
                  8.verticalSpace,
                  _buildDetailRow(
                    context,
                    context.tr.temperature,
                    'Chilled (-2°C to 4°C)',
                  ),
                ],
              );
            },
          ),
    ).sliverBoxAdapter;
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
