import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/search/search_state.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_switch_button.dart';
import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';
import '../cubits/branch_manager_setting_and_aggregators_cubit.dart';
import '../widgets/branch_manager_setting_and_aggregators_add_new_aggregator_bottom_sheet.dart';
import '../widgets/branch_manager_setting_and_aggregators_delete_aggregator_bottom_sheet.dart';

class BranchManagerSettingAndAggregatorsAggregatorsView extends StatefulWidget {
  final BranchManagerSettingAndAggregatorsEntity data;

  const BranchManagerSettingAndAggregatorsAggregatorsView({
    super.key,
    required this.data,
  });

  @override
  State<BranchManagerSettingAndAggregatorsAggregatorsView> createState() =>
      _BranchManagerSettingAndAggregatorsAggregatorsViewState();
}

class _BranchManagerSettingAndAggregatorsAggregatorsViewState
    extends State<BranchManagerSettingAndAggregatorsAggregatorsView> {
  late final SearchCubit<BranchManagerAggregatorEntity> _searchCubit;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _searchCubit = SearchCubit<BranchManagerAggregatorEntity>();
    _searchCubit.setData(widget.data.addedAggregators);
  }

  @override
  void didUpdateWidget(
    covariant BranchManagerSettingAndAggregatorsAggregatorsView oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data) {
      _searchCubit.setData(widget.data.addedAggregators);

      if (_searchQuery.isNotEmpty) {
        _searchCubit.search(_searchQuery, _matchesAggregator);
      }
    }
  }

  @override
  void dispose() {
    _searchCubit.clear();
    _searchCubit.close();
    super.dispose();
  }

  bool _matchesAggregator(
    BranchManagerAggregatorEntity aggregator,
    String query,
  ) {
    return aggregator.name.toLowerCase().contains(query.toLowerCase());
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;
    _searchCubit.search(value, _matchesAggregator);
  }

  List<BranchManagerAggregatorEntity> _aggregatorsFromState(
    SearchState<BranchManagerAggregatorEntity> state,
  ) {
    if (state is SearchSuccess<BranchManagerAggregatorEntity>) {
      return state.results;
    }

    return widget.data.addedAggregators;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.addedAggregators.isEmpty) {
      return _emptyState(context);
    }

    return BlocProvider.value(
      value: _searchCubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<
            SearchCubit<BranchManagerAggregatorEntity>,
            SearchState<BranchManagerAggregatorEntity>
          >(
            builder: (context, state) {
              final aggregators = _aggregatorsFromState(state);

              return Text(
                'Added Aggregators (${aggregators.length})',
                style: AppStyles.s16W500.copyWith(
                  color: context.customColor.text1,
                ),
              );
            },
          ),
          5.verticalSpace,
          Text(
            'Manage, disable or enable active aggregators',
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          10.verticalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.text2,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(8.r),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.reversedTextColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 12.r,
                    ),
                    child: Row(
                      children: [
                        AppSvg(
                          assetName: AppAssets.search,
                          colorFilter: ColorFilter.mode(
                            context.customColor.text3,
                            BlendMode.srcIn,
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Search for delivery app’s by name',
                            onChanged: _onSearchChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.verticalSpace,
                  Expanded(
                    child:
                        BlocBuilder<
                          SearchCubit<BranchManagerAggregatorEntity>,
                          SearchState<BranchManagerAggregatorEntity>
                        >(
                          builder: (context, state) {
                            final aggregators = _aggregatorsFromState(state);

                            if (aggregators.isEmpty) {
                              return const AppSearchEmptyResultWidget();
                            }

                            return ListView.builder(
                              itemCount: aggregators.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final aggregator = aggregators[index];

                                return Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.r,
                                    vertical: 12.r,
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.r),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          AppNetworkImage(
                                            image: aggregator.logoUrl,
                                            width: 35.r,
                                            height: 35.r,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              aggregator.name,
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          AppGestureDetectorButton(
                                            onTap: () {
                                              final cubit = context
                                                  .read<
                                                    BranchManagerSettingAndAggregatorsCubit
                                                  >();
                                              AppBottomSheet.customPageRoute(
                                                context,
                                                (
                                                  sheetContext,
                                                ) => BlocProvider.value(
                                                  value: cubit,
                                                  child:
                                                      BranchManagerSettingAndAggregatorsDeleteAggregatorBottomSheet(
                                                        aggregator: aggregator,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: AppSvg(
                                              assetName: AppAssets.trashSvg,
                                              width: 17.r,
                                              colorFilter: ColorFilter.mode(
                                                context.customColor.text3,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          CustomSwitchButton(
                                            value: aggregator.enabled,
                                            onChanged: (newValue) {
                                              context
                                                  .read<
                                                    BranchManagerSettingAndAggregatorsCubit
                                                  >()
                                                  .setAggregatorEnabled(
                                                    aggregatorId: aggregator.id,
                                                    enabled: newValue,
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                      10.verticalSpace,
                                      const CustomDivider(),
                                      10.verticalSpace,
                                      Text(
                                        'This aggregator is enabled. Can be used by cashiers in this department during sales.',
                                        style: AppStyles.s12W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          _buildButtonAddAggregator(context),
        ],
      ),
    );
  }

  Widget _buildButtonAddAggregator(BuildContext context) {
    return ButtonTextIcon(
      onTap: () {
        final cubit = context.read<BranchManagerSettingAndAggregatorsCubit>();

        AppBottomSheet.customPageRoute(
          context,
          (sheetContext) => BlocProvider.value(
            value: cubit,
            child:
                BranchManagerSettingAndAggregatorsAddNewAggregatorBottomSheet(
                  availableAggregators: widget.data.availableAggregators,
                ),
          ),
        );
      },
      label: 'Add New Aggregator',
      icon: AppSvg(
        assetName: AppAssets.add,
        width: 18.r,
        colorFilter: ColorFilter.mode(
          context.customColor.reversedTextColor,
          BlendMode.srcIn,
        ),
      ),
      backgroundColor: context.theme.primaryColor,
      borderRadius: BorderRadius.circular(15.r),
      borderColor: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 16.r),
      textStyle: AppStyles.s13W500.copyWith(
        color: context.customColor.reversedTextColor,
      ),
      spaceBetweenTextAndIcon: 7,
    );
  }

  Widget _emptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAssetImage(
          image: AppAssets.listPng,
          width: 80.r,
          height: 80.r,
          borderRadius: BorderRadius.zero,
        ),
        16.verticalSpace,
        Text(
          'What Are Payment Aggregators?',
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        Text(
          'Platforms used by cashiers to log and manage all payment types during their shifts,  from cash to delivery apps.',
          style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          textAlign: TextAlign.center,
        ),
        20.verticalSpace,
        Row(
          children: [
            Container(
              width: 4.w,
              height: 100.h,
              color: context.theme.primaryColor,
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why It Matters',
                    style: AppStyles.s20W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  Text(
                    'They help track payment sources, ensure shift transparency, and make handovers clean and accountable.',
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        20.verticalSpace,
        _buildButtonAddAggregator(context),
      ],
    );
  }
}
