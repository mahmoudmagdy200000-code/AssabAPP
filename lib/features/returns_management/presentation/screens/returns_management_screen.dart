import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/returns_management/presentation/cubit/get_returns/get_returns_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../data/models/return_goods_response.dart';
import '../../domain/strategies/returns_management_strategy.dart';
import '../cubit/get_returns/get_returns_cubit.dart';
import '../widgets/returns_managment_app_bar.dart';

class ReturnsManagementScreen extends StatefulWidget {
  const ReturnsManagementScreen({super.key});

  @override
  State<ReturnsManagementScreen> createState() =>
      _ReturnsManagementScreenState();
}

class _ReturnsManagementScreenState extends State<ReturnsManagementScreen> {
  @override
  void initState() {
    super.initState();

    _strategies[0].get(context);
  }

  List<ReturnsManagementStrategy> get _strategies => [
    InProgressReturnsManagementStrategy(),
    CompletedReturnsManagementStrategy(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          const ReturnsManagmentAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 33.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 12.r,
                    ),
                    child: Row(
                      children: List.generate(2, (index) {
                        final texts = [
                          context.tr.inProgress,
                          context.tr.completed,
                        ];

                        return BlocSelector<PagingCubit, PagingState, int>(
                          selector: (state) => state.currentIndex,
                          builder: (context, state) {
                            final isSelected = state == index;

                            return Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextButton(
                                      text: texts[index],
                                      onTap: () {
                                        context.read<PagingCubit>().goToStep(
                                          index,
                                        );

                                        _strategies[index].get(context);
                                      },
                                      textColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text1,
                                      borderRadius: 1000.r,
                                      borderColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.border,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.r,
                                      ),
                                    ),
                                  ),
                                  if (index != 1) 12.horizontalSpace,
                                ],
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  BlocSelector<PagingCubit, PagingState, int>(
                    selector: (state) => state.currentIndex,
                    builder: (context, state) {
                      return _strategies[state].buildTopSection(context);
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 4.r,
                        horizontal: 4.r,
                      ),
                      margin: EdgeInsets.all(10.r),
                      child: BlocBuilder<GetReturnsCubit, GetReturnsState>(
                        builder: (context, state) {
                          final returns = <ReturnGoodsData>[];

                          if (state is GetReturnsLoading) {
                            return const AppLoadingWidget();
                          } else if (state is GetReturnsFailure) {
                            return AppFailureWidget(
                              failure: state.failure,
                              onRetry: () {
                                _strategies[context
                                        .read<PagingCubit>()
                                        .state
                                        .currentIndex]
                                    .get(context);
                              },
                              withBorder: false,
                            );
                          } else if (state is GetReturnsSuccess) {
                            returns.addAll(state.returns.data);
                          }

                          if (returns.isEmpty) {
                            return _strategies[context
                                    .read<PagingCubit>()
                                    .state
                                    .currentIndex]
                                .buildEmptyWidget(context);
                          }

                          return ListView.builder(
                            itemCount: returns.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final returnItem = returns[index];

                              return AppGestureDetectorButton(
                                onTap: () async {
                                  await NavigationService.I.pushNamed(
                                    AppRouteName.itemReturnDetailsScreen,
                                    arguments: returnItem.id,
                                  );

                                  if (mounted) {
                                    _strategies[context
                                            .read<PagingCubit>()
                                            .state
                                            .currentIndex]
                                        .get(context);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              returnItem.returnNumber,
                                              style: AppStyles.s13W600.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                AppSvg(
                                                  assetName: AppAssets
                                                      .returnsManagement,
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
                                                    style: AppStyles.s12W400
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text1,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${DateFormatter.formatDateMDY(DateTime.tryParse(returnItem.createdAt))} - ${DateFormatter.formatTimeHM(DateTime.tryParse(returnItem.createdAt))}',
                                              style: AppStyles.s12W400.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      returnItem.status.buildStatusWidget(
                                        context,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
