import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/brand_owner_branch_entity.dart';
import '../../domain/entities/price_simulator_item_entity.dart';
import '../../domain/entities/price_simulator_item_info_entity.dart';
import '../cubit/brand_owner_branches_for_filter_cubit.dart';
import '../cubit/brand_owner_branches_for_filter_state.dart';
import '../cubit/price_simulator_items_cubit.dart';
import '../cubit/price_simulator_save_scenario_cubit.dart';
import '../cubit/price_simulator_saved_scenarios_cubit.dart';
import '../cubit/price_simulator_screen_cubit.dart';
import '../cubit/price_simulator_screen_state.dart';
import '../widgets/price_simulator_items_bottom_sheet.dart';
import '../widgets/price_simulator_simulation_result_bottom_sheet.dart';
import '../widgets/price_simulator_simulation_saved_senario_bottom_sheet.dart';
import '../widgets/price_simulator_what_is_change_price_bottom_sheet.dart';

class BrandOwnerPriceSimulatorScreen extends StatefulWidget {
  const BrandOwnerPriceSimulatorScreen({super.key});

  @override
  State<BrandOwnerPriceSimulatorScreen> createState() =>
      _BrandOwnerPriceSimulatorScreenState();
}

class _BrandOwnerPriceSimulatorScreenState
    extends State<BrandOwnerPriceSimulatorScreen> {
  late final ValueNotifier<bool> _branchDropDownOpen;
  late final ValueNotifier<BrandOwnerBranchEntity?> _selectedBranch;
  late final ValueNotifier<PriceSimulatorItemEntity?> _selectedItem;
  PriceSimulatorItemInfoEntity? _lastItemInfo;
  double _lastChangePrice = 0;
  double _lastExpectedGrowthDecline = 0.0;
  late final TextEditingController _changePriceController;
  late final TextEditingController _expectedGrowthDeclineController;
  bool _isUpdatingFromCubit = false;

  @override
  void initState() {
    super.initState();
    context.read<BrandOwnerBranchesForFilterCubit>().loadBranches();
    _branchDropDownOpen = ValueNotifier<bool>(false);
    _selectedBranch = ValueNotifier<BrandOwnerBranchEntity?>(null);
    _selectedItem = ValueNotifier<PriceSimulatorItemEntity?>(null);
    _changePriceController = TextEditingController();
    _expectedGrowthDeclineController = TextEditingController();
    _changePriceController.addListener(_onChangePriceChanged);
    _expectedGrowthDeclineController.addListener(
      _onExpectedGrowthDeclineChanged,
    );
  }

  @override
  void dispose() {
    _branchDropDownOpen.dispose();
    _selectedBranch.dispose();
    _selectedItem.dispose();
    _changePriceController.dispose();
    _expectedGrowthDeclineController.dispose();
    super.dispose();
  }

  void _onChangePriceChanged() {
    if (_isUpdatingFromCubit) return;
    final text = _changePriceController.text;
    if (text.isEmpty) return;
    final value = double.tryParse(text);
    if (value != null) {
      context.read<PriceSimulatorScreenCubit>().updateChangePrice(value);
    }
  }

  void _onExpectedGrowthDeclineChanged() {
    if (_isUpdatingFromCubit) return;
    final text = _expectedGrowthDeclineController.text;
    if (text.isEmpty) return;
    final value = double.tryParse(text);
    if (value != null) {
      context.read<PriceSimulatorScreenCubit>().updateExpectedGrowthDecline(
        value,
      );
    }
  }

  void _syncControllers(double changePrice, double expectedGrowthDecline) {
    _isUpdatingFromCubit = true;

    final currentChangePrice = double.tryParse(_changePriceController.text);
    if (currentChangePrice == null || currentChangePrice != changePrice) {
      final newText = changePrice.toString();
      if (_changePriceController.text != newText) {
        _changePriceController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }

    final currentExpectedGrowth = double.tryParse(
      _expectedGrowthDeclineController.text,
    );
    if (currentExpectedGrowth == null ||
        currentExpectedGrowth != expectedGrowthDecline) {
      final newText = expectedGrowthDecline.toStringAsFixed(0);
      if (_expectedGrowthDeclineController.text != newText) {
        _expectedGrowthDeclineController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }

    _isUpdatingFromCubit = false;
  }

  void _onSelectionChanged() {
    final branch = _selectedBranch.value;
    final item = _selectedItem.value;
    if (branch != null && item != null) {
      context.read<PriceSimulatorScreenCubit>().loadItemInfo(
        branchId: branch.id,
        itemId: item.id,
      );
    }
  }

  void _onSimulate() {
    final branch = _selectedBranch.value;
    final item = _selectedItem.value;
    if (branch == null || item == null) return;

    context.read<PriceSimulatorScreenCubit>().submitSimulation(
      branchId: branch.id,
      itemId: item.id,
    );
  }

  void _onNewSimulation() {
    _selectedBranch.value = null;
    _selectedItem.value = null;
    context.read<PriceSimulatorScreenCubit>().newSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PriceSimulatorScreenCubit, PriceSimulatorScreenState>(
      listener: (context, state) {
        if (state is PriceSimulatorScreenItemInfoSuccess) {
          _lastItemInfo = state.itemInfo;
          _lastChangePrice = state.changePrice;
          _lastExpectedGrowthDecline = state.expectedGrowthDecline;
        }
        if (state is PriceSimulatorScreenSimulationSuccess) {
          AppBottomSheet.customPageRoute(
            context,
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) => getIt<PriceSimulatorSaveScenarioCubit>(),
                ),
              ],
              child: PriceSimulatorSimulationResultBottomSheet(
                result: state.result,
                branchId: state.branchId,
                itemId: state.itemId,
                changePrice: state.changePrice,
                expectedGrowthDecline: state.expectedGrowthDecline,
              ),
            ),
          );
          context.read<PriceSimulatorScreenCubit>().returnToLoadedState();
        }
        if (state is PriceSimulatorScreenSimulationFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
          context.read<PriceSimulatorScreenCubit>().returnToLoadedState();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            AppPaddingWidget(
              top: 30.r,
              child: Row(
                children: [
                  const AppBackButton(),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).priceSimulator,
                          style: AppStyles.s15W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          S.of(context).forecastRevenueProfitMargins,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  10.horizontalSpace,
                  AppSvgButton(
                    assetName: AppAssets.receipt,
                    onTap: () {
                      AppBottomSheet.customPageRoute(
                        context,
                        (context) => BlocProvider(
                          create: (_) =>
                              getIt<PriceSimulatorSavedScenariosCubit>(),
                          child:
                              const PriceSimulatorSimulationSavedSenarioBottomSheet(),
                        ),
                      );
                    },
                    iconSize: 20.r,
                    bgColor: context.customColor.text2,
                    iconColor: context.customColor.text1,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: context.customColor.text2,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: context.customColor.reversedTextColor,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                padding: EdgeInsets.all(12.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).simulationSettings,
                                      style: AppStyles.s14W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    10.verticalSpace,
                                    const CustomDivider(),
                                    10.verticalSpace,
                                    _buildRow(
                                      context: context,
                                      title: S.of(context).date,
                                      assetName: AppAssets.calendar,
                                      customWidget: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: context.customColor.border,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(8.r),
                                        child: Text(
                                          DateFormatter.formatDateMDY(
                                                DateTime.now(),
                                              ) ??
                                              '-',
                                          style: AppStyles.s13W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    const CustomDivider(),
                                    10.verticalSpace,
                                    AppGestureDetectorButton(
                                      onTap: () {
                                        _branchDropDownOpen.value =
                                            !_branchDropDownOpen.value;
                                      },
                                      child: _buildRow(
                                        context: context,
                                        title: S.of(context).branch,
                                        assetName: AppAssets.calendar,
                                        customWidget: Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              border: Border.all(
                                                color:
                                                    context.customColor.border,
                                              ),
                                              color: context.customColor.text2,
                                            ),
                                            padding: EdgeInsets.all(12.r),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: ValueListenableBuilder(
                                                    valueListenable:
                                                        _selectedBranch,
                                                    builder:
                                                        (
                                                          context,
                                                          value,
                                                          child,
                                                        ) {
                                                          return Text(
                                                            value?.name ??
                                                                context
                                                                    .tr
                                                                    .choose,
                                                            style: AppStyles
                                                                .s13W500
                                                                .copyWith(
                                                                  color: context
                                                                      .customColor
                                                                      .text1,
                                                                ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                                10.horizontalSpace,
                                                Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: context
                                                      .theme
                                                      .primaryColor,
                                                  size: 16.r,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
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
                                              BrandOwnerBranchesForFilterLoading() =>
                                                Container(
                                                  height: 200.h,
                                                  alignment: Alignment.center,
                                                  child:
                                                      const AppLoadingWidget(),
                                                ),
                                              BrandOwnerBranchesForFilterSuccess(
                                                :final branches,
                                              ) =>
                                                _buildBranchDropdown(
                                                  context,
                                                  branches,
                                                ),
                                              BrandOwnerBranchesForFilterFailure(
                                                :final failure,
                                              ) =>
                                                AppFailureWidget(
                                                  failure: failure,
                                                  onRetry: () => context
                                                      .read<
                                                        BrandOwnerBranchesForFilterCubit
                                                      >()
                                                      .loadBranches(),
                                                ),
                                            };
                                          },
                                        );
                                      },
                                    ),
                                    10.verticalSpace,
                                    const CustomDivider(),
                                    10.verticalSpace,
                                    AppGestureDetectorButton(
                                      onTap: () {
                                        AppBottomSheet.customPageRoute(
                                          context,
                                          (context) => BlocProvider(
                                            create: (_) =>
                                                getIt<
                                                  PriceSimulatorItemsCubit
                                                >(),
                                            child:
                                                PriceSimulatorItemsBottomSheet(
                                                  onItemSelected: (item) {
                                                    _selectedItem.value = item;
                                                    _onSelectionChanged();
                                                  },
                                                ),
                                          ),
                                        );
                                      },
                                      child: _buildRow(
                                        context: context,
                                        title: S.of(context).selectItem,
                                        assetName: AppAssets.calendar,
                                        customWidget: Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              border: Border.all(
                                                color:
                                                    context.customColor.border,
                                              ),
                                              color: context.customColor.text2,
                                            ),
                                            padding: EdgeInsets.all(12.r),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: ValueListenableBuilder(
                                                    valueListenable:
                                                        _selectedItem,
                                                    builder:
                                                        (
                                                          context,
                                                          value,
                                                          child,
                                                        ) {
                                                          return Text(
                                                            value?.name ??
                                                                context
                                                                    .tr
                                                                    .choose,
                                                            style: AppStyles
                                                                .s13W500
                                                                .copyWith(
                                                                  color: context
                                                                      .customColor
                                                                      .text1,
                                                                ),
                                                          );
                                                        },
                                                  ),
                                                ),
                                                10.horizontalSpace,
                                                Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: context
                                                      .theme
                                                      .primaryColor,
                                                  size: 16.r,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              10.verticalSpace,
                              BlocBuilder<
                                PriceSimulatorScreenCubit,
                                PriceSimulatorScreenState
                              >(
                                builder: (context, state) {
                                  return switch (state) {
                                    PriceSimulatorScreenInit() =>
                                      const SizedBox.shrink(),
                                    PriceSimulatorScreenItemInfoLoading() =>
                                      _buildItemDataLoading(),
                                    PriceSimulatorScreenItemInfoFailure(
                                      :final failure,
                                    ) =>
                                      _buildItemDataError(failure),
                                    PriceSimulatorScreenItemInfoSuccess(
                                      :final itemInfo,
                                      :final changePrice,
                                      :final expectedGrowthDecline,
                                    ) =>
                                      _buildItemDataContent(
                                        context,
                                        itemInfo,
                                        changePrice,
                                        expectedGrowthDecline,
                                      ),
                                    PriceSimulatorScreenSimulationLoading() ||
                                    PriceSimulatorScreenSimulationSuccess() =>
                                      _buildItemDataContentFromPrevious(
                                        context,
                                      ),
                                    PriceSimulatorScreenSimulationFailure() =>
                                      _buildItemDataContentFromPrevious(
                                        context,
                                      ),
                                  };
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BlocBuilder<
                      PriceSimulatorScreenCubit,
                      PriceSimulatorScreenState
                    >(
                      builder: (context, state) {
                        final isSimulating =
                            state is PriceSimulatorScreenSimulationLoading;
                        final hasItemInfo =
                            state is PriceSimulatorScreenItemInfoSuccess ||
                            state is PriceSimulatorScreenSimulationLoading ||
                            state is PriceSimulatorScreenSimulationFailure;

                        return Container(
                          color: context.customColor.reversedTextColor,
                          padding: EdgeInsets.all(10.r),
                          child: Row(
                            children: [
                              Expanded(
                                child: ButtonTextIcon(
                                  onTap: _onNewSimulation,
                                  label: S.of(context).newSimulation,
                                  icon: AppSvg(
                                    assetName: AppAssets.recurringOrders,
                                    width: 16.r,
                                    colorFilter: ColorFilter.mode(
                                      context.customColor.text1,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 14.r),
                                  borderRadius: BorderRadius.circular(15.r),
                                  spaceBetweenTextAndIcon: 7,
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: isSimulating
                                    ? const AppLoadingWidget()
                                    : AppButton(
                                        onClick: _onSimulate,
                                        text: S.of(context).simulateChange,
                                        enabled: hasItemInfo,
                                        icon: AppSvg(
                                          assetName: AppAssets.play,
                                          width: 16.r,
                                          colorFilter: ColorFilter.mode(
                                            context
                                                .customColor
                                                .reversedTextColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        borderColor: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14.r,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDataContentFromPrevious(BuildContext context) {
    final state = context.read<PriceSimulatorScreenCubit>().state;
    if (state is PriceSimulatorScreenItemInfoSuccess) {
      _lastItemInfo = state.itemInfo;
      _lastChangePrice = state.changePrice;
      _lastExpectedGrowthDecline = state.expectedGrowthDecline;
      return _buildItemDataContent(
        context,
        state.itemInfo,
        state.changePrice,
        state.expectedGrowthDecline,
      );
    }
    if (_lastItemInfo != null) {
      return _buildItemDataContent(
        context,
        _lastItemInfo!,
        _lastChangePrice,
        _lastExpectedGrowthDecline,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildItemDataLoading() {
    return const AppLoadingWidget();
  }

  Widget _buildItemDataError(ApiFailure failure) {
    return AppFailureWidget(
      failure: failure,
      onRetry: () {
        final branch = _selectedBranch.value;
        final item = _selectedItem.value;
        if (branch != null && item != null) {
          context.read<PriceSimulatorScreenCubit>().loadItemInfo(
            branchId: branch.id,
            itemId: item.id,
          );
        }
      },
    );
  }

  Widget _buildItemDataContent(
    BuildContext context,
    PriceSimulatorItemInfoEntity itemInfo,
    double changePrice,
    double expectedGrowthDecline,
  ) {
    _syncControllers(changePrice, expectedGrowthDecline);
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).itemData,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            title: S.of(context).currentSellingPrice,
            assetName: AppAssets.wallet,
            value: itemInfo.currentSellingPrice.toStringAsFixed(1),
            showCurrency: true,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            title: S.of(context).productionCost,
            assetName: AppAssets.expenseSvg,
            value: itemInfo.productionCost.toStringAsFixed(1),
            showCurrency: true,
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            title: S.of(context).currentMonthlySales,
            assetName: AppAssets.custody,
            value: '${itemInfo.currentMonthlySales} Pieces',
          ),
          10.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,
          _buildRow(
            context: context,
            title: S.of(context).expectedGrowth,
            assetName: AppAssets.over,
            value: '${itemInfo.expectedGrowthPercentage.toStringAsFixed(0)}%',
          ),
          20.verticalSpace,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(12.r),
            child: Column(
              children: [
                _buildRow(
                  context: context,
                  title: S.of(context).changePrice,
                  assetName: AppAssets.saudiRiyal,
                  customWidget: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIconButton(
                          icon: Icons.remove,
                          onPressed: () {
                            context
                                .read<PriceSimulatorScreenCubit>()
                                .decrementChangePrice();
                          },
                          iconColor: context.customColor.text1,
                          borderColor: context.customColor.border,
                          backgroundColor: Colors.transparent,
                          padding: 4.r,
                          size: 20.r,
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: TextField(
                            controller: _changePriceController,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: AppStyles.s13W500.copyWith(
                              color: context.customColor.text1,
                            ),
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.theme.primaryColor,
                                ),
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        AppIconButton(
                          icon: Icons.add,
                          onPressed: () {
                            context
                                .read<PriceSimulatorScreenCubit>()
                                .incrementChangePrice();
                          },
                          iconColor: context.customColor.reversedTextColor,
                          borderColor: Colors.transparent,
                          backgroundColor: context.theme.primaryColor,
                          padding: 4.r,
                          size: 20.r,
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                _buildRow(
                  context: context,
                  title: S.of(context).expectedGrowthdecline,
                  assetName: AppAssets.over,
                  customWidget: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIconButton(
                          icon: Icons.remove,
                          onPressed: () {
                            context
                                .read<PriceSimulatorScreenCubit>()
                                .decrementExpectedGrowthDecline();
                          },
                          iconColor: context.customColor.text1,
                          borderColor: context.customColor.border,
                          backgroundColor: Colors.transparent,
                          padding: 4.r,
                          size: 20.r,
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: _expectedGrowthDeclineController,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.s13W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: context.theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        signed: true,
                                      ),
                                ),
                              ),
                              Text(
                                '%',
                                style: AppStyles.s13W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.horizontalSpace,
                        AppIconButton(
                          icon: Icons.add,
                          onPressed: () {
                            context
                                .read<PriceSimulatorScreenCubit>()
                                .incrementExpectedGrowthDecline();
                          },
                          iconColor: context.customColor.reversedTextColor,
                          borderColor: Colors.transparent,
                          backgroundColor: context.theme.primaryColor,
                          padding: 4.r,
                          size: 20.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          Align(
            alignment: Alignment.center,
            child: AppGestureDetectorButton(
              onTap: () {
                AppBottomSheet.showModal(
                  context,
                  (context) =>
                      const PriceSimulatorWhatIsChangePriceBottomSheet(),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: S.of(context).whatIs,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text3,
                  ),
                  children: [
                    TextSpan(
                      text: S.of(context).changePrice_c,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String assetName,
    String? value,
    bool showCurrency = false,
    Widget? customWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvg(
                assetName: assetName,
                width: 16.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        ?customWidget,
        if (value != null && customWidget == null) ...[
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (showCurrency) const SaudiRiyalSvgWidget(),
                3.horizontalSpace,
                Flexible(
                  child: Text(
                    value,
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
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
                    _selectedBranch.value = branch;
                    _onSelectionChanged();
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
