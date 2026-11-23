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

class BrandOwnerRequestsCustodyRequestsView extends StatelessWidget {
  const BrandOwnerRequestsCustodyRequestsView({super.key});

  void _getCustodyRequests(BuildContext context) {
    context.read<CustodyGetRequetsCubit>().getCustodyRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Container(
        padding: EdgeInsets.all(8.r),
        child: BlocConsumer<CustodyGetRequetsCubit, CustodyGetRequetsState>(
          listenWhen: (previous, current) =>
              current is CustodyGetRequetsSuccess,
          listener: (context, state) {
            if (state is CustodyGetRequetsSuccess) {
              context
                  .read<ValidationCubit>()
                  .validateFieldAndStoreTypedValue<String>(
                    fieldName: 'custodyRequestsCount',
                    value: state.requestsResponse.data.requests.length
                        .toString(),
                    isValid: true,
                  );
            }
          },
          builder: (context, state) {
            final requests = <CustodyRequestItem>[];

            if (state is CustodyGetRequetsLoading) {
              return const AppLoadingWidget();
            } else if (state is CustodyGetRequetsFailure) {
              return AppFailureWidget(
                failure: state.failure,
                onRetry: () => _getCustodyRequests(context),
                withBorder: false,
              );
            } else if (state is CustodyGetRequetsSuccess) {
              requests.addAll(state.requestsResponse.data.requests);
            }

            if (requests.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async => _getCustodyRequests(context),
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
              onRefresh: () async => _getCustodyRequests(context),
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
