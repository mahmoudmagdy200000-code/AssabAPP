import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/purchase/presentation/cubit/select_filter_purchase_history/select_filter_purchase_history_cubit.dart';
import 'package:assab/features/purchase/presentation/cubit/select_filter_purchase_history/select_filter_purchase_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/filter_purchase_history_type_enum.dart';
import '../../../../core/enums/request_perspective_enum.dart';
import '../../../../core/enums/time_keys.dart';

class FilterPurchaseHistoryBottomSheetWidget extends StatelessWidget {
  final void Function(String? perspective, String? type, String? dateRange)
  onApplyFilters;
  final void Function() onClearFilters;

  const FilterPurchaseHistoryBottomSheetWidget({
    super.key,
    required this.onApplyFilters,
    required this.onClearFilters,
  });

  void _onSelectPerspective(
    BuildContext context,
    RequestPerspectiveEnum perspective,
  ) {
    context.read<SelectFilterPurchaseHistoryCubit>().selectRequestPerspective(
      perspective,
    );
  }

  void _onSelectType(BuildContext context, FilterPurchaseHistoryTypeEnum type) {
    context.read<SelectFilterPurchaseHistoryCubit>().selectType(type);
  }

  void _onSelectTime(BuildContext context, TimeKeys time) {
    context.read<SelectFilterPurchaseHistoryCubit>().selectTime(time);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    context.tr.filterPurchaseHistoryListBy,
                    style: AppStyles.s16W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ).sliverBoxAdapter,
                25.verticalSpace.sliverBoxAdapter,
                _buildText(context, context.tr.requestPerspective),
                8.verticalSpace.sliverBoxAdapter,
                BlocSelector<
                      SelectFilterPurchaseHistoryCubit,
                      SelectFilterPurchaseHistoryState,
                      RequestPerspectiveEnum
                    >(
                      selector: (state) => state.selectedPerspective,
                      builder: (context, state) {
                        final perspective = [
                          RequestPerspectiveEnum.all,
                          RequestPerspectiveEnum.iSubmitted,
                          RequestPerspectiveEnum.iReceived,
                        ];

                        return Row(
                          children: List.generate(3, (index) {
                            final text = switch (index) {
                              0 => context.tr.all,
                              1 => context.tr.iSubmitted,
                              2 => context.tr.iReceived,
                              _ => '',
                            };

                            final isSelected = state == perspective[index];

                            return Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextButton(
                                      text: text,
                                      onTap: () => _onSelectPerspective(
                                        context,
                                        perspective[index],
                                      ),
                                      borderRadius: 1000.r,
                                      textColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text3,
                                      borderColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.border,
                                    ),
                                  ),
                                  if (index != 2) 8.horizontalSpace,
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    )
                    .sliverBoxAdapter,
                20.verticalSpace.sliverBoxAdapter,
                _buildText(context, context.tr.type),
                8.verticalSpace.sliverBoxAdapter,
                BlocSelector<
                  SelectFilterPurchaseHistoryCubit,
                  SelectFilterPurchaseHistoryState,
                  FilterPurchaseHistoryTypeEnum
                >(
                  selector: (state) => state.selectedType,
                  builder: (context, state) {
                    final types = [
                      FilterPurchaseHistoryTypeEnum.all,
                      FilterPurchaseHistoryTypeEnum.branchTransfer,
                      FilterPurchaseHistoryTypeEnum.purchasingOfficer,
                      FilterPurchaseHistoryTypeEnum.directSupplier,
                    ];

                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.r,
                        crossAxisSpacing: 8.r,
                        childAspectRatio: 3.5.r,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final text = switch (index) {
                          0 => context.tr.all,
                          1 => context.tr.branchTransfer,
                          2 => context.tr.purchasingOfficer,
                          3 => context.tr.directSupplier,
                          _ => '',
                        };

                        final isSelected = state == types[index];

                        return CustomTextButton(
                          text: text,
                          onTap: () => _onSelectType(context, types[index]),
                          borderRadius: 1000.r,
                          borderColor: isSelected
                              ? context.theme.primaryColor
                              : context.customColor.border,
                          textColor: isSelected
                              ? context.theme.primaryColor
                              : context.customColor.text3,
                        );
                      },
                    );
                  },
                ),
                20.verticalSpace.sliverBoxAdapter,
                _buildText(context, context.tr.sortByDate),
                8.verticalSpace.sliverBoxAdapter,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.customColor.border),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 25.r,
                    horizontal: 20.r,
                  ),
                  child: ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final text = switch (index) {
                        0 => context.tr.last24Hours,
                        1 => context.tr.last7Days,
                        2 => context.tr.last30Days,
                        3 => context.tr.custom,
                        _ => '',
                      };

                      final time = switch (index) {
                        0 => TimeKeys.last24Hours,
                        1 => TimeKeys.last7Days,
                        2 => TimeKeys.last30Days,
                        3 => TimeKeys.custom,
                        _ => TimeKeys.last24Hours,
                      };

                      return AppGestureDetectorButton(
                        onTap: () => _onSelectTime(context, time),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    text,
                                    softWrap: true,
                                    style: AppStyles.s13W400.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ),
                                BlocSelector<
                                  SelectFilterPurchaseHistoryCubit,
                                  SelectFilterPurchaseHistoryState,
                                  TimeKeys
                                >(
                                  selector: (state) => state.selectedTime,
                                  builder: (context, state) {
                                    final isSelected = switch (index) {
                                      0 => state == TimeKeys.last24Hours,
                                      1 => state == TimeKeys.last7Days,
                                      2 => state == TimeKeys.last30Days,
                                      3 => state == TimeKeys.custom,
                                      _ => false,
                                    };

                                    return SelectionCircule(
                                      isSelected: isSelected,
                                    );
                                  },
                                ),
                              ],
                            ),
                            if (index != 3) ...[
                              13.verticalSpace,
                              const CustomDivider(),
                              13.verticalSpace,
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ).sliverBoxAdapter,
              ],
            ),
          ),
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CustomTextButton(
                  text: context.tr.defaultSettings,
                  textColor: context.customColor.text3,
                  padding: EdgeInsets.symmetric(
                    horizontal: 19.r,
                    vertical: 18.r,
                  ),
                  onTap: () {
                    context
                        .read<SelectFilterPurchaseHistoryCubit>()
                        .clearFilters();
                    onClearFilters();
                    NavigationService.I.pop();
                  },
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child:
                    BlocSelector<
                      SelectFilterPurchaseHistoryCubit,
                      SelectFilterPurchaseHistoryState,
                      bool
                    >(
                      selector: (state) =>
                          state.selectedPerspective !=
                              RequestPerspectiveEnum.non ||
                          state.selectedType !=
                              FilterPurchaseHistoryTypeEnum.non ||
                          state.selectedTime != TimeKeys.non,
                      builder: (context, state) {
                        return AppButton(
                          text: context.tr.showResults,
                          enabled: state,
                          padding: EdgeInsets.symmetric(
                            horizontal: 19.r,
                            vertical: 18.r,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          onClick: () {
                            final selectFilterPurchaseHistoryState = context
                                .read<SelectFilterPurchaseHistoryCubit>()
                                .state;

                            String? selectedPerspective;
                            String? selectedType;
                            String? selectedTime;

                            if (selectFilterPurchaseHistoryState
                                        .selectedPerspective !=
                                    RequestPerspectiveEnum.non &&
                                selectFilterPurchaseHistoryState
                                        .selectedPerspective !=
                                    RequestPerspectiveEnum.all) {
                              selectedPerspective =
                                  selectFilterPurchaseHistoryState
                                      .selectedPerspective
                                      .toString();
                            } else {
                              selectedPerspective = null;
                            }

                            if (selectFilterPurchaseHistoryState.selectedType !=
                                    FilterPurchaseHistoryTypeEnum.non &&
                                selectFilterPurchaseHistoryState.selectedType !=
                                    FilterPurchaseHistoryTypeEnum.all) {
                              selectedType = selectFilterPurchaseHistoryState
                                  .selectedType
                                  .value;
                            } else {
                              selectedType = null;
                            }

                            if (selectFilterPurchaseHistoryState.selectedTime !=
                                TimeKeys.non) {
                              selectedTime = selectFilterPurchaseHistoryState
                                  .selectedTime
                                  .key;
                            } else {
                              selectedTime = null;
                            }

                            onApplyFilters(
                              selectedPerspective,
                              selectedType,
                              selectedTime,
                            );

                            NavigationService.I.pop();
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context, String title) {
    return Text(
      title,
      style: AppStyles.s14W500.copyWith(color: context.customColor.text3),
    ).sliverBoxAdapter;
  }
}
