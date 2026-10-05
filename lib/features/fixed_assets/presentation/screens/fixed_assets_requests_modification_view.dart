import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../data/models/fixed_assets_modification_requests_response.dart';
import '../cubit/fixed_assets_get_requests/fixed_assets_get_requests_cubit.dart';
import '../cubit/get_requests_details/get_requests_details_cubit.dart';
import '../widgets/fixed_assets_view_details_request_button.dart';
import 'fixed_assets_modification_details_screen.dart';

class FixedAssetsRequestsModificationView extends StatefulWidget {
  const FixedAssetsRequestsModificationView({super.key});

  @override
  State<FixedAssetsRequestsModificationView> createState() =>
      _FixedAssetsRequestsModificationViewState();
}

class _FixedAssetsRequestsModificationViewState
    extends State<FixedAssetsRequestsModificationView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _getModificationRequests();

    _scrollController = ScrollController();
    _setupScrollControllerListener();
  }

  void _setupScrollControllerListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
                  _scrollController.position.pixels <=
              300.h &&
          context
              .read<FixedAssetsGetRequestsCubit>()
              .modificationRequestsPaginator
              .hasMore) {
        _getModificationRequests(loadMore: true);
      }
    });
  }

  void _getModificationRequests({bool loadMore = false}) {
    context.read<FixedAssetsGetRequestsCubit>().fetchModificationRequests(
      loadMore: loadMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      FixedAssetsGetRequestsCubit,
      FixedAssetsGetRequestsState
    >(
      buildWhen: (previous, current) =>
          current is FixedAssetsGetModificationRequestsLoading ||
          current is FixedAssetsGetModificationRequestsSuccess ||
          current is FixedAssetsGetModificationRequestsFailure,
      builder: (context, state) {
        final requests = <FixedAssetsModificationRequestsItem>[];

        if (state is FixedAssetsGetModificationRequestsLoading) {
          return const AppLoadingWidget();
        } else if (state is FixedAssetsGetModificationRequestsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () => _getModificationRequests(),
          );
        } else if (state is FixedAssetsGetModificationRequestsSuccess) {
          requests.addAll(state.response);
        }

        if (requests.isEmpty) {
          return Center(
            child: Text(
              context.tr.noRequestsYet,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text3,
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.all(8.r),
          child: RefreshIndicator(
            onRefresh: () async {
              _getModificationRequests();
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: requests.length,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final request = requests[index];

                return Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(8.r),
                  margin: EdgeInsets.only(
                    bottom: index == requests.length - 1 ? 0 : 10.r,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.tr.modifyAssetStatus,
                              style: AppStyles.s13W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          request.status.buildStatusWidget(context),
                        ],
                      ),
                      5.verticalSpace,
                      Text(
                        request.assetName,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      FixedAssetsViewDetailsRequestButton(
                        onPressed: () {
                          NavigationService.I.push(
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (_) => PagingCubit(totalSteps: 2),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        getIt<GetRequestsDetailsCubit>()
                                          ..getModifyDetails(
                                            requestId: request.id,
                                          ),
                                  ),
                                ],
                                child: FixedAssetsModificationDetailsScreen(
                                  requestId: request.id,
                                  userTypeStrategy: BranchManagerUserStrategy(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
