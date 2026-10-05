import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/brand_owner_branch_entity.dart';
import '../cubit/brand_owner_branches_for_filter_cubit.dart';
import '../cubit/brand_owner_branches_for_filter_state.dart';
import 'brand_owner_financial_reporting_choose_date_bottom_sheet.dart';

class SalesChannelAnalysisFilterBottomSheet extends StatefulWidget {
  final void Function(
    BrandOwnerFinancialReportingChooseDateMonthModel month,
    int year,
    BrandOwnerFinancialReportingChooseDateMonthModel cMonth,
    int cYear,
    String branchId,
  )
  onApplyFilter;
  final void Function() onReset;

  const SalesChannelAnalysisFilterBottomSheet({
    super.key,
    required this.onApplyFilter,
    required this.onReset,
  });

  @override
  State<SalesChannelAnalysisFilterBottomSheet> createState() =>
      _SalesChannelAnalysisFilterBottomSheetState();
}

class _SalesChannelAnalysisFilterBottomSheetState
    extends State<SalesChannelAnalysisFilterBottomSheet> {
  late final ValueNotifier<BrandOwnerFinancialReportingChooseDateMonthModel?>
  _selectedMonth;
  late final ValueNotifier<int?> _selectedYear;
  late final ValueNotifier<BrandOwnerFinancialReportingChooseDateMonthModel?>
  _selectedCompareMonth;
  late final ValueNotifier<int?> _selectedCompareYear;
  late final ValueNotifier<String?> _selectedBranch;
  late final ValueNotifier<bool> _branchDropDownOpen;

  @override
  void initState() {
    super.initState();

    _selectedMonth =
        ValueNotifier<BrandOwnerFinancialReportingChooseDateMonthModel?>(null);
    _selectedYear = ValueNotifier<int?>(null);
    _selectedBranch = ValueNotifier<String?>(null);
    _selectedCompareMonth =
        ValueNotifier<BrandOwnerFinancialReportingChooseDateMonthModel?>(null);
    _selectedCompareYear = ValueNotifier<int?>(null);
    _branchDropDownOpen = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _selectedMonth.dispose();
    _selectedYear.dispose();
    _selectedCompareMonth.dispose();
    _selectedCompareYear.dispose();
    _selectedBranch.dispose();
    _branchDropDownOpen.dispose();
    super.dispose();
  }

  void _resetFilters() {
    _selectedMonth.value = null;
    _selectedYear.value = null;
    _selectedBranch.value = null;
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<BrandOwnerBranchesForFilterCubit>()..loadBranches(),
      child: _buildSheetContent(),
    );
  }

  Widget _buildSheetContent() {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).filterData,
                    style: AppStyles.s16W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    S.of(context).applyYourPreferredFiltersToShowBetterResults,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.viewReports,
                              width: 16.r,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text4,
                                BlendMode.srcIn,
                              ),
                            ),
                            5.horizontalSpace,
                            Flexible(
                              child: Text(
                                S.of(context).reportType,
                                style: AppStyles.s13W400.copyWith(
                                  color: context.customColor.text4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      Text(
                        S.of(context).salesChannelAnalysis,
                        style: AppStyles.s13W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.calendar,
                              width: 16.r,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text4,
                                BlendMode.srcIn,
                              ),
                            ),
                            5.horizontalSpace,
                            Flexible(
                              child: Text(
                                S.of(context).reportMonth,
                                style: AppStyles.s13W400.copyWith(
                                  color: context.customColor.text4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: AppGestureDetectorButton(
                          onTap: () {
                            AppBottomSheet.customPageRoute(
                              context,
                              (context) =>
                                  BrandOwnerFinancialReportingChooseDateBottomSheet(
                                    onApply: (selectedMonth, selectedYear) {
                                      _selectedMonth.value = selectedMonth;
                                      _selectedYear.value = selectedYear;
                                    },
                                  ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              color: context.customColor.text2,
                            ),
                            padding: EdgeInsets.all(12.r),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: ValueListenableBuilder(
                                    valueListenable: _selectedMonth,
                                    builder: (context, month, child) {
                                      return ValueListenableBuilder(
                                        valueListenable: _selectedYear,
                                        builder: (context, year, child) {
                                          return Text(
                                            (month == null || year == null)
                                                ? '-'
                                                : '${month.title} $year',
                                            style: AppStyles.s13W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                10.horizontalSpace,
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: context.theme.primaryColor,
                                  size: 16.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.refresh,
                              width: 16.r,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text4,
                                BlendMode.srcIn,
                              ),
                            ),
                            5.horizontalSpace,
                            Flexible(
                              child: Text(
                                S.of(context).compareWith,
                                style: AppStyles.s13W400.copyWith(
                                  color: context.customColor.text4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: AppGestureDetectorButton(
                          onTap: () {
                            AppBottomSheet.customPageRoute(
                              context,
                              (context) =>
                                  BrandOwnerFinancialReportingChooseDateBottomSheet(
                                    onApply: (selectedMonth, selectedYear) {
                                      _selectedCompareMonth.value =
                                          selectedMonth;
                                      _selectedCompareYear.value = selectedYear;
                                    },
                                  ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              color: context.customColor.text2,
                            ),
                            padding: EdgeInsets.all(12.r),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: ValueListenableBuilder(
                                    valueListenable: _selectedCompareMonth,
                                    builder: (context, month, child) {
                                      return ValueListenableBuilder(
                                        valueListenable: _selectedCompareYear,
                                        builder: (context, year, child) {
                                          return Text(
                                            (month == null || year == null)
                                                ? '-'
                                                : '${month.title} $year',
                                            style: AppStyles.s13W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                10.horizontalSpace,
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: context.theme.primaryColor,
                                  size: 16.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  const CustomDivider(),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.branchStoreSvg,
                              width: 16.r,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text4,
                                BlendMode.srcIn,
                              ),
                            ),
                            5.horizontalSpace,
                            Flexible(
                              child: Text(
                                S.of(context).branch,
                                style: AppStyles.s13W400.copyWith(
                                  color: context.customColor.text4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.horizontalSpace,
                      Flexible(
                        child: AppGestureDetectorButton(
                          onTap: () {
                            _branchDropDownOpen.value =
                                !_branchDropDownOpen.value;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              color: context.customColor.text2,
                            ),
                            padding: EdgeInsets.all(12.r),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child:
                                      BlocBuilder<
                                        BrandOwnerBranchesForFilterCubit,
                                        BrandOwnerBranchesForFilterState
                                      >(
                                        builder: (context, branchState) {
                                          final branches = switch (branchState) {
                                            BrandOwnerBranchesForFilterSuccess(
                                              :final branches,
                                            ) =>
                                              branches,
                                            _ => <BrandOwnerBranchEntity>[],
                                          };
                                          return ValueListenableBuilder(
                                            valueListenable: _selectedBranch,
                                            builder: (context, value, child) {
                                              return Text(
                                                _branchNameById(
                                                  value,
                                                  branches,
                                                ),
                                                style: AppStyles.s13W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                ),
                                10.horizontalSpace,
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: context.theme.primaryColor,
                                  size: 16.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<
                    BrandOwnerBranchesForFilterCubit,
                    BrandOwnerBranchesForFilterState
                  >(
                    builder: (context, branchState) {
                      return ValueListenableBuilder(
                        valueListenable: _branchDropDownOpen,
                        builder: (context, isOpen, child) {
                          if (!isOpen) {
                            return const SizedBox.shrink();
                          }

                          return switch (branchState) {
                            BrandOwnerBranchesForFilterInit() ||
                            BrandOwnerBranchesForFilterLoading() => Container(
                              height: 200.h,
                              alignment: Alignment.center,
                              child: const AppLoadingWidget(),
                            ),
                            BrandOwnerBranchesForFilterSuccess(
                              :final branches,
                            ) =>
                              _buildBranchDropdown(context, branches),
                            BrandOwnerBranchesForFilterFailure(
                              :final failure,
                            ) =>
                              AppFailureWidget(
                                failure: failure,
                                onRetry: () => context
                                    .read<BrandOwnerBranchesForFilterCubit>()
                                    .loadBranches(),
                              ),
                          };
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: S.of(context).resetFilter,
                    onTap: _resetFilters,
                    padding: EdgeInsets.symmetric(vertical: 14.r),
                    borderRadius: 12.r,
                    textColor: context.customColor.text1,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _selectedMonth,
                    builder: (context, month, child) {
                      return ValueListenableBuilder(
                        valueListenable: _selectedYear,
                        builder: (context, year, child) {
                          return ValueListenableBuilder(
                            valueListenable: _selectedCompareMonth,
                            builder: (context, cMonth, child) {
                              return ValueListenableBuilder(
                                valueListenable: _selectedCompareYear,
                                builder: (context, cYear, child) {
                                  return ValueListenableBuilder(
                                    valueListenable: _selectedBranch,
                                    builder: (context, branch, child) {
                                      return AppButton(
                                        text: S.of(context).applyFilter,
                                        onClick: () {
                                          if (month != null &&
                                              year != null &&
                                              cMonth != null &&
                                              cYear != null &&
                                              branch != null) {
                                            widget.onApplyFilter(
                                              month,
                                              year,
                                              cMonth,
                                              cYear,
                                              branch,
                                            );
                                          }
                                        },
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14.r,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        borderColor: Colors.transparent,
                                        enabled:
                                            month != null &&
                                            year != null &&
                                            cMonth != null &&
                                            cYear != null &&
                                            branch != null,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _branchNameById(String? id, List<BrandOwnerBranchEntity> branches) {
    if (id == null) return '-';
    final branch = branches.where((b) => b.id == id).firstOrNull;
    return branch?.name ?? '-';
  }

  Widget _buildBranchDropdown(
    BuildContext context,
    List<BrandOwnerBranchEntity> branches,
  ) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: context.customColor.text2,
            blurRadius: 10.r,
            spreadRadius: 6.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
            child: Text(
              '${branches.length} ${S.of(context).activeBranches}',
              style: AppStyles.s12W500.copyWith(
                color: context.customColor.text4,
              ),
            ),
          ),
          4.verticalSpace,
          CustomDivider(color: context.customColor.border),
          4.verticalSpace,
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];
                return AppGestureDetectorButton(
                  onTap: () {
                    _branchDropDownOpen.value = false;
                    _selectedBranch.value = branch.id;
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.r,
                          horizontal: 16.r,
                        ),
                        child: Text(
                          branch.name,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                      if (index != branches.length - 1) const CustomDivider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
