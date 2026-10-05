import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/fixed_assets_branches_response.dart';
import '../cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart';

class FixedAssetsBranchListBottomSheetWidget extends StatelessWidget {
  const FixedAssetsBranchListBottomSheetWidget({super.key});

  void _confirmSelection(
    BuildContext context,
    FixedAssetsGetZoneAndTypeState fixedAssetsGetZoneAndTypeState,
  ) {
    final tempSelectedIndex = context
        .read<ChooseItemCubit>()
        .state
        .tempSelectedIndex;

    if (fixedAssetsGetZoneAndTypeState is FixedAssetsGetBranchesSuccess &&
        tempSelectedIndex != null) {
      final acualSlectedIndex = tempSelectedIndex;

      context.read<ChooseItemCubit>().confirmTempSelection(
        subIndex: acualSlectedIndex,
      );

      context
          .read<ValidationCubit>()
          .validateFieldAndStoreTypedValue<FixedAssetsBranchItem>(
            fieldName: 'recipientBranch',
            value: fixedAssetsGetZoneAndTypeState
                .branches
                .branches[acualSlectedIndex],
            isValid: true,
          );

      NavigationService.I.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.branchList,
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            Text(
              context.tr.whoIsTheRecipientBranchForThisTransferRequest,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            12.verticalSpace,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
              child: Row(
                children: [
                  AppSvg(assetName: AppAssets.search, width: 16.r),
                  12.horizontalSpace,
                  Expanded(
                    child: CustomTextField(
                      onChanged: (value) {
                        context
                            .read<SearchCubit<FixedAssetsBranchItem>>()
                            .search(
                              value,
                              (item, query) => item.name.toLowerCase().contains(
                                query.toLowerCase(),
                              ),
                            );
                      },
                      hintText: context.tr.searchForBranchByFirstOrLastName,
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Expanded(
              child:
                  BlocListener<
                    FixedAssetsGetZoneAndTypeCubit,
                    FixedAssetsGetZoneAndTypeState
                  >(
                    listener: (context, state) {
                      if (state is FixedAssetsGetBranchesSuccess) {
                        context
                            .read<SearchCubit<FixedAssetsBranchItem>>()
                            .setData(state.branches.branches);
                      }
                    },
                    child:
                        BlocBuilder<
                          FixedAssetsGetZoneAndTypeCubit,
                          FixedAssetsGetZoneAndTypeState
                        >(
                          builder: (context, state) {
                            if (state is FixedAssetsGetZoneAndTypeLoading) {
                              return const AppLoadingWidget();
                            } else if (state
                                is FixedAssetsGetZoneAndTypeFailure) {
                              return AppFailureWidget(
                                failure: state.failure,
                                onRetry: () {
                                  context
                                      .read<FixedAssetsGetZoneAndTypeCubit>()
                                      .getBranches();
                                },
                              );
                            }

                            return BlocBuilder<
                              SearchCubit<FixedAssetsBranchItem>,
                              SearchState<FixedAssetsBranchItem>
                            >(
                              builder: (context, state) {
                                final branches = <FixedAssetsBranchItem>[];

                                if (state
                                    is SearchSuccess<FixedAssetsBranchItem>) {
                                  branches.addAll(state.results);
                                }

                                if (branches.isEmpty) {
                                  return const AppSearchEmptyResultWidget();
                                }

                                return ListView.builder(
                                  itemCount: branches.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return AppGestureDetectorButton(
                                      onTap: () {
                                        final searchState = context
                                            .read<
                                              SearchCubit<FixedAssetsBranchItem>
                                            >()
                                            .state;

                                        final originalState = context
                                            .read<
                                              FixedAssetsGetZoneAndTypeCubit
                                            >()
                                            .state;

                                        if (originalState
                                            is FixedAssetsGetBranchesSuccess) {
                                          final originalList =
                                              originalState.branches.branches;

                                          int actualIndex;

                                          if (searchState
                                              is SearchSuccess<
                                                FixedAssetsBranchItem
                                              >) {
                                            final selectedItem =
                                                searchState.results[index];
                                            actualIndex = originalList.indexOf(
                                              selectedItem,
                                            );
                                          } else {
                                            actualIndex = index;
                                          }

                                          context
                                              .read<ChooseItemCubit>()
                                              .selectTempItem(actualIndex);
                                        }
                                      },
                                      child:
                                          BlocSelector<
                                            ChooseItemCubit,
                                            ChooseItemState,
                                            bool
                                          >(
                                            selector: (state) {
                                              final originalState = context
                                                  .read<
                                                    FixedAssetsGetZoneAndTypeCubit
                                                  >()
                                                  .state;

                                              if (originalState
                                                  is FixedAssetsGetBranchesSuccess) {
                                                final item = branches[index];

                                                final actualIndex =
                                                    originalState
                                                        .branches
                                                        .branches
                                                        .indexWhere(
                                                          (element) =>
                                                              element.id ==
                                                              item.id,
                                                        );

                                                return state
                                                        .tempSelectedIndex ==
                                                    actualIndex;
                                              }

                                              return false;
                                            },
                                            builder: (context, state) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: state
                                                        ? context
                                                              .theme
                                                              .primaryColor
                                                        : Colors.transparent,
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(12.r),
                                                margin: EdgeInsets.only(
                                                  bottom: 12.r,
                                                ),
                                                child: Row(
                                                  children: [
                                                    AppSvg(
                                                      assetName:
                                                          AppAssets.branch,
                                                      width: 16.r,
                                                    ),
                                                    10.horizontalSpace,
                                                    Expanded(
                                                      child: Text(
                                                        branches[index].name,
                                                        style: AppStyles.s14W400
                                                            .copyWith(
                                                              color: context
                                                                  .customColor
                                                                  .text1,
                                                            ),
                                                      ),
                                                    ),
                                                    10.horizontalSpace,
                                                    SelectionCircule(
                                                      isSelected: state,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                  ),
            ),
            20.verticalSpace,
            BlocSelector<ChooseItemCubit, ChooseItemState, bool>(
              selector: (state) {
                return state.tempSelectedIndex != null;
              },
              builder: (context, state) {
                return BlocBuilder<
                  FixedAssetsGetZoneAndTypeCubit,
                  FixedAssetsGetZoneAndTypeState
                >(
                  builder: (context, fixedAssetsGetZoneAndTypeState) {
                    return AppButton(
                      onClick: () => _confirmSelection(
                        context,
                        fixedAssetsGetZoneAndTypeState,
                      ),
                      text: context.tr.confirmSelection,
                      enabled: state,
                      borderRadius: BorderRadius.circular(15.r),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
