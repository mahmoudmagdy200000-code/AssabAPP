import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/brand_owner_financial_reporting/presentation/widgets/price_simulator_simulation_saved_senario_details_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../generated/l10n.dart';
import '../cubit/price_simulator_scenario_details_cubit.dart';
import '../cubit/price_simulator_saved_scenarios_cubit.dart';
import '../cubit/price_simulator_saved_scenarios_state.dart';

class PriceSimulatorSimulationSavedSenarioBottomSheet
    extends StatefulWidget {
  const PriceSimulatorSimulationSavedSenarioBottomSheet({super.key});

  @override
  State<PriceSimulatorSimulationSavedSenarioBottomSheet> createState() =>
      _PriceSimulatorSimulationSavedSenarioBottomSheetState();
}

class _PriceSimulatorSimulationSavedSenarioBottomSheetState
    extends State<PriceSimulatorSimulationSavedSenarioBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<PriceSimulatorSavedScenariosCubit>().loadScenarios();
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
                  BlocBuilder<PriceSimulatorSavedScenariosCubit,
                      PriceSimulatorSavedScenariosState>(
                    builder: (context, state) {
                      final scenarioCount = switch (state) {
                        PriceSimulatorSavedScenariosSuccess(
                          :final scenarios,
                        ) =>
                          scenarios.length,
                        _ => 0,
                      };

                      return Text(
                        S.of(context).savedScenariosCount(scenarioCount),
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ).sliverBoxAdapter;
                    },
                  ),
                  5.verticalSpace.sliverBoxAdapter,
                  Text(
                    S.of(context).reviewAndExportPreviouslySavedScenarios,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  const CustomDivider().sliverBoxAdapter,
                  20.verticalSpace.sliverBoxAdapter,
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
                            hintText:
                                'Search for simulations e.g Special Burger',
                            onChanged: (query) {
                              context
                                  .read<PriceSimulatorSavedScenariosCubit>()
                                  .search(query);
                            },
                          ),
                        ),
                      ],
                    ),
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  BlocBuilder<PriceSimulatorSavedScenariosCubit,
                      PriceSimulatorSavedScenariosState>(
                    builder: (context, state) {
                      return switch (state) {
                        PriceSimulatorSavedScenariosInit() ||
                        PriceSimulatorSavedScenariosLoading() =>
                          const AppLoadingWidget().sliverBoxAdapter,
                        PriceSimulatorSavedScenariosFailure(
                          :final failure,
                        ) =>
                          SliverToBoxAdapter(
                            child: AppFailureWidget(
                              failure: failure,
                              onRetry: () => context
                                  .read<PriceSimulatorSavedScenariosCubit>()
                                  .loadScenarios(),
                            ),
                          ),
                        PriceSimulatorSavedScenariosSuccess(
                          :final filteredScenarios,
                        ) =>
                          filteredScenarios.isEmpty
                              ? SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.r),
                                    child: Text(
                                      'No saved scenarios found',
                                      style: AppStyles.s14W400.copyWith(
                                        color: context.customColor.text3,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : DecoratedSliver(
                                  decoration: BoxDecoration(
                                    color: context.customColor.text2,
                                    borderRadius:
                                        BorderRadius.circular(15.r),
                                  ),
                                  sliver: SliverPadding(
                                    padding: EdgeInsetsGeometry.all(12.r),
                                    sliver: SliverList.builder(
                                      itemCount:
                                          filteredScenarios.length,
                                      itemBuilder: (context, index) {
                                        final scenario =
                                            filteredScenarios[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: context
                                                .customColor
                                                .reversedTextColor,
                                            borderRadius:
                                                BorderRadius.circular(
                                                  12.r,
                                                ),
                                          ),
                                          padding: EdgeInsets.all(12.r),
                                          margin: EdgeInsets.only(
                                            bottom: 12.r,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  AppSvg(
                                                    assetName:
                                                        AppAssets.cash,
                                                    width: 16.r,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      context
                                                          .customColor
                                                          .text1,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                  10.horizontalSpace,
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                scenario
                                                                    .itemName,
                                                                style: AppStyles
                                                                    .s13W500
                                                                    .copyWith(
                                                                  color: context
                                                                      .theme
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                            10
                                                                .horizontalSpace,
                                                            Flexible(
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const SaudiRiyalSvgWidget(),
                                                                  3
                                                                      .horizontalSpace,
                                                                  Flexible(
                                                                    child: Text(
                                                                      scenario
                                                                          .newPrice
                                                                          .toStringAsFixed(
                                                                            0,
                                                                          ),
                                                                      style:
                                                                          AppStyles.s13W500.copyWith(
                                                                        color: context
                                                                            .customColor
                                                                            .text1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        5.verticalSpace,
                                                        Text(
                                                          scenario
                                                              .dateTime,
                                                          style: AppStyles
                                                              .s12W400
                                                              .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              10.verticalSpace,
                                              ButtonTextIcon(
                                                onTap: () {
                                                  AppBottomSheet
                                                      .showModal(
                                                    context,
                                                    isScrollControlled:
                                                        true,
                                                    (context) =>
                                                        BlocProvider(
                                                      create: (_) =>
                                                          getIt<
                                                              PriceSimulatorScenarioDetailsCubit>(),
                                                      child:
                                                          PriceSimulatorSimulationSavedSenarioDetailsBottomSheet(
                                                        scenario:
                                                            scenario,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                label:
                                                    S.of(context).viewDetails,
                                                icon: AppSvg(
                                                  assetName: AppAssets.eye,
                                                  width: 16.r,
                                                  colorFilter:
                                                      ColorFilter.mode(
                                                    context
                                                        .customColor
                                                        .text1,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12.r,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      15.r,
                                                    ),
                                                spaceBetweenTextAndIcon: 7,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                      };
                    },
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            ButtonTextIcon(
              onTap: () {
                NavigationService.I.pop();
              },
              label: S.of(context).newSimulation,
              icon: AppSvg(
                assetName: AppAssets.recurringOrders,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.reversedTextColor,
                  BlendMode.srcIn,
                ),
              ),
              textColor: context.customColor.reversedTextColor,
              backgroundColor: context.theme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 14.r),
              borderRadius: BorderRadius.circular(15.r),
              spaceBetweenTextAndIcon: 7,
            ),
          ],
        ),
      ),
    );
  }
}
