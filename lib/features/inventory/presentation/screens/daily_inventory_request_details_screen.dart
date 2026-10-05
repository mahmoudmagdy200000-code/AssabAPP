import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/daily_inventory_type_enum.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/daily_inventory_list_response.dart';

class DailyInventoryRequestDetailsScreen extends StatelessWidget {
  final DailyInventoryListResponseSession request;

  const DailyInventoryRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PagingCubit(totalSteps: 2),
      child: _DailyInventoryRequestDetailsScreenContent(request: request),
    );
  }
}

class _DailyInventoryRequestDetailsScreenContent extends StatelessWidget {
  final DailyInventoryListResponseSession request;

  const _DailyInventoryRequestDetailsScreenContent({required this.request});

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
                      _buildDetailsTab(context),
                      TimeLinesView(timelines: request.timelines.timelines),
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
      decoration: BoxDecoration(color: context.customColor.reversedTextColor),
      child: Row(
        children: [
          const AppBackButton(),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.dateDailyInventoryDetails(
                    DateFormatter.formatDateMDY(
                          DateTime.tryParse(request.inventoryDate ?? ''),
                        ) ??
                        '-',
                  ),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Expanded(
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
          ),
          if (request.isStaffInventored &&
              !request.isBranchManagerConfirm &&
              request.assignedToType == DailyInventoryTypeEnum.staff)
            request.assignedToType.buildDetailsActionToStaffButtons(
              context,
              request,
            ),
        ],
      ),
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
        request.assignedToType.buildDailyStatusDetails(context, request),
      ],
    );
  }

  Widget _buildGroupedSummary(BuildContext context) {
    return Container(
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
            DateFormatter.formatDateMDY(
                  DateTime.tryParse(request.inventoryDate ?? ''),
                ) ??
                '-',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.time04,
            context.tr.startTime,
            DateFormatter.formatTimeHM(DateTime.tryParse(request.startTime)) ??
                '-',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.timer,
            context.tr.timeTaken,
            request.timeTaken ?? '-',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.personSvg,
            context.tr.performedBy,
            request.performedBy.name,
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.package,
            context.tr.completedProducts,
            '${request.items.length}/${request.items.length} (100%)',
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
          context.tr.allInventoriedProductsCount(request.items.length),
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        12.verticalSpace,
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: request.items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildProductCard(
                  context,
                  request.items[index].item.name,
                  request.items[index].item.logo,
                  request.items[index].quantityInventory.toString(),
                  note: request.items[index].notes,
                ),
                if (index != request.items.length - 1) 12.verticalSpace,
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
    String? image,
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
              PurchaseItemImage(image: image),
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

  Widget _buildFinalCheckpoints(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.finalCheckpoints,
          style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
        ),
        8.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
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
            color: context.customColor.reversedTextColor,
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

  Widget _buildField(
    BuildContext context,
    String? icon,
    String label,
    String value, {
    bool isInline = false,
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
            child: Text(
              value,
              style: AppStyles.s12W500.copyWith(
                color: context.customColor.text1,
              ),
              textAlign: TextAlign.end,
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
          child: Text(
            value,
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
