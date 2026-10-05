import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strategies/requests_order_type_strategy.dart';
import '../cubit/get_order_details/get_order_details_cubit.dart';
import '../cubit/get_order_details/get_order_details_state.dart';
import 'branch_direct_supplier_details_screen_product_details_section.dart';
import 'branch_direct_supplier_details_screen_request_summary_section.dart';

class BranchDirectSupplierRequestDetailsView extends StatelessWidget {
  const BranchDirectSupplierRequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOrderDetailsCubit, GetOrderDetailsState>(
      buildWhen: (previous, current) =>
          current is GetDirectSupplierOrderDetailsSuccess,
      builder: (context, state) {
        if (state is GetDirectSupplierOrderDetailsSuccess) {
          final details = state.orderDetails;

          return AppPaddingWidget(
            top: 0,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      details.requestSummary.status
                          .buildRejectedWidgetForOrder(
                            context,
                            details.requestSummary.reasonForRejected,
                          )
                          .sliverBoxAdapter,
                      details.requestSummary.status
                          .buildModificationDetailsDelayRequest(
                            context,
                            DirectSupplierRequestTypeStrategy(
                              details.requestSummary.status,
                              details: details,
                            ),
                          )
                          .sliverBoxAdapter,
                      BranchDirectSupplierDetailsScreenRequestSummarySection(
                        totalAmount: details.requestSummary.totalAmount
                            .toString(),
                        details: details,
                      ).sliverBoxAdapter,
                      12.verticalSpace.sliverBoxAdapter,
                      Text(
                        context.tr.productDetails,
                        style: AppStyles.s14W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ).sliverBoxAdapter,
                      10.verticalSpace.sliverBoxAdapter,
                      const CustomDivider().sliverBoxAdapter,
                      10.verticalSpace.sliverBoxAdapter,
                      BranchDirectSupplierDetailsScreenProductDetailsSection(
                        items: details.productDetails,
                        orderId: details.requestSummary.id,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                DirectSupplierRequestTypeStrategy(
                  details.requestSummary.status,
                  details: details,
                ).buildButtonsDetails(context),
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
