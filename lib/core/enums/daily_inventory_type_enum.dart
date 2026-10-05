import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/inventory/data/models/daily_inventory_list_response.dart';
import '../../features/inventory/data/models/wasted_damage_list_response.dart';
import '../../features/inventory/presentation/cubit/inventory_approve_reject_staff_submition/inventory_approve_reject_staff_submition_cubit.dart';
import '../constants/app_assets.dart';
import '../di/dependency_injection.dart';
import '../widgets/saudi_riyal_svg_widget.dart';

enum DailyInventoryTypeEnum {
  personal('personal'),
  staff('staff');

  final String _value;

  const DailyInventoryTypeEnum(this._value);

  String get value => _value;

  static DailyInventoryTypeEnum fromValue(String value) {
    return DailyInventoryTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DailyInventoryTypeEnum.personal,
    );
  }

  Widget buildDailyStatusDetails(
    BuildContext context,
    DailyInventoryListResponseSession details,
  ) {
    switch (this) {
      case DailyInventoryTypeEnum.personal:
        return details.status.buildStatusDetails(context);
      case DailyInventoryTypeEnum.staff:
        return details.status.buildStatusDetailsStaff(
          context,
          details: details,
        );
    }
  }

  Widget buildDetailsActionToStaffButtons(
    BuildContext context,
    DailyInventoryListResponseSession details,
  ) {
    switch (this) {
      case DailyInventoryTypeEnum.personal:
        return const SizedBox.shrink();
      case DailyInventoryTypeEnum.staff:
        return Column(
          children: [
            12.verticalSpace,
            BlocProvider(
              create: (context) =>
                  getIt<InventoryApproveRejectStaffSubmitionCubit>(),
              child: details.status.buildDetailsActionToStaffButtons(
                context,
                details,
              ),
            ),
          ],
        );
    }
  }

  Widget buildWasteDamageStatusDetails(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    switch (this) {
      case DailyInventoryTypeEnum.personal:
        return details.status.buildStatusWasteDamageDetails(context, details);
      case DailyInventoryTypeEnum.staff:
        return details.status.buildStatusWasteDamageDetailsStaff(
          context,
          details,
        );
    }
  }

  Widget buildWasteDamageDetailsButtons(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    switch (this) {
      case DailyInventoryTypeEnum.personal:
        return const SizedBox.shrink();
      case DailyInventoryTypeEnum.staff:
        return Column(
          children: [
            12.verticalSpace,
            BlocProvider(
              create: (context) =>
                  getIt<InventoryApproveRejectStaffSubmitionCubit>(),
              child: details.status.buildWasteDamageDetailsActionToStaffButtons(
                context,
                details,
              ),
            ),
          ],
        );
    }
  }

  Widget buildGroupedSummary(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    switch (this) {
      case DailyInventoryTypeEnum.personal:
        return _buildGroupedSummaryPersonal(context, details);
      case DailyInventoryTypeEnum.staff:
        return _buildGroupedSummaryStaff(context, details);
    }
  }

  Widget _buildGroupedSummaryPersonal(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    final info = details.assignmentInformation;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          _buildField(
            context,
            AppAssets.personSvg,
            context.tr.assigned_by,
            '${info.assignedByName} (${info.assignedByRole})',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.detailsSvg,
            context.tr.responsibility,
            info.responsibility,
          ),
          8.verticalSpace,
          _buildField(context, AppAssets.timer, context.tr.timing, info.timing),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.detailsSvg,
            context.tr.review,
            info.review,
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.warning,
            context.tr.reminder,
            info.reminder,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedSummaryStaff(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    final info = details.assignmentInformation;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          _buildField(
            context,
            AppAssets.personSvg,
            context.tr.assigned_by,
            '${details.creator.name} (${info.assignedByRole})',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.personSvg,
            context.tr.registeredBy,
            '${info.assignedByName} (${context.tr.assigned})',
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.clockSvg,
            context.tr.registrationTime,
            DateFormatter.formatTimeHM(
              DateTime.tryParse(details.createdAt),
            ).toString(),
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.box,
            context.tr.numberOfItems,
            details.itemsCount.toString(),
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.cash,
            context.tr.totalValue,
            details.items
                .fold(0.0, (sum, item) => sum + item.totalValue)
                .toStringAsFixed(2),
          ),
          8.verticalSpace,
          _buildField(
            context,
            AppAssets.warning,
            context.tr.signature,
            context.tr.inBranchAsBranchManager(details.creator.name),
          ),
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
