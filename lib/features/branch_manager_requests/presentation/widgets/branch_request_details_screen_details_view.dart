import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strategies/requests_order_type_strategy.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../cubit/get_order_details/get_order_details_cubit.dart';
import '../cubit/get_order_details/get_order_details_state.dart';
import 'branch_request_details_product_details_section.dart';
import 'branch_request_details_request_summary_section.dart';

class BranchRequestDetailsScreenDetailsView extends StatelessWidget {
  final bool isBranchOrderTypeStrategy;

  const BranchRequestDetailsScreenDetailsView({
    super.key,
    required this.isBranchOrderTypeStrategy,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOrderDetailsCubit, GetOrderDetailsState>(
      buildWhen: (previous, current) => current is GetBranchOrderDetailsSuccess,
      builder: (context, state) {
        if (state is GetBranchOrderDetailsSuccess) {
          final orderDetails = state.orderDetails;

          return AppPaddingWidget(
            top: 0,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      BranchRequestDetailsRequestSummarySection(
                        requestSummary: orderDetails.data.requestSummary,
                      ).sliverBoxAdapter,
                      if (orderDetails.data.requestSummary.justification !=
                              null &&
                          orderDetails
                              .data
                              .requestSummary
                              .justification!
                              .isNotEmpty)
                        Column(
                          children: [
                            12.verticalSpace,
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.all(16.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr.justification,
                                    style: AppStyles.s16W600.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                  8.verticalSpace,
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: context.customColor.text2,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    padding: EdgeInsets.all(16.r),
                                    child: Text(
                                      orderDetails
                                          .data
                                          .requestSummary
                                          .justification!,
                                      style: AppStyles.s14W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).sliverBoxAdapter,
                      12.verticalSpace.sliverBoxAdapter,
                      Text(
                        '${context.tr.productDetails} (${orderDetails.data.productDetails.length})',
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ).sliverBoxAdapter,
                      10.verticalSpace.sliverBoxAdapter,
                      const CustomDivider().sliverBoxAdapter,
                      10.verticalSpace.sliverBoxAdapter,
                      BranchRequestDetailsProductDetailsSection(
                        productDetails: orderDetails.data.productDetails,
                      ),
                    ],
                  ),
                ),
                if (isBranchOrderTypeStrategy) ...[
                  20.verticalSpace,
                  BranchOrderTypeStrategy(
                    orderDetails.data.requestSummary.status,
                    orderId: orderDetails.data.requestSummary.id,
                  ).buildButtonsDetails(context),
                ],
              ],
            ),
          );
        } else if (state is GetOrderDetailsFailure) {
          return AppFailureWidget(failure: state.failure);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
