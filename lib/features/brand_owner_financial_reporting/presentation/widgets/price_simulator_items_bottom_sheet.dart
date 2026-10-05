import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/price_simulator_item_entity.dart';
import '../cubit/price_simulator_items_cubit.dart';
import '../cubit/price_simulator_items_state.dart';

class PriceSimulatorItemsBottomSheet extends StatefulWidget {
  final void Function(PriceSimulatorItemEntity item) onItemSelected;

  const PriceSimulatorItemsBottomSheet({
    super.key,
    required this.onItemSelected,
  });

  @override
  State<PriceSimulatorItemsBottomSheet> createState() =>
      _PriceSimulatorItemsBottomSheetState();
}

class _PriceSimulatorItemsBottomSheetState
    extends State<PriceSimulatorItemsBottomSheet> {
  late final ValueNotifier<PriceSimulatorItemEntity?> _selectedItemsNotifier;

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier = ValueNotifier(null);
    context.read<PriceSimulatorItemsCubit>().loadItems();
  }

  @override
  void dispose() {
    _selectedItemsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  Text(
                    S.of(context).selectItem,
                    style: AppStyles.s16W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ).sliverBoxAdapter,
                  Text(
                    S.of(context).searchForAndChooseSalesItemsForThisTest,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  const CustomDivider().sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.all(8.r),
                    child: Row(
                      children: [
                        AppSvg(
                          assetName: AppAssets.search,
                          width: 20.r,
                          colorFilter: ColorFilter.mode(
                            context.customColor.text1,
                            BlendMode.srcIn,
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: CustomTextField(
                            hintText: 'E.g Chicken Pie',
                            onChanged: (query) {
                              context
                                  .read<PriceSimulatorItemsCubit>()
                                  .search(query);
                            },
                          ),
                        ),
                      ],
                    ),
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  BlocBuilder<PriceSimulatorItemsCubit,
                      PriceSimulatorItemsState>(
                    builder: (context, state) {
                      return switch (state) {
                        PriceSimulatorItemsInit() ||
                        PriceSimulatorItemsLoading() =>
                          const AppLoadingWidget().sliverBoxAdapter,
                        PriceSimulatorItemsFailure(:final failure) =>
                          SliverToBoxAdapter(
                            child: AppFailureWidget(
                              failure: failure,
                              onRetry: () => context
                                  .read<PriceSimulatorItemsCubit>()
                                  .loadItems(),
                            ),
                          ),
                        PriceSimulatorItemsSuccess(
                          :final filteredItems,
                        ) =>
                          SliverList.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return AppGestureDetectorButton(
                                onTap: () {
                                  _selectedItemsNotifier.value = item;
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: _selectedItemsNotifier,
                                  builder: (context, value, child) {
                                    final isSelected = value?.id == item.id;

                                    return Container(
                                      decoration: isSelected
                                          ? BoxDecoration(
                                              border: Border.all(
                                                color: context
                                                    .theme.primaryColor,
                                              ),
                                            )
                                          : null,
                                      padding: EdgeInsets.all(16.r),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item.name,
                                              style: AppStyles.s13W500
                                                  .copyWith(
                                                color: context
                                                    .customColor.text1,
                                              ),
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          SelectionCircule(
                                            isSelected: isSelected,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                      };
                    },
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            ValueListenableBuilder(
              valueListenable: _selectedItemsNotifier,
              builder: (context, value, child) {
                return AppButton(
                  onClick: () {
                    if (value != null) {
                      widget.onItemSelected(value);
                      NavigationService.I.pop();
                    }
                  },
                  text: context.tr.confirmSelection,
                  enabled: value != null,
                  borderRadius: BorderRadius.circular(15.r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
