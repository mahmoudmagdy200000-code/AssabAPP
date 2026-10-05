import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/brand_owner_branch_entity.dart';
import '../../domain/entities/item_test_result_entity.dart';
import '../cubit/brand_owner_branches_for_filter_cubit.dart';
import '../cubit/brand_owner_branches_for_filter_state.dart';
import '../cubit/item_test_save_result_cubit.dart';
import '../cubit/item_test_saved_tests_cubit.dart';
import '../cubit/item_test_screen_cubit.dart';
import '../cubit/item_test_screen_state.dart';
import '../widgets/item_test_result_bottom_sheet.dart';
import '../widgets/item_test_saved_tests_bottom_sheet.dart';

class BrandOwnerTestItemScreen extends StatefulWidget {
  const BrandOwnerTestItemScreen({super.key});

  @override
  State<BrandOwnerTestItemScreen> createState() =>
      _BrandOwnerTestItemScreenState();
}

class _BrandOwnerTestItemScreenState extends State<BrandOwnerTestItemScreen> {
  late final ValueNotifier<bool> _branchDropDownOpen;
  late final ValueNotifier<BrandOwnerBranchEntity?> _selectedBranch;
  late final TextEditingController _itemNameController;
  late final TextEditingController _expectedSellingPriceController;
  late final TextEditingController _productionCostController;
  late final TextEditingController _expectedSalesController;
  late final TextEditingController _expectedGrowthController;
  late final ValueNotifier<bool> _isFormValid;

  @override
  void initState() {
    super.initState();
    context.read<BrandOwnerBranchesForFilterCubit>().loadBranches();
    context.read<ItemTestScreenCubit>().initializeForm();
    _branchDropDownOpen = ValueNotifier<bool>(false);
    _selectedBranch = ValueNotifier<BrandOwnerBranchEntity?>(null);
    _itemNameController = TextEditingController();
    _expectedSellingPriceController = TextEditingController();
    _productionCostController = TextEditingController();
    _expectedSalesController = TextEditingController();
    _expectedGrowthController = TextEditingController();
    _isFormValid = ValueNotifier<bool>(false);
    _setupFormValidationListeners();
  }

  void _setupFormValidationListeners() {
    _selectedBranch.addListener(_scheduleValidation);

    _itemNameController.addListener(_scheduleValidation);
    _expectedSellingPriceController.addListener(_scheduleValidation);
    _productionCostController.addListener(_scheduleValidation);
    _expectedSalesController.addListener(_scheduleValidation);
    _expectedGrowthController.addListener(_scheduleValidation);

    _updateFormValidity();
  }

