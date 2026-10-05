import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strategies/requests_order_type_strategy.dart';
import '../../data/models/supplier_order_details_response.dart';
import '../cubit/supplier_get_request_details/supplier_get_request_details_cubit.dart';
import '../cubit/supplier_get_request_details/supplier_get_request_details_state.dart';
import 'supplier_details_screen_product_details_section.dart';
import 'supplier_details_screen_request_summary_section.dart';

class SupplierRequestDetailsView extends StatelessWidget {
  final SupplierOrderDetailsResponse details;

  const SupplierRequestDetailsView({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      SupplierGetRequestDetailsCubit,
      SupplierGetRequestDetailsState
    >(
      builder: (context, state) {
        return AppPaddingWidget(
          top: 0,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    details.data.status
                        .buildRejectedWidgetForOrder(
                          context,
                          details.reasonForRejected,
                        )
                        .sliverBoxAdapter,
                    details.data.status
                        .buildModificationDetailsDelayRequest(
                          context,
                          SupplierRequestTypeStrategy(
                            details.data.status,
                            request: details,
                          ),
                        )
                        .sliverBoxAdapter,
                    SupplierDetailsScreenRequestSummarySection(
                      totalAmount: details.data.totalAmount.toStringAsFixed(2),
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
                    SupplierDetailsScreenProductDetailsSection(
                      items: details.data.items,
                      orderId: details.data.id,
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              SupplierRequestTypeStrategy(
                details.data.status,
                request: details,
              ).buildButtonsDetails(context),
            ],
          ),
        );
      },
    );
  }
}
