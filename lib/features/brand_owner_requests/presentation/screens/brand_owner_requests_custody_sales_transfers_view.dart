import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../custody/presentation/widgets/custody_empty_widget.dart';
import '../../data/models/brand_owner_requests_models.dart';
import '../cubits/brand_owner_requests_custody_sales_transfers_cubit.dart';
import '../cubits/brand_owner_requests_custody_sales_transfers_state.dart';
import '../widgets/brand_owner_custody_sales_transfers_view_item_list_widget.dart';

class BrandOwnerRequestsCustodySalesTransfersView extends StatelessWidget {
  const BrandOwnerRequestsCustodySalesTransfersView({super.key});

  void _refresh(BuildContext context) {
    context
        .read<BrandOwnerRequestsCustodySalesTransfersCubit>()
        .getBrandOwnerRequestsCustodySalesTransfersView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Container(
        padding: EdgeInsets.all(8.r),
        child:
            BlocConsumer<
              BrandOwnerRequestsCustodySalesTransfersCubit,
              BrandOwnerRequestsCustodySalesTransfersState
            >(
              listenWhen: (previous, current) =>
                  current is BrandOwnerRequestsCustodySalesTransfersSuccess,
              listener: (context, state) {
                if (state is BrandOwnerRequestsCustodySalesTransfersSuccess) {
                  context
                      .read<ValidationCubit>()
                      .validateFieldAndStoreTypedValue<String>(
                        fieldName: 'salesTransfersCount',
                        value: state.response.length.toString(),
                        isValid: true,
                      );
                }
              },
              builder: (context, state) {
                if (state is BrandOwnerRequestsCustodySalesTransfersLoading) {
                  return const AppLoadingWidget();
                }

                if (state is BrandOwnerRequestsCustodySalesTransfersFailure) {
                  return AppFailureWidget(
                    failure: state.failure,
                    onRetry: () => _refresh(context),
                    withBorder: false,
                  );
                }

                final requests =
                    state is BrandOwnerRequestsCustodySalesTransfersSuccess
                    ? state.response
                    : <BrandOwnerSalesTransferItemModel>[];

                if (requests.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async => _refresh(context),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: CustodyEmptyWidget(
                              asset: AppAssets.custodyPng,
                              title: context.tr.noRequestsYet,
                              desc: context
                                  .tr
                                  .youHaveNotSentAnyCustodyRequestsToStoreOwnerForApprovals,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _refresh(context),
                  child: ListView.builder(
                    itemCount: requests.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return BrandOwnerCustodySalesTransfersViewItemListWidget(
                        request: requests[index],
                        margin: index < requests.length - 1 ? 8.r : 0,
                      );
                    },
                  ),
                );
              },
            ),
      ),
    );
  }
}
