import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../core/widgets/app_failure_widget.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/app_loading_widget.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/container_custom_text_field.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/widgets/selection_circule.dart';
import '../../../../../../branch_manager_expenses/presentation/widgets/row_text_circule_selection.dart';
import '../../../../domain/entity/shift/aggregator_entites.dart';
import '../../../logic/shifts/aggregator_cubit.dart';

class AggregatorSelectorContent extends StatefulWidget {
  final void Function(List<AggregatorEntity> aggregator) onConfirm;

  const AggregatorSelectorContent({super.key, required this.onConfirm});

  @override
  State<AggregatorSelectorContent> createState() =>
      _AggregatorSelectorContentState();
}

class _AggregatorSelectorContentState extends State<AggregatorSelectorContent> {
  late final TextEditingController aggregatorAmountTotal;
  late final TextEditingController searchController;
  late final ValueNotifier<String> query;
  late final ScrollController _scrollController;

  AggregatorEntity? selectedAggregator;
  String branchId = '';

  @override
  void initState() {
    super.initState();
    aggregatorAmountTotal = TextEditingController();
    searchController = TextEditingController();
    query = ValueNotifier('');
    // Reset validation when sheet opens
    final validationCubit = context.read<ValidationCubit>();
    validationCubit.validateFieldAndStoreValue(
      fieldName: 'aggregator',
      value: '',
      isValid: false,
    );
    validationCubit.validateFieldAndStoreValue(
      fieldName: 'amountCollected',
      value: '',
      isValid: false,
    );

    _scrollController = ScrollController()..addListener(_onScroll);

    // Load aggregators
    context.read<AggregatorCubit>().getAggregators();
  }

