import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/item_test_saved_test_entity.dart';
import '../cubit/item_test_saved_test_details_cubit.dart';
import '../cubit/item_test_saved_tests_cubit.dart';
import '../cubit/item_test_saved_tests_state.dart';
import 'item_test_saved_test_details_bottom_sheet.dart';

class ItemTestSavedTestsBottomSheet extends StatefulWidget {
  final VoidCallback? onNewTest;

  const ItemTestSavedTestsBottomSheet({super.key, this.onNewTest});

  @override
  State<ItemTestSavedTestsBottomSheet> createState() =>
      _ItemTestSavedTestsBottomSheetState();
}

class _ItemTestSavedTestsBottomSheetState
    extends State<ItemTestSavedTestsBottomSheet> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<ItemTestSavedTestsCubit>().loadSavedTests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemTestSavedTestsCubit, ItemTestSavedTestsState>(
      builder: (context, state) {
        return Scaffold(
          body: AppPaddingWidget(
            top: 30.r,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      Text(
                        S.of(context).savedTestsCount(
                          state is ItemTestSavedTestsSuccess
                              ? state.tests.length
                              : 0,
                        ),
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ).sliverBoxAdapter,
                      5.verticalSpace.sliverBoxAdapter,
                      Text(
                        S
                            .of(context)
                            .reviewAndExportPreviouslySavedScenarios,
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
                          border: Border.all(
                            color: context.customColor.border,
                          ),
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
                                controller: _searchController,
                                hintText:
                                    'Search for simulations e.g Special Burger',
                                onChanged: (query) {
                                  context
                                      .read<ItemTestSavedTestsCubit>()
                                      .search(query);
                                },
                              ),
                            ),
                          ],
                        ),
                      ).sliverBoxAdapter,
                      10.verticalSpace.sliverBoxAdapter,
                      switch (state) {
                        ItemTestSavedTestsInit() ||
                        ItemTestSavedTestsLoading() =>
                          const SliverFillRemaining(
                            child: AppLoadingWidget(),
                          ),
                        ItemTestSavedTestsFailure(:final failure) =>
                          SliverFillRemaining(
                            child: AppFailureWidget(
                              failure: failure,
                              onRetry: () => context
                                  .read<ItemTestSavedTestsCubit>()
                                  .loadSavedTests(),
                            ),
                          ),
                        ItemTestSavedTestsSuccess(
                          :final filteredTests,
                        ) =>
                          DecoratedSliver(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            sliver: SliverPadding(
                              padding: EdgeInsetsGeometry.all(12.r),
                              sliver: SliverList.builder(
                                itemCount: filteredTests.length,
                                itemBuilder: (context, index) {
                                  final test = filteredTests[index];
                                  return _buildTestItem(context, test);
                                },
                              ),
                            ),
                          ),
                      },
                    ],
                  ),
                ),
                10.verticalSpace,
                ButtonTextIcon(
                  onTap: () {
                    widget.onNewTest?.call();
                    NavigationService.I.pop();
                  },
                  label: S.of(context).newTest,
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
      },
    );
  }

  Widget _buildTestItem(BuildContext context, ItemTestSavedTestEntity test) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      margin: EdgeInsets.only(bottom: 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSvg(
                assetName: AppAssets.itemTestSvg,
                width: 20.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text1,
                  BlendMode.srcIn,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            test.itemName,
                            style: AppStyles.s13W500.copyWith(
                              color: context.theme.primaryColor,
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: Text(
                            test.branchName,
                            style: AppStyles.s13W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    5.verticalSpace,
                    Text(
                      test.dateTime,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
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
              AppBottomSheet.showModal(
                context,
                isScrollControlled: true,
                (context) => BlocProvider(
                  create: (_) => getIt<ItemTestSavedTestDetailsCubit>(),
                  child: ItemTestSavedTestDetailsBottomSheet(
                    test: test,
                  ),
                ),
              );
            },
            label: S.of(context).viewDetails,
            icon: AppSvg(
              assetName: AppAssets.eye,
              width: 16.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 12.r),
            borderRadius: BorderRadius.circular(15.r),
            spaceBetweenTextAndIcon: 7,
          ),
        ],
      ),
    );
  }
}
