import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/brand_owner_requests_repository.dart';
import '../../../custody/presentation/widgets/custody_empty_widget.dart';
import '../../data/models/brand_owner_requests_models.dart';
import '../cubits/brand_owner_requests_custody_sales_transfers_cubit.dart';
import '../cubits/brand_owner_requests_custody_sales_transfers_state.dart';
import '../widgets/brand_owner_custody_sales_transfers_view_item_list_widget.dart';

class BrandOwnerRequestsCustodySalesTransfersView extends StatefulWidget {
  const BrandOwnerRequestsCustodySalesTransfersView({super.key});

  @override
  State<BrandOwnerRequestsCustodySalesTransfersView> createState() =>
      _BrandOwnerRequestsCustodySalesTransfersViewState();
}

class _BrandOwnerRequestsCustodySalesTransfersViewState
    extends State<BrandOwnerRequestsCustodySalesTransfersView> {
  late final BrandOwnerRequestsCustodySalesTransfersCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = BrandOwnerRequestsCustodySalesTransfersCubit(
      getIt<BrandOwnerRequestsRepository>(),
    )..getBrandOwnerRequestsCustodySalesTransfersView();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.customColor.text2,
        body: Container(
          padding: EdgeInsets.all(8.r),
          child:
              BlocBuilder<
                BrandOwnerRequestsCustodySalesTransfersCubit,
                BrandOwnerRequestsCustodySalesTransfersState
              >(
                builder: (context, state) {
                  if (state is BrandOwnerRequestsCustodySalesTransfersLoading) {
                    return const AppLoadingWidget();
                  }

                  if (state is BrandOwnerRequestsCustodySalesTransfersFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      onRetry: () => context
                          .read<BrandOwnerRequestsCustodySalesTransfersCubit>()
                          .getBrandOwnerRequestsCustodySalesTransfersView(),
                      withBorder: false,
                    );
                  }

                  final requests =
                      state is BrandOwnerRequestsCustodySalesTransfersSuccess
                      ? state.response
                      : <BrandOwnerSalesTransferItemModel>[];

                  if (requests.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async => context
                          .read<BrandOwnerRequestsCustodySalesTransfersCubit>()
                          .getBrandOwnerRequestsCustodySalesTransfersView(),
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
                    onRefresh: () async => context
                        .read<BrandOwnerRequestsCustodySalesTransfersCubit>()
                        .getBrandOwnerRequestsCustodySalesTransfersView(),
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
      ),
    );
  }
}
