import 'package:assab/core/enums/custody_requests_status_enum.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/custody/presentation/cubit/select_filter_custody_requests/select_filter_custody_requests_cubit.dart';
import 'package:assab/features/custody/presentation/cubit/select_filter_custody_requests/select_filter_custody_requests_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_text_button.dart';
import '../cubit/custody_get_requets/custody_get_requets_cubit.dart';
import 'branch_custody_filter_sort_by_date_section.dart';

class BranchCustodyRequestsFilterBottomSheetWidget extends StatelessWidget {
  const BranchCustodyRequestsFilterBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppPaddingWidget(
        top: 10.r,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      context.tr.filterCustodyRequestListBy,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ).sliverBoxAdapter,
                  12.verticalSpace.sliverBoxAdapter,
                  const CustomDivider().sliverBoxAdapter,
                  12.verticalSpace.sliverBoxAdapter,
                  _buildText(context, context.tr.status),
                  8.verticalSpace.sliverBoxAdapter,
                  SliverGrid.builder(
                    itemCount: 4,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.r,
                      crossAxisSpacing: 10.r,
                      childAspectRatio: 4.h,
                    ),
                    itemBuilder: (context, index) {
                      final texts = [
                        context.tr.all,
                        context.tr.pending,
                        context.tr.approved,
                        context.tr.rejected,
                      ];

                      final statuses = [
                        CustodyRequestsStatusEnum.all,
                        CustodyRequestsStatusEnum.pending,
                        CustodyRequestsStatusEnum.approved,
                        CustodyRequestsStatusEnum.rejected,
                      ];

                      return BlocSelector<
                        SelectFilterCustodyRequestsCubit,
                        SelectFilterCustodyRequestsState,
                        bool
                      >(
                        selector: (state) => state.status == statuses[index],
                        builder: (context, state) {
                          return CustomTextButton(
                            text: texts[index],
                            borderRadius: 1000.r,
                            textColor: state
                                ? context.theme.primaryColor
                                : context.customColor.text3,
                            borderColor: state
                                ? context.theme.primaryColor
                                : context.customColor.border,
                            onTap: () {
                              context
                                  .read<SelectFilterCustodyRequestsCubit>()
                                  .setStatus(statuses[index]);
                            },
                          );
                        },
                      );
                    },
                  ),
                  20.verticalSpace.sliverBoxAdapter,
                  _buildText(context, context.tr.sortByDate),
                  8.verticalSpace.sliverBoxAdapter,
                  BranchCustodyFilterSortByDateSection<
                    SelectFilterCustodyRequestsCubit,
                    SelectFilterCustodyRequestsState
                  >(
                    onTap: (TimeKeys time) {
                      context.read<SelectFilterCustodyRequestsCubit>().setDate(
                        time,
                      );
                    },
                    state: (state) => state.time,
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.defaultSettings,
                    onTap: () {
                      context
                          .read<SelectFilterCustodyRequestsCubit>()
                          .clearFilters();
                    },
                    textColor: context.customColor.text3,
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child:
                      BlocSelector<
                        SelectFilterCustodyRequestsCubit,
                        SelectFilterCustodyRequestsState,
                        bool
                      >(
                        selector: (state) =>
                            state.status != CustodyRequestsStatusEnum.non ||
                            state.time != TimeKeys.non,
                        builder: (context, state) {
                          return AppButton(
                            onClick: () {
                              context
                                  .read<CustodyGetRequetsCubit>()
                                  .getCustodyRequests(
                                    status: context
                                        .read<
                                          SelectFilterCustodyRequestsCubit
                                        >()
                                        .state
                                        .status
                                        .value,
                                    timePeriod: context
                                        .read<
                                          SelectFilterCustodyRequestsCubit
                                        >()
                                        .state
                                        .time
                                        .key,
                                  );

                              NavigationService.I.pop();
                            },
                            text: context.tr.showResults,
                            enabled: state,
                            padding: EdgeInsets.symmetric(vertical: 18.r),
                            borderRadius: BorderRadius.circular(12.r),
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

  Widget _buildText(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.s14W500.copyWith(color: context.customColor.text3),
    ).sliverBoxAdapter;
  }
}
