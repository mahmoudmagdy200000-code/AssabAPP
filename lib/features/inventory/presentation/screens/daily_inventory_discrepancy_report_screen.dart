import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/inventory/presentation/widgets/daily_comprehensive_actions_bottom_sheet.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/app_check_box.dart';
import '../widgets/daily_discrepancy_quick_actions_bottom_sheet.dart';

class DailyInventoryDiscrepancyReportScreen extends StatelessWidget {
  const DailyInventoryDiscrepancyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PagingCubit(totalSteps: 3),
      child: const _DailyInventoryDiscrepancyReportScreenContent(),
    );
  }
}

class _DailyInventoryDiscrepancyReportScreenContent extends StatelessWidget {
  const _DailyInventoryDiscrepancyReportScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            _buildTitleCard(context),
            10.verticalSpace,
            _buildTabs(context),
            10.verticalSpace,
            Expanded(
              child: BlocBuilder<PagingCubit, PagingState>(
                builder: (context, state) {
                  return IndexedStack(
                    index: state.currentIndex,
                    children: [
                      _buildDiscrepancyTab(context),
                      _buildDetailsTab(context),
                      _buildTimelinesTab(context),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const AppBackButton(),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.timeDiscrepancyReport('July 6'),
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                6.verticalSpace,
                Text(
                  context.tr.reviewDiscrepanciesAndTakeActions,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabData = [
      context.tr.discrepancy,
      context.tr.details,
      context.tr.timelines,
    ];

    return ContainerCustomTextField(
      borderColor: Colors.transparent,
      borderRadius: BorderRadius.circular(1000.r),
      padding: EdgeInsets.all(6.r),
      child: Row(
        children: List.generate(
          tabData.length,
          (index) => _buildTabItem(context, tabData[index], index),
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String text, int index) {
    return BlocBuilder<PagingCubit, PagingState>(
      builder: (context, state) {
        final isSelected = state.currentIndex == index;

        return Expanded(
          child: AppGestureDetectorButton(
            onTap: () => context.read<PagingCubit>().goToStep(index),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.customColor.reversedTextColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(1000.r),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppStyles.s12W500.copyWith(
                  color: isSelected
                      ? context.customColor.text1
                      : context.customColor.text3,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscrepancyTab(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: context.customColor.text2,
            ),
            padding: EdgeInsets.all(16.r),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDiscrepancySummary(context),
                  16.verticalSpace,
                  _buildDiscrepantProducts(context),
                ],
              ),
            ),
          ),
        ),
        20.verticalSpace,
        _buildFooterButtons(context),
      ],
    );
  }

  Widget _buildDetailsTab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSessionSummary(context),
            16.verticalSpace,
            _buildGroupedSummary(context),
            16.verticalSpace,
            _buildActions(context),
            16.verticalSpace,
            _buildFinalCheckpoints(context),
            16.verticalSpace,
            _buildNextSteps(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalCheckpoints(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Final Checkpoints:',
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              _buildCheckpoint(context, context.tr.allProductsInventoried),
              8.verticalSpace,
              _buildCheckpoint(
                context,
                context.tr.quantitiesAccurateAndReviewed,
              ),
              8.verticalSpace,
              _buildCheckpoint(context, context.tr.noInputErrors),
              8.verticalSpace,
              _buildCheckpoint(context, context.tr.specialNotesRecorded),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCheckpoint(BuildContext context, String text) {
    return Row(
      children: [
        AppCheckBox(
          onChanged: (value) {},
          value: true,
          selectedColor: AppColors.lightGreen,
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
      ],
    );
  }

  Widget _buildNextSteps(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.nextSteps,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            context
                .tr
                .sendDataToAccountantSalesInputFromExternalSystemDiscrepancyReportWillArriveWithinHours,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelinesTab(BuildContext context) {
    return Center(
      child: Text(context.tr.timelinesContentHere, style: AppStyles.s14W400),
    );
  }

  Widget _buildDiscrepancySummary(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.tr.discrepancySummary,
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ),

            /// TODO: Build Status Depend On Api
          ],
        ),
        5.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  AppSvg(
                    assetName: AppAssets.box,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text3,
                      BlendMode.srcIn,
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.productsWithDiscrepancies,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                  5.horizontalSpace,
                  Text(
                    '2',
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.error,
                    ),
                  ),
                  Text(
                    '/12',
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                children: [
                  AppCheckBox(
                    onChanged: (value) {},
                    value: true,
                    selectedColor: AppColors.lightGreen,
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.matchingProducts,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                  5.horizontalSpace,
                  Text(
                    '10',
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  Text(
                    '/12',
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                children: [
                  AppSvg(
                    assetName: AppAssets.cash,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text3,
                      BlendMode.srcIn,
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.totalDiscrepancyValue,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                  5.horizontalSpace,
                  const SaudiRiyalSvgWidget(),
                  Text(
                    '-22',
                    style: AppStyles.s13WB.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                children: [
                  AppSvg(
                    assetName: AppAssets.receipt,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text3,
                      BlendMode.srcIn,
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.discrepancyType,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.shortageStockDeficit,
                      textAlign: TextAlign.end,
                      style: AppStyles.s13WB.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscrepantProducts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.productsRequiringClarificationCount(2),
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        12.verticalSpace,
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final products = [
              {
                'name': 'Fresh Milk - Nadec',
                'theoretical': '50 L',
                'actual': '45 L',
                'difference': '-5 L',
                'value': 'SAR 625.00',
              },
              {
                'name': 'Mozzarella Cheese - Almarai',
                'theoretical': '20 KG',
                'actual': '18 KG',
                'difference': '-2 KG',
                'value': 'SAR 625.00',
              },
            ];

            final product = products[index];
            return Column(
              children: [
                _buildDiscrepancyProductCard(context, product),
                if (index != 1) 12.verticalSpace,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDiscrepancyProductCard(
    BuildContext context,
    Map<String, String> product,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.customColor.reversedTextColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PurchaseItemImage(),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  product['name']!,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.openingBalanceTitle,
            product['theoretical']!,
            isInline: true,
          ),
          8.verticalSpace,
          _buildField(
            context,
            null,
            '${context.tr.purchases}:',
            product['actual']!,
            isInline: true,
          ),
          8.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.sales,
            product['difference']!,
            isInline: true,
          ),
          8.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.recordedWaste,
            product['value']!,
            isInline: true,
          ),
          8.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.netTransferIn,
            product['value']!,
            isInline: true,
          ),
          8.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.netTransferOut,
            product['value']!,
            isInline: true,
          ),
          25.verticalSpace,
          _buildField(
            context,
            AppAssets.chart,
            context.tr.theoreticallyExpected,
            product['value']!,
            isInline: true,
            iconColor: context.theme.primaryColor,
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.chart,
            context.tr.actualFromInventory,
            product['value']!,
            isInline: true,
            iconColor: context.theme.primaryColor,
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.calc,
            '${context.tr.difference}:',
            product['value']!,
            isInline: true,
            iconColor: context.theme.primaryColor,
          ),
          20.verticalSpace,
          ButtonTextIcon(
            onTap: () {
              AppBottomSheet.show(
                context,
                (context) => const DailyDiscrepancyQuickActionsBottomSheet(),
              );
            },
            label: context.tr.quickActions,
            icon: Icon(Icons.keyboard_arrow_down_outlined, size: 20.r),
            backgroundColor: context.customColor.text2,
            borderRadius: BorderRadius.circular(1000.r),
            reversed: true,
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvg(
              assetName: AppAssets.clockSvg,
              width: 18.r,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
            5.horizontalSpace,
            Text(
              context.tr.timeLimit24Hours,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ),
        5.verticalSpace,
        CustomTextButton(
          text: context.tr.overallComprehensiveActions,
          onTap: () {
            AppBottomSheet.show(
              context,
              (context) => const DailyComprehensiveActionsBottomSheet(),
            );
          },
          backgroundColor: context.theme.primaryColor,
          textColor: context.customColor.reversedTextColor,
          borderRadius: 20.r,
          padding: EdgeInsets.symmetric(vertical: 16.r),
        ),
      ],
    );
  }

  Widget _buildSessionSummary(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.tr.sessionSummary,
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
        ),
        12.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCFA),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Text(
            context.tr.discrepancyFound,
            style: AppStyles.s10W500.copyWith(color: const Color(0xFFE3640F)),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupedSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          _buildField(
            context,
            AppAssets.calendar02,
            context.tr.inventoryDate,
            'June 17, 2025',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.time04,
            context.tr.startTime,
            '9:33 Am',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.timer,
            context.tr.timeTaken,
            '8 minutes \n15 seconds',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.profileIcon,
            context.tr.performedBy,
            'Ahmed Mohammed (${context.tr.branchManager})',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.package,
            context.tr.completedProducts,
            '12/12 (100%)',
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.allInventoriedProductsCount(12),
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        12.verticalSpace,
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildProductCard(context, 'Fresh Beef', '20 L', note: 'asdas'),
                if (index != 4) 12.verticalSpace,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    String name,
    String quantity, {
    String? note,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: context.customColor.reversedTextColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PurchaseItemImage(),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  name,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          5.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.quantity,
            quantity,
            isInline: true,
          ),
          if (note != null) ...[
            8.verticalSpace,
            Text(
              context.tr.additionalNote,
              style: AppStyles.s14W600.copyWith(
                color: context.customColor.text3,
              ),
            ),
            5.verticalSpace,
            Text(
              note,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField(
    BuildContext context,
    String? icon,
    String label,
    String value, {
    bool isInline = false,
    Color? iconColor,
  }) {
    if (isInline) {
      return Row(
        children: [
          if (icon != null) ...[
            AppSvg(
              assetName: icon,
              width: 14.w,
              height: 14.h,
              colorFilter: ColorFilter.mode(
                iconColor ?? context.customColor.text3,
                BlendMode.srcIn,
              ),
            ),
            8.horizontalSpace,
          ],
          Text(
            label,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          8.horizontalSpace,
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        if (icon != null) ...[
          AppSvg(
            assetName: icon,
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              iconColor ?? context.customColor.text3,
              BlendMode.srcIn,
            ),
          ),
          8.horizontalSpace,
        ],
        Text(
          label,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
        const Spacer(),
        Text(
          value,
          style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
