import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../custody/data/models/custody_requests_response.dart';
import '../../../custody/presentation/cubit/custody_get_requets/custody_get_requets_cubit.dart';
import '../../../custody/presentation/cubit/custody_get_requets/custody_get_requets_state.dart';
import '../../../custody/presentation/widgets/branch_custody_request_view_item_list_widget.dart';
import '../../../custody/presentation/widgets/custody_empty_widget.dart';

class BrandOwnerRequestsCustodyRequestsView extends StatefulWidget {
  const BrandOwnerRequestsCustodyRequestsView({super.key});

  @override
  State<BrandOwnerRequestsCustodyRequestsView> createState() =>
      _BrandOwnerRequestsCustodyRequestsViewState();
}

class _BrandOwnerRequestsCustodyRequestsViewState
    extends State<BrandOwnerRequestsCustodyRequestsView> {
  @override
  void initState() {
    super.initState();

    _getCustodyRequests();
  }

  void _getCustodyRequests() {
    context.read<CustodyGetRequetsCubit>().getCustodyRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Container(
        padding: EdgeInsets.all(8.r),
        child: BlocBuilder<CustodyGetRequetsCubit, CustodyGetRequetsState>(
          builder: (context, state) {
            final requests = <CustodyRequestItem>[];

            if (state is CustodyGetRequetsLoading) {
              return const AppLoadingWidget();
            } else if (state is CustodyGetRequetsFailure) {
              return AppFailureWidget(
                failure: state.failure,
                onRetry: _getCustodyRequests,
                withBorder: false,
              );
            } else if (state is CustodyGetRequetsSuccess) {
              requests.addAll(state.requestsResponse.data.requests);
              context
                  .read<ValidationCubit>()
                  .validateFieldAndStoreTypedValue<String>(
                    fieldName: 'custodyRequestsCount',
                    value: requests.length.toString(),
                    isValid: true,
                  );
            }

            if (requests.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async => _getCustodyRequests(),
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
              onRefresh: () async => _getCustodyRequests(),
              child: ListView.builder(
                itemCount: requests.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return BranchCustodyRequestViewItemListWidget(
                    request: requests[index],
                    margin: index < requests.length - 1 ? 8.r : 0,
                    userTypeStrategy: BrandOwnerUserStrategy(),
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
