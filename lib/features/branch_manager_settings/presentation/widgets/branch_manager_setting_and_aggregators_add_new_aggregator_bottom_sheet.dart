import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/search/search_state.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';
import '../cubits/branch_manager_setting_and_aggregators_cubit.dart';

class BranchManagerSettingAndAggregatorsAddNewAggregatorBottomSheet
    extends StatefulWidget {
  final List<BranchManagerAggregatorEntity> availableAggregators;

  const BranchManagerSettingAndAggregatorsAddNewAggregatorBottomSheet({
    super.key,
    required this.availableAggregators,
  });

  @override
  State<BranchManagerSettingAndAggregatorsAddNewAggregatorBottomSheet>
  createState() =>
      _BranchManagerSettingAndAggregatorsAddNewAggregatorBottomSheetState();
}

class _BranchManagerSettingAndAggregatorsAddNewAggregatorBottomSheetState
    extends
        State<BranchManagerSettingAndAggregatorsAddNewAggregatorBottomSheet> {
  late final SearchCubit<BranchManagerAggregatorEntity> _searchCubit;
  String? _selectedAggregatorId;

  @override
  void initState() {
    super.initState();

    _searchCubit = SearchCubit<BranchManagerAggregatorEntity>();
    _searchCubit.setData(widget.availableAggregators);
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
    _searchCubit.search(value, _matchesAggregator);
  }

  List<BranchManagerAggregatorEntity> _aggregatorsFromState(
    SearchState<BranchManagerAggregatorEntity> state,
  ) {
    if (state is SearchSuccess<BranchManagerAggregatorEntity>) {
      return state.results;
    }

    return widget.availableAggregators;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: Scaffold(
        body: AppPaddingWidget(
          top: 30.r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Aggregator',
                style: AppStyles.s20W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              5.verticalSpace,
              Text(
                'Once added, Cashiers will be notified and can use them during sales recording.',
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Row(
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
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      Expanded(
                        child:
                            BlocBuilder<
                              SearchCubit<BranchManagerAggregatorEntity>,
                              SearchState<BranchManagerAggregatorEntity>
                            >(
                              builder: (context, state) {
                                final aggregators = _aggregatorsFromState(
                                  state,
                                );

                                if (aggregators.isEmpty) {
                                  return const AppSearchEmptyResultWidget();
                                }

                                return ListView.builder(
                                  itemCount: aggregators.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final aggregator = aggregators[index];

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10.r),
                                      child: AppGestureDetectorButton(
                                        onTap: () {
                                          setState(() {
                                            _selectedAggregatorId =
                                                aggregator.id;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            AppNetworkImage(
                                              image: aggregator.logoUrl,
                                              width: 35.r,
                                              height: 35.r,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            10.horizontalSpace,
                                            Expanded(
                                              child: Text(
                                                aggregator.name,
                                                style: AppStyles.s14W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            SelectionCircule(
                                              isSelected:
                                                  _selectedAggregatorId ==
                                                  aggregator.id,
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
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              AppButton(
                onClick: () {
                  BranchManagerAggregatorEntity? selectedAggregator;

                  for (final item in widget.availableAggregators) {
                    if (item.id == _selectedAggregatorId) {
                      selectedAggregator = item;
                      break;
                    }
                  }

                  if (selectedAggregator == null) {
                    return;
                  }

                  context
                      .read<BranchManagerSettingAndAggregatorsCubit>()
                      .addAggregator(aggregatorId: selectedAggregator.id);
                  NavigationService.I.pop();
                },
                text: 'Activate Selected Aggregator',
                enabled: _selectedAggregatorId != null,
                padding: EdgeInsets.symmetric(vertical: 14.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