  void _scheduleValidation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormValidity();
    });
  }

  bool _isValidDouble(String value) {
    final text = value.trim();
    if (text.isEmpty) return false;
    final parsed = double.tryParse(text);
    return parsed != null && parsed > 0;
  }

  bool _isValidInt(String value) {
    final text = value.trim();
    if (text.isEmpty) return false;
    final parsed = int.tryParse(text);
    return parsed != null && parsed > 0;
  }

  void _updateFormValidity() {
    final isValid =
        _selectedBranch.value != null &&
        _itemNameController.text.trim().isNotEmpty &&
        _isValidDouble(_expectedSellingPriceController.text) &&
        _isValidDouble(_productionCostController.text) &&
        _isValidInt(_expectedSalesController.text) &&
        _isValidDouble(_expectedGrowthController.text);

    _isFormValid.value = isValid;
  }

  @override
  void dispose() {
    _branchDropDownOpen.dispose();
    _selectedBranch.dispose();
    _itemNameController.dispose();
    _expectedSellingPriceController.dispose();
    _productionCostController.dispose();
    _expectedSalesController.dispose();
    _expectedGrowthController.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  void _onNewTest() {
    _itemNameController.clear();
    _expectedSellingPriceController.clear();
    _productionCostController.clear();
    _expectedSalesController.clear();
    _expectedGrowthController.clear();
    _selectedBranch.value = null;
    context.read<ItemTestScreenCubit>().newTest();
  }

  void _onStartTest() {
    final branch = _selectedBranch.value;
    if (branch == null) return;

    final cubit = context.read<ItemTestScreenCubit>();

    cubit.updateItemName(_itemNameController.text.trim());
    cubit.updateExpectedSellingPrice(
      double.tryParse(_expectedSellingPriceController.text) ?? 0,
    );
    cubit.updateProductionCost(
      double.tryParse(_productionCostController.text) ?? 0,
    );
    cubit.updateExpectedSales(int.tryParse(_expectedSalesController.text) ?? 0);
    cubit.updateExpectedGrowth(
      double.tryParse(_expectedGrowthController.text) ?? 0,
    );

    cubit.submitTest(branchId: branch.id, branchName: branch.name);
  }

  void _openResultBottomSheet(ItemTestResultEntity result) {
    AppBottomSheet.customPageRoute(
      context,
      (context) => BlocProvider(
        create: (_) => getIt<ItemTestSaveResultCubit>(),
        child: ItemTestResultBottomSheet(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemTestScreenCubit, ItemTestScreenState>(
      listener: (context, state) {
        switch (state) {
          case ItemTestScreenSubmitSuccess(:final result):
            _openResultBottomSheet(result);
          case ItemTestScreenSubmitFailure(:final failure):
            AppDialog.showErrorDialog(context: context, failure: failure);
          default:
            break;
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
                          S.of(context).itemTesting,
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
                  BlocBuilder<ItemTestScreenCubit, ItemTestScreenState>(
                    builder: (context, state) {
                      return state is ItemTestScreenSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: AppLoadingWidget(),
                            )
                          : AppSvgButton(
                              assetName: AppAssets.receipt,
                              onTap: () {
                                AppBottomSheet.customPageRoute(
                                  context,
                                  (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (_) =>
                                            getIt<ItemTestSavedTestsCubit>(),
                                      ),
                                    ],
                                    child: ItemTestSavedTestsBottomSheet(
                                      onNewTest: _onNewTest,
                                    ),
                                  ),
                                );
                              },
                              iconSize: 20.r,
                              bgColor: context.customColor.text2,
                              iconColor: context.customColor.text1,
                            );
                    },
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
                                  ],
                                ),
                              ),
                              10.verticalSpace,
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
                                      S.of(context).itemData,
                                      style: AppStyles.s14W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                    10.verticalSpace,
                                    const CustomDivider(),
                                    10.verticalSpace,
                                    _buildRow(
                                      context: context,
                                      title: S.of(context).itemName,
                                      assetName: AppAssets.box,
                                      customWidget: Flexible(
                                        child: ContainerCustomTextField(
                                          padding: EdgeInsets.all(6.r),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: CustomTextField(
                                                  controller:
                                                      _itemNameController,
                                                  hintText: S
                                                      .of(context)
                                                      .enterName,
                                                  maxLines: 1,
                                                  onChanged: (value) {
                                                    context
                                                        .read<
                                                          ItemTestScreenCubit
                                                        >()
                                                        .updateItemName(value);
                                                  },
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              AppSvg(
                                                assetName: AppAssets.edit,
                                                width: 16.r,
                                                colorFilter: ColorFilter.mode(
                                                  context.theme.primaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    const CustomDivider(),
                                    10.verticalSpace,
                                    _buildRow(
                                      context: context,
                                      title: S.of(context).expectedSellingPrice,
                                      assetName: AppAssets.wallet,
                                      customWidget: Flexible(
                                        child: ContainerCustomTextField(
                                          padding: EdgeInsets.all(6.r),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: CustomTextField(
                                                  controller:
                                                      _expectedSellingPriceController,
                                                  hintText: '0',
                                                  maxLines: 1,
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: true,
                                                        signed: false,
                                                      ),
                                                  onChanged: (value) {
                                                    context
                                                        .read<
                                                          ItemTestScreenCubit
                                                        >()
                                                        .updateExpectedSellingPrice(
                                                          double.tryParse(
                                                                value,
                                                              ) ??
                                                              0,
                                                        );
                                                  },
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              AppSvg(
                                                assetName: AppAssets.edit,
                                                width: 16.r,
                                                colorFilter: ColorFilter.mode(
                                                  context.theme.primaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              const SaudiRiyalSvgWidget(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    const CustomDivider(),
                                    10.verticalSpace,
                                    _buildRow(
                                      context: context,
                                      title: S.of(context).productionCost,
                                      assetName: AppAssets.expenseSvg,
                                      customWidget: Flexible(
                                        child: ContainerCustomTextField(
                                          padding: EdgeInsets.all(6.r),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: CustomTextField(
                                                  controller:
                                                      _productionCostController,
                                                  hintText: '0',
                                                  maxLines: 1,
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: true,
                                                        signed: false,
                                                      ),
                                                  onChanged: (value) {
                                                    context
                                                        .read<
                                                          ItemTestScreenCubit
                                                        >()
                                                        .updateProductionCost(
                                                          double.tryParse(
                                                                value,
                                                              ) ??
                                                              0,
                                                        );
                                                  },
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              AppSvg(
                                                assetName: AppAssets.edit,
                                                width: 16.r,
                                                colorFilter: ColorFilter.mode(
                                                  context.theme.primaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              const SaudiRiyalSvgWidget(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    const CustomDivider(),
                                    10.verticalSpace,
                                    _buildRow(
                                      context: context,
                                      title: S.of(context).expectedSales,
                                      assetName: AppAssets.custody,
                                      customWidget: Flexible(
                                        child: ContainerCustomTextField(
                                          padding: EdgeInsets.all(6.r),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: CustomTextField(
                                                  controller:
                                                      _expectedSalesController,
                                                  hintText: '0',
                                                  maxLines: 1,
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: false,
                                                        signed: false,
                                                      ),
                                                  onChanged: (value) {
                                                    context
                                                        .read<
                                                          ItemTestScreenCubit
                                                        >()
                                                        .updateExpectedSales(
                                                          int.tryParse(value) ??
                                                              0,
                                                        );
                                                  },
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              Flexible(
                                                child: Text(
                                                  'Pieces',
                                                  style: AppStyles.s12W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text3,
                                                      ),
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              AppSvg(
                                                assetName: AppAssets.edit,
                                                width: 16.r,
                                                colorFilter: ColorFilter.mode(
                                                  context.theme.primaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.verticalSpace,
                                    const CustomDivider(),
                                    10.verticalSpace,
                                    _buildRow(
                                      context: context,
                                      title: S.of(context).expectedGrowth,
                                      assetName: AppAssets.over,
                                      customWidget: Flexible(
                                        child: ContainerCustomTextField(
                                          padding: EdgeInsets.all(6.r),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: CustomTextField(
                                                  controller:
                                                      _expectedGrowthController,
                                                  hintText: '0',
                                                  maxLines: 1,
                                                  keyboardType:
                                                      const TextInputType.numberWithOptions(
                                                        decimal: true,
                                                        signed: true,
                                                      ),
                                                  onChanged: (value) {
                                                    context
                                                        .read<
                                                          ItemTestScreenCubit
                                                        >()
                                                        .updateExpectedGrowth(
                                                          double.tryParse(
                                                                value,
                                                              ) ??
                                                              0,
                                                        );
                                                  },
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              AppSvg(
                                                assetName: AppAssets.edit,
                                                width: 16.r,
                                                colorFilter: ColorFilter.mode(
                                                  context.theme.primaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              const SaudiRiyalSvgWidget(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: context.customColor.reversedTextColor,
                      padding: EdgeInsets.all(10.r),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonTextIcon(
                              onTap: _onNewTest,
                              label: S.of(context).newTest,
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
                            child:
                                BlocBuilder<
                                  ItemTestScreenCubit,
                                  ItemTestScreenState
                                >(
                                  builder: (context, state) {
                                    if (state is ItemTestScreenSubmitting) {
                                      return const AppLoadingWidget();
                                    }

                                    return ValueListenableBuilder<bool>(
                                      valueListenable: _isFormValid,
                                      builder: (context, isFormValid, _) {
                                        return AppButton(
                                          onClick: _onStartTest,
                                          text: S.of(context).startTest,
                                          enabled: isFormValid,
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
                                        );
                                      },
                                    );
                                  },
                                ),
                          ),
                        ],
                      ),
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

                    _scheduleValidation();
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
