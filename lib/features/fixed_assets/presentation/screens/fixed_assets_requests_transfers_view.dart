import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/fixed_assets_transfers_requests_response.dart';
import '../cubit/fixed_assets_get_requests/fixed_assets_get_requests_cubit.dart';
import '../widgets/fixed_assets_view_details_request_button.dart';

class FixedAssetsRequestsTransfersView extends StatefulWidget {
  const FixedAssetsRequestsTransfersView({super.key});

  @override
  State<FixedAssetsRequestsTransfersView> createState() =>
      _FixedAssetsRequestsTransfersViewState();
}

class _FixedAssetsRequestsTransfersViewState
    extends State<FixedAssetsRequestsTransfersView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _getTransfersRequests();

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
              .transfersRequestsPaginator
              .hasMore) {
        _getTransfersRequests(loadMore: true);
      }
    });
  }

  void _getTransfersRequests({bool loadMore = false}) {
    context.read<FixedAssetsGetRequestsCubit>().fetchTransfersRequests(
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
          current is FixedAssetsGetTransfersRequestsLoading ||
          current is FixedAssetsGetTransfersRequestsSuccess ||
          current is FixedAssetsGetTransfersRequestsFailure,
      builder: (context, state) {
        final requests = <FixedAssetsTransfersRequestsItem>[];

        if (state is FixedAssetsGetTransfersRequestsLoading) {
          return const AppLoadingWidget();
        } else if (state is FixedAssetsGetTransfersRequestsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () => _getTransfersRequests(),
          );
        } else if (state is FixedAssetsGetTransfersRequestsSuccess) {
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
              _getTransfersRequests();
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
                              request.type.label(context),
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
                        '(${request.dateAndTime})',
                        style: AppStyles.s10W500.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      5.verticalSpace,
                      request.condition.buildConditionWidget(context),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: FixedAssetsViewDetailsRequestButton(
                      //         onPressed: () {
                      //           NavigationService.I.pushNamed(
                      //             AppRouteName.fixedAssetsTransferDetailsScreen,
                      //             arguments: request.id,
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //     10.horizontalSpace,
                      //     Expanded(
                      //       child: ButtonTextIcon(
                      //         onTap: () {
                      //           NavigationService.I.pushNamed(
                      //             AppRouteName.fixedAssetsReceiveAssetsScreen,
                      //             arguments: {
                      //               'type': request.type,
                      //               'requestId': request.id,
                      //             },
                      //           );
                      //         },
                      //         label: context.tr.approve,
                      //         textColor: context.customColor.reversedTextColor,
                      //         backgroundColor: context.theme.primaryColor,
                      //         borderRadius: BorderRadius.circular(1000.r),
                      //         padding: EdgeInsets.symmetric(vertical: 11.r),
                      //         icon: AppSvg(
                      //           assetName: AppAssets.check,
                      //           colorFilter: ColorFilter.mode(
                      //             context.customColor.reversedTextColor,
                      //             BlendMode.srcIn,
                      //           ),
                      //           width: 16.w,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      request.status.buildButtonsTransferWidget(
                        context,
                        request.type,
                        requestId: request.id,
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
