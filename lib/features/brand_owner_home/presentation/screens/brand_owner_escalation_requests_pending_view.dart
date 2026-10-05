import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../returns_management/data/models/return_goods_response.dart';
import '../../../returns_management/presentation/widgets/returns_management_empty_widget.dart';
import '../cubit/get_completed_escelations/get_completed_escelations_cubit.dart';
import '../cubit/get_pending_escelations/get_pending_escelations_cubit.dart';
import '../cubit/get_pending_escelations/get_pending_escelations_state.dart';

class BrandOwnerEscalationRequestsPendingView extends StatelessWidget {
  const BrandOwnerEscalationRequestsPendingView({super.key});

  void _loadData(BuildContext context) {
    context.read<GetPendingEscelationsCubit>().getInprogressEscelations();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPendingEscelationsCubit, GetPendingEscelationsState>(
      builder: (context, state) {
        final returns = <ReturnGoodsData>[];

        if (state is GetPendingEscelationsLoading) {
          return const AppLoadingWidget();
        } else if (state is GetPendingEscelationsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () {
              _loadData(context);
            },
            withBorder: false,
          );
        } else if (state is GetPendingEscelationsSuccess) {
          returns.addAll(state.returns.data);
        }

        if (returns.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: () async => _loadData(context),
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: ReturnsManagementEmptyWidget(
                      image: AppAssets.pendingPng,
                      title: context.tr.noReturnsInProgressYet,
                      description: context
                          .tr
                          .onceYouStartReturningAnItemItllAppearHereForTrackingAndFollowUp,
                    ),
                  ),
                ),
              );
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _loadData(context),
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: ListView.builder(
              itemCount: returns.length,
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final returnItem = returns[index];

                return AppGestureDetectorButton(
                  onTap: () {
                    NavigationService.I.pushNamed(
                      AppRouteName.itemReturnDetailsScreen,
                      arguments: {
                        'returnId': returnItem.id,
                        'role': BrandOwnerUserStrategy(),
                        'onEscalationUpdated': () {
                          context
                              .read<GetPendingEscelationsCubit>()
                              .getInprogressEscelations();
                          context
                              .read<GetCompletedEscelationsCubit>()
                              .getCompletedEscelations();
                        },
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    margin: EdgeInsets.only(bottom: 4.r),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.r,
                      horizontal: 20.r,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                returnItem.returnNumber,
                                style: AppStyles.s13W600.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              Row(
                                children: [
                                  AppSvg(
                                    assetName: AppAssets.returnsManagement,
                                    width: 12.r,
                                    colorFilter: ColorFilter.mode(
                                      context.customColor.text3,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  6.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      context.tr.goodsReturns,
                                      style: AppStyles.s12W400.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${DateFormatter.formatDateMDY(DateTime.tryParse(returnItem.createdAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(returnItem.createdAt))}',
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        returnItem.status.buildStatusWidget(context),
                      ],
                    ),
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
