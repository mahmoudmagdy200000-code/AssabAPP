import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../cubit/brand_owner_daily_inventory_details/brand_owner_daily_inventory_details_cubit.dart';
import '../cubit/brand_owner_daily_inventory_details/brand_owner_daily_inventory_details_state.dart';
import 'brand_owner_daily_inventory_details_view.dart';

class BrandOwnerDailyInventoryDetailsScreen extends StatelessWidget {
  final String requestId;

  const BrandOwnerDailyInventoryDetailsScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child:
          BlocBuilder<
            BrandOwnerDailyInventoryDetailsCubit,
            BrandOwnerDailyInventoryDetailsState
          >(
            builder: (context, state) {
              return switch (state) {
                BrandOwnerDailyInventoryDetailsInitial() ||
                BrandOwnerDailyInventoryDetailsLoading() =>
                  const AppLoadingWidget(),
                BrandOwnerDailyInventoryDetailsFailure(:final failure) =>
                  AppFailureWidget(
                    failure: failure,
                    withBorder: false,
                    onRetry: () => context
                        .read<BrandOwnerDailyInventoryDetailsCubit>()
                        .load(requestId: requestId),
                  ),
                BrandOwnerDailyInventoryDetailsSuccess(:final details) ||
                BrandOwnerDailyInventoryDetailsActionLoading(:final details) ||
                BrandOwnerDailyInventoryDetailsActionSuccess(:final details) ||
                BrandOwnerDailyInventoryDetailsActionFailure(
                  :final details,
                ) => Column(
                  children: [
                    Row(
                      children: [
                        const AppBackButton(),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr.dailyInventory_d,
                                style: AppStyles.s20W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              Text(
                                '${details.branchName} | ${DateFormatter.formatDateMDY(DateTime.tryParse(details.inventoryDate)) ?? '-'}',
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        color: context.customColor.reversedTextColor,
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          children: [
                            ContainerCustomTextField(
                              padding: EdgeInsets.all(6.r),
                              borderRadius: BorderRadius.circular(1000.r),
                              child: Row(
                                children: List.generate(2, (index) {
                                  final texts = [
                                    context.tr.details,
                                    context.tr.timelines,
                                  ];

                                  return Expanded(
                                    child:
                                        BlocSelector<
                                          PagingCubit,
                                          PagingState,
                                          bool
                                        >(
                                          selector: (state) {
                                            return state.currentIndex == index;
                                          },
                                          builder: (context, state) {
                                            return CustomTextButton(
                                              text: texts[index],
                                              onTap: () {
                                                context
                                                    .read<PagingCubit>()
                                                    .goToStep(index);
                                              },
                                              borderColor: Colors.transparent,
                                              borderRadius: 1000.r,
                                              backgroundColor: state
                                                  ? context
                                                        .customColor
                                                        .reversedTextColor
                                                  : Colors.transparent,
                                              textColor: state
                                                  ? context.customColor.text1
                                                  : context.customColor.text3,
                                            );
                                          },
                                        ),
                                  );
                                }),
                              ),
                            ),
                            10.verticalSpace,
                            Expanded(
                              child:
                                  BlocSelector<PagingCubit, PagingState, int>(
                                    selector: (state) {
                                      return state.currentIndex;
                                    },
                                    builder: (context, state) {
                                      return IndexedStack(
                                        index: state,
                                        children: [
                                          BrandOwnerDailyInventoryDetailsView(
                                            details: details,
                                          ),
                                          TimeLinesView(
                                            timelines: details.timelines,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              };
            },
          ),
    );
  }
}
