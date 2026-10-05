import 'package:assab/core/enums/daily_inventory_type_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/profile_image_widget.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/wasted_damage_list_response.dart';
import '../../domain/strategies/cause_of_damage_strategy.dart';

class WasteDamageDetailsScreen extends StatelessWidget {
  final WastedDamageListDetails details;

  const WasteDamageDetailsScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              children: [
                const AppBackButton(),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.reportDetails,
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        context.tr.viewDetailsTimelinesAndStatuses,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _buildTabs(context),
                  10.verticalSpace,
                  Expanded(
                    child: BlocBuilder<PagingCubit, PagingState>(
                      builder: (context, state) {
                        return IndexedStack(
                          index: state.currentIndex,
                          children: [
                            _buildDetailsTab(context),
                            TimeLinesView(
                              timelines: details.timelines.timelines,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabData = [context.tr.details, context.tr.timelines];

    return ContainerCustomTextField(
      borderColor: Colors.transparent,
      borderRadius: BorderRadius.circular(1000.r.r),
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

  Widget _buildDetailsTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          details.assignedToType.buildWasteDamageStatusDetails(
            context,
            details,
          ),
          12.verticalSpace,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: context.customColor.text2,
            ),
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.assignmentInformation,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                16.verticalSpace,
                details.assignedToType.buildGroupedSummary(context, details),
                16.verticalSpace,
                _buildActions(context),
              ],
            ),
          ),
          if (details.isStaffInventored &&
              !details.isBranchManagerConfirm &&
              details.assignedToType == DailyInventoryTypeEnum.staff)
            details.assignedToType.buildWasteDamageDetailsButtons(
              context,
              details,
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final items = details.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.selectedProductCount(items.length),
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        12.verticalSpace,
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildProductCard(context, items[index]),
                if (index != items.length - 1) 12.verticalSpace,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, WastedDamageListItem item) {
    final showResponsibleEmployees =
        (item.causeOfDamage is MeAndOrOtherEmployeesStrategy ||
            item.causeOfDamage is MixeFactorsStrategy) &&
        item.responsibleEmployees.isNotEmpty;
    final note = item.justificationText ?? item.justificationNote;

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
              PurchaseItemImage(image: item.photoUrl),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  item.productName,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          5.verticalSpace,
          Align(
            alignment: Alignment.center,
            child: Text(
              context.tr.productInformation,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          5.verticalSpace,
          const CustomDivider(),
          5.verticalSpace,
          Row(
            children: [
              Flexible(
                child: _buildField(
                  context,
                  null,
                  context.tr.problemType,
                  item.problemTypeLabel,
                  isInline: true,
                ),
              ),
              5.horizontalSpace,
              AppSvg(
                assetName: AppAssets.trashSvg,
                width: 12.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          if (item.responsibility != null) ...[
            5.verticalSpace,
            const CustomDivider(),
            5.verticalSpace,
            Row(
              children: [
                Flexible(
                  child: _buildField(
                    context,
                    null,
                    context.tr.responsibility,
                    item.responsibility!,
                    isInline: true,
                  ),
                ),
                5.horizontalSpace,
                AppSvg(
                  assetName: AppAssets.personSvg,
                  width: 12.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text3,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ],
          5.verticalSpace,
          const CustomDivider(),
          5.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.quantityWasted,
            '${item.quantityWasted} ${item.unit}',
            isInline: true,
          ),
          5.verticalSpace,
          const CustomDivider(),
          5.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.reason,
            item.reasonLabel,
            isInline: true,
          ),
          5.verticalSpace,
          const CustomDivider(),
          5.verticalSpace,
          _buildField(
            context,
            null,
            context.tr.totalValue,
            item.totalValue.toString(),
            isInline: true,
            showCurrency: true,
          ),
          if (showResponsibleEmployees)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: context.customColor.text2,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
              margin: EdgeInsets.only(top: 12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.responsibleEmployeess,
                    style: AppStyles.s16W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  12.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: context.customColor.reversedTextColor,
                    ),
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12.h,
                      children: [
                        for (final emp in item.responsibleEmployees)
                          _buildEmployeeItem(context, emp, item.unit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (note != null) ...[
            8.verticalSpace,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              ),
            ),
          ],
          if (item.explanatoryPhotoUrl != null) ...[
            8.verticalSpace,
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.explanatoryPhoto,
                    style: AppStyles.s14W600.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  5.verticalSpace,
                  AppNetworkImage(
                    image: item.explanatoryPhotoUrl!,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmployeeItem(
    BuildContext context,
    WastedDamageListResponsibleEmployee employee,
    String unit,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileImageWidget(image: null),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.employeeName,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              5.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.symmetric(horizontal: 17.r, vertical: 10.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        employee.quantityAccountable.toString(),
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      '/ $unit',
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context,
    String? icon,
    String label,
    String value, {
    bool isInline = false,
    bool showCurrency = false,
  }) {
    if (isInline) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10.w,
        children: [
          Flexible(
            child: Row(
              children: [
                if (icon != null) ...[
                  AppSvg(
                    assetName: icon,
                    width: 16.r,
                    colorFilter: ColorFilter.mode(
                      context.customColor.text3,
                      BlendMode.srcIn,
                    ),
                  ),
                  8.horizontalSpace,
                ],
                Flexible(
                  child: Text(
                    label,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (showCurrency) const SaudiRiyalSvgWidget(),
                Flexible(
                  child: Text(
                    value,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text1,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10.w,
      children: [
        Flexible(
          child: Row(
            children: [
              if (icon != null) ...[
                AppSvg(
                  assetName: icon,
                  width: 16.r,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text3,
                    BlendMode.srcIn,
                  ),
                ),
                8.horizontalSpace,
              ],
              Flexible(
                child: Text(
                  label,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showCurrency) const SaudiRiyalSvgWidget(),
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
