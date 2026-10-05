import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../cubit/get_order_details/get_order_details_cubit.dart';
import '../cubit/get_order_details/get_order_details_state.dart';
import 'purchasing_officer_request_screen_product_details_section.dart';
import 'purchasing_officer_request_screen_request_summary_section.dart';

class PurchasingOfficerRequestDetailsScreenDetailsView extends StatelessWidget {
  const PurchasingOfficerRequestDetailsScreenDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetOrderDetailsCubit, GetOrderDetailsState>(
      buildWhen: (previous, current) =>
          current is GetOfficerOrderDetailsSuccess,
      builder: (context, state) {
        if (state is GetOfficerOrderDetailsSuccess) {
          final details = state.orderDetails;

          return AppPaddingWidget(
            top: 0,
            child: CustomScrollView(
              slivers: [
                PurchasingOfficerRequestScreenRequestSummarySection(
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
                PurchasingOfficerRequestScreenProductDetailsSection(
                  details: details,
                ),
                8.verticalSpace.sliverBoxAdapter,
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffE51B92),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.r,
                    horizontal: 20.r,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.tr.totalExpectedSavings,
                          style: AppStyles.s13W400.copyWith(
                            color: context.customColor.reversedTextColor,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      SaudiRiyalSvgWidget(
                        color: context.customColor.reversedTextColor,
                      ),
                      Text(
                        ' ${details.requestSummary.totalPrice}',
                        style: AppStyles.s13WB.copyWith(
                          color: context.customColor.reversedTextColor,
                        ),
                      ),
                    ],
                  ),
                ).sliverBoxAdapter,
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
