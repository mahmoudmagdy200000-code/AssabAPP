import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_overlay.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/branch_manager_settings/domain/entities/branch_manager_setting_and_aggregators_entity.dart';
import 'package:assab/features/branch_manager_settings/presentation/cubits/branch_manager_setting_and_aggregators_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../cubits/branch_manager_setting_and_aggregators_cubit.dart';
import 'branch_manager_setting_and_aggregators_aggregators_view.dart';
import 'branch_manager_setting_and_aggregators_details_view.dart';
import 'branch_manager_setting_and_aggregators_notifications_view.dart';

class BranchManagerSettingAndAggregatorsScreen extends StatefulWidget {
  const BranchManagerSettingAndAggregatorsScreen({super.key});

  @override
  State<BranchManagerSettingAndAggregatorsScreen> createState() =>
      _BranchManagerSettingAndAggregatorsScreenState();
}

class _BranchManagerSettingAndAggregatorsScreenState
    extends State<BranchManagerSettingAndAggregatorsScreen> {
  BranchManagerSettingAndAggregatorsEntity? _cachedData;
  bool _hasLoadedOnce = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body:
          BlocListener<
            BranchManagerSettingAndAggregatorsCubit,
            BranchManagerSettingAndAggregatorsState
          >(
            listener: (context, state) {
              if (state is BranchManagerSettingAndAggregatorsLoading) {
                AppOverlay.showCustomOverlay(
                  barrierDismissible: false,
                  child: const AppLoadingWidget(),
                );
              } else {
                AppOverlay.hideCustomOverlay();
              }

              if (state is BranchManagerSettingAndAggregatorsLoaded) {
                setState(() {
                  _cachedData = state.data;
                  _hasLoadedOnce = true;
                });
              }

              if (state is BranchManagerSettingAndAggregatorsFailure) {
                setState(() {
                  _hasLoadedOnce = true;
                });
              }
            },
            child: Column(
              children: [
                AppPaddingWidget(
                  top: 30.r,
                  child: Row(
                    children: [
                      const AppBackButton(),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocSelector<
                              BranchManagerSettingAndAggregatorsCubit,
                              BranchManagerSettingAndAggregatorsState,
                              String
                            >(
                              selector: (state) {
                                return state
                                        is BranchManagerSettingAndAggregatorsLoaded
                                    ? state.data.branchInfo.branchName
                                    : '-';
                              },
                              builder: (context, state) {
                                return Text(
                                  state,
                                  style: AppStyles.s16W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                );
                              },
                            ),
                            Text(
                              'View details or manage Branch Aggregators',
                              style: AppStyles.s12W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child:
                        BlocBuilder<
                          BranchManagerSettingAndAggregatorsCubit,
                          BranchManagerSettingAndAggregatorsState
                        >(
                          builder: (context, state) {
                            if (state
                                is BranchManagerSettingAndAggregatorsFailure) {
                              return AppFailureWidget(
                                failure: state.failure,
                                onRetry: () {
                                  context
                                      .read<
                                        BranchManagerSettingAndAggregatorsCubit
                                      >()
                                      .loadData();
                                },
                              );
                            } else if (state
                                is BranchManagerSettingAndAggregatorsLoading) {
                              if (!_hasLoadedOnce) {
                                return const AppLoadingWidget();
                              }

                              final data = _cachedData;
                              if (data == null) {
                                return const SizedBox.shrink();
                              }

                              return Column(
                                children: [
                                  Row(
                                    spacing: 8.w,
                                    children: List.generate(3, (index) {
                                      return Expanded(
                                        child:
                                            BlocSelector<
                                              PagingCubit,
                                              PagingState,
                                              bool
                                            >(
                                              selector: (state) {
                                                return state.currentIndex ==
                                                    index;
                                              },
                                              builder: (context, state) {
                                                final texts = [
                                                  context.tr.details,
                                                  context.tr.aggregators,
                                                  context.tr.notifications,
                                                ];

                                                return CustomTextButton(
                                                  text: texts[index],
                                                  onTap: () {
                                                    context
                                                        .read<PagingCubit>()
                                                        .goToStep(index);
                                                  },
                                                  textColor: state
                                                      ? context
                                                            .theme
                                                            .primaryColor
                                                      : context
                                                            .customColor
                                                            .text3,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  borderRadius: 1000.r,
                                                  borderColor: state
                                                      ? context
                                                            .theme
                                                            .primaryColor
                                                      : context
                                                            .customColor
                                                            .border,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 8.r,
                                                    horizontal: 12.r,
                                                  ),
                                                );
                                              },
                                            ),
                                      );
                                    }),
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  Expanded(
                                    child: BlocSelector<PagingCubit, PagingState, int>(
                                      selector: (state) {
                                        return state.currentIndex;
                                      },
                                      builder: (context, index) {
                                        return IndexedStack(
                                          index: index,
                                          children: [
                                            BranchManagerSettingAndAggregatorsDetailsView(
                                              branchInfo: data.branchInfo,
                                            ),
                                            BranchManagerSettingAndAggregatorsAggregatorsView(
                                              data: data,
                                            ),
                                            BranchManagerSettingAndAggregatorsNotificationsView(
                                              notifications: data.notifications,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else if (state
                                is BranchManagerSettingAndAggregatorsLoaded) {
                              final data = state.data;

                              return Column(
                                children: [
                                  Row(
                                    spacing: 8.w,
                                    children: List.generate(3, (index) {
                                      return Expanded(
                                        child:
                                            BlocSelector<
                                              PagingCubit,
                                              PagingState,
                                              bool
                                            >(
                                              selector: (state) {
                                                return state.currentIndex ==
                                                    index;
                                              },
                                              builder: (context, state) {
                                                final texts = [
                                                  context.tr.details,
                                                  context.tr.aggregators,
                                                  context.tr.notifications,
                                                ];

                                                return CustomTextButton(
                                                  text: texts[index],
                                                  onTap: () {
                                                    context
                                                        .read<PagingCubit>()
                                                        .goToStep(index);
                                                  },
                                                  textColor: state
                                                      ? context
                                                            .theme
                                                            .primaryColor
                                                      : context
                                                            .customColor
                                                            .text3,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  borderRadius: 1000.r,
                                                  borderColor: state
                                                      ? context
                                                            .theme
                                                            .primaryColor
                                                      : context
                                                            .customColor
                                                            .border,
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 8.r,
                                                    horizontal: 12.r,
                                                  ),
                                                );
                                              },
                                            ),
                                      );
                                    }),
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  Expanded(
                                    child: BlocSelector<PagingCubit, PagingState, int>(
                                      selector: (state) {
                                        return state.currentIndex;
                                      },
                                      builder: (context, index) {
                                        return IndexedStack(
                                          index: index,
                                          children: [
                                            BranchManagerSettingAndAggregatorsDetailsView(
                                              branchInfo: data.branchInfo,
                                            ),
                                            BranchManagerSettingAndAggregatorsAggregatorsView(
                                              data: data,
                                            ),
                                            BranchManagerSettingAndAggregatorsNotificationsView(
                                              notifications: data.notifications,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
