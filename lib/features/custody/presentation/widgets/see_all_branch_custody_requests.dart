import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/features/custody/presentation/cubit/custody_get_requets/custody_get_requets_cubit.dart';
import 'package:assab/features/custody/presentation/widgets/branch_custody_request_view_item_list_widget.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strategies/user_type_strategy.dart';
import '../../data/models/custody_requests_response.dart';
import '../cubit/custody_get_requets/custody_get_requets_state.dart';
import '../cubit/select_filter_custody_requests/select_filter_custody_requests_cubit.dart';
import 'branch_custody_requests_filter_bottom_sheet_widget.dart';
import 'custody_empty_widget.dart';

class SeeAllBranchCustodyRequests extends StatefulWidget {
  const SeeAllBranchCustodyRequests({super.key});

  @override
  State<SeeAllBranchCustodyRequests> createState() =>
      _SeeAllBranchCustodyRequestsState();
}

class _SeeAllBranchCustodyRequestsState
    extends State<SeeAllBranchCustodyRequests> {
  @override
  void initState() {
    super.initState();

    _getCustodyRequests();
  }

  void _getCustodyRequests() {
    context.read<CustodyGetRequetsCubit>().getCustodyRequests();
  }

  void _onTapFilter(BuildContext context) {
    final custodyGetRequestsCubit = context.read<CustodyGetRequetsCubit>();
    AppBottomSheet.pageRoute(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<SelectFilterCustodyRequestsCubit>(),
          ),
          BlocProvider.value(value: custodyGetRequestsCubit),
        ],
        child: const BranchCustodyRequestsFilterBottomSheetWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child:
                    BlocSelector<
                      CustodyGetRequetsCubit,
                      CustodyGetRequetsState,
                      int
                    >(
                      selector: (state) => state is CustodyGetRequetsSuccess
                          ? state.requestsResponse.data.requests.length
                          : 0,
                      builder: (context, state) {
                        return CustodyAppBar(
                          title: '${context.tr.custodyRequests} ($state)',
                          subtitle:
                              context.tr.manageSortAndViewDetailsOfRequests,
                          titleStyle: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                          iconColor: context.customColor.text1,
                        );
                      },
                    ),
              ),
              10.horizontalSpace,
              AppSvgButton(
                assetName: AppAssets.filter,
                onTap: () => _onTapFilter(context),
                bgColor: context.customColor.reversedTextColor,
                iconColor: context.customColor.text1,
                withBorder: false,
                padding: EdgeInsets.all(15.r),
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
              padding: EdgeInsets.all(8.r),
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(24.r),
                ),
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
                    }

                    if (requests.isEmpty) {
                      return CustodyEmptyWidget(
                        asset: AppAssets.custodyPng,
                        title: context.tr.noRequestsYet,
                        desc: context
                            .tr
                            .youHaveNotSentAnyCustodyRequestsToStoreOwnerForApprovals,
                      );
                    }

                    return ListView.builder(
                      itemCount: requests.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return BranchCustodyRequestViewItemListWidget(
                          request: requests[index],
                          margin: index < requests.length - 1 ? 8.r : 0,
                          userTypeStrategy: BranchManagerUserStrategy(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