  void _onScroll() {
    final cubit = context.read<AggregatorCubit>();

    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      if (cubit.hasMore) {
        context.read<AggregatorCubit>().getAggregators(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    aggregatorAmountTotal.dispose();
    searchController.dispose();
    _scrollController.removeListener(_onScroll);
    query.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AggregatorCubit, AggregatorState>(
      builder: (context, aggregatorState) {
        if (aggregatorState is AggregatorLoading) {
          return const AppLoadingWidget();
        }

        if (aggregatorState is AggregatorFailure) {
          return AppFailureWidget(
            failure: aggregatorState.failure,
            onRetry: () {
              context.read<AggregatorCubit>().getAggregators();
            },
          );
        }

        if (aggregatorState is AggregatorEmpty) {
          return _buildEmptyState(context);
        }

        if (aggregatorState is AggregatorLoadedSuccess) {
          return _buildLoadedState(
            context: context,
            scrollController: _scrollController,
            aggregatorsList: aggregatorState.aggregators,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      child: AppPaddingWidget(
        child: SizedBox(
          height: 600.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr.chooseDeliveryApp, style: AppStyles.s20W500),
              2.verticalSpace,
              Text(
                context.tr.chooseDeliveryAppDesc,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              15.verticalSpace,
              const CustomDivider(),
              30.verticalSpace,
              Center(
                child: Text(
                  context.tr.noAggregatorsFound,
                  style: AppStyles.s15W500,
                ),
              ),
              const Spacer(),
              AppButton(
                text: context.tr.back,
                enabled: true,
                onClick: () => NavigationService.I.pop(),
              ),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState({
    required BuildContext context,
    required List<AggregatorEntity> aggregatorsList,
    required ScrollController scrollController,
  }) {
    return BlocProvider(
      create: (_) => getIt<ChooseItemCubit>(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: AppPaddingWidget(
          child: SizedBox(
            height: 600.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.chooseDeliveryApp, style: AppStyles.s20W500),
                2.verticalSpace,
                Text(
                  context.tr.chooseDeliveryAppDesc,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),

                15.verticalSpace,
                const CustomDivider(),
                15.verticalSpace,

                /// Search
                _buildSearchBox(context, aggregatorsList),

                5.verticalSpace,

                /// List
                _buildList(context, aggregatorsList),

                20.verticalSpace,

                /// Amount
                _buildAmountField(context),

                const Spacer(),

                /// Confirm button
                _buildConfirmButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBox(
    BuildContext context,
    List<AggregatorEntity> branches,
  ) {
    return SizedBox(
      width: 300.w,
      child: ContainerCustomTextField(
        backgroundColor: context.customColor.reversedTextColor,
        borderColor: Colors.transparent,
        child: Row(
          children: [
            Icon(Icons.search, color: context.customColor.text1, size: 20.w),
            5.horizontalSpace,
            Expanded(
              child: CustomTextField(
                controller: searchController,
                maxLength: 30,
                hintText: 'Search Aggregator...',
                isEnabled: branches.isNotEmpty,
                onChanged: (v) => query.value = v.toLowerCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<AggregatorEntity> branches) {
    return SizedBox(
      height: 220.h,
      child: ValueListenableBuilder<String>(
        valueListenable: query,
        builder: (_, q, __) {
          final filtered = branches
              .where((b) => b.name.toLowerCase().contains(q))
              .toList();

          return ListView.builder(
            itemCount: filtered.length,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            itemBuilder: (context, index) {
              final item = filtered[index];
              final alreadyAdded = context
                  .read<AggregatorCubit>()
                  .isAggregatorAdded(item.id);
              return Container(
                margin: EdgeInsets.only(top: 7.w),
                child: AppGestureDetectorButton(
                  onTap: alreadyAdded
                      ? () {}
                      : () {
                          context.read<ChooseItemCubit>().selectItem(index);
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreValue(
                                fieldName: 'aggregator',
                                value: item.name,
                                isValid: true,
                              );
                          selectedAggregator = item;
                          branchId = item.id;
                          setState(() {});
                        },
                  child: Row(
                    children: [
                      // AppSvg(
                      //   assetName:
                      //   AppAssets.branchStoreSvg,
                      //   width: 25.w,
                      //   height: 25.h,
                      // ),
                      AppNetworkImage(
                        image: item.logo,
                        width: 25.w,
                        height: 25.h,
                        errorWidget: Icon(
                          Icons.error,
                          color: AppColors.sBlack,
                          size: 20.w,
                        ),
                      ),
                      10.horizontalSpace,
                      alreadyAdded
                          ? Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      softWrap: true,
                                      style: AppStyles.s14W400.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  const SelectionCircule(
                                    isSelected: true,
                                    color: AppColors.gray,
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child:
                                  BlocSelector<
                                    ChooseItemCubit,
                                    ChooseItemState,
                                    int?
                                  >(
                                    selector: (s) => s.selectedIndex,
                                    builder: (_, selectedIndex) {
                                      return RowTextCirculeSelection(
                                        text: item.name,
                                        isSelected: selectedIndex == index,
                                      );
                                    },
                                  ),
                            ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
      builder: (_, state) {
        final enabled = state.fieldsValue['aggregator']?.isNotEmpty == true;

        return ContainerCustomTextField(
          label: context.tr.totalSales,
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: aggregatorAmountTotal,
                  hintText: context.tr.amountCollected,
                  keyboardType: TextInputType.number,
                  isEnabled: enabled,
                  onChanged: (v) {
                    context.read<ValidationCubit>().validateFieldAndStoreValue(
                      fieldName: 'amountCollected',
                      value: v,
                      isValid: v.isNotEmpty,
                    );
                  },
                ),
              ),
              AppSvg(assetName: AppAssets.saudiRiyal, width: 20.w),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return BlocBuilder<ValidationCubit, ValidationState>(
      builder: (_, state) {
        final valid = state.fieldsValue['amountCollected']?.isNotEmpty == true;

        return AppButton(
          text: context.tr.confirm,
          enabled: valid,
          onClick: () {
            context.read<AggregatorCubit>().addAggregator(
              selectedAggregator!.copyWith(
                totalAmount: double.parse(aggregatorAmountTotal.text),
              ),
            );

            widget.onConfirm(context.read<AggregatorCubit>().addedAggregators);

            NavigationService.I.pop();
          },
        );
      },
    );
  }
}
