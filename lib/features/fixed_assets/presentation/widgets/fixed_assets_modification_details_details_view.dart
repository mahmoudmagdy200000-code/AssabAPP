import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:flutter/material.dart';

import '../../data/models/fixed_assets_modify_details_response.dart';
import 'modify_asset_status_asset_details_widget.dart';

class FixedAssetsModificationDetailsDetailsView extends StatelessWidget {
  final FixedAssetsModifyDetailsResponse details;

  const FixedAssetsModificationDetailsDetailsView({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          details.status.buildStatusModificationDetailsWidget(context),
          12.verticalSpace,
          ModifyAssetStatusAssetDetailsWidget(asset: details.assetDetails),
          12.verticalSpace,
          _ModificationDetailsCard(details: details.modificationDetails),
          12.verticalSpace,
          _RequiredActionsCard(requiredActions: details.requiredActions),
        ],
      ),
    );
  }
}

class _ModificationDetailsCard extends StatelessWidget {
  final FixedAssetsModificationDetails details;

  const _ModificationDetailsCard({required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.modificationDetails,
            style: AppStyles.s16W600.copyWith(color: AppColors.lightText),
          ),
          12.verticalSpace,
          const CustomDivider(),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  context.tr.newStatus,
                  style: AppStyles.s12W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 15.r,
                      color: details.newStatus.color,
                    ),
                    5.horizontalSpace,
                    Flexible(
                      child: Text(
                        details.newStatus.label(context),
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          12.verticalSpace,
          ContainerCustomTextField(
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    details.reason,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          12.verticalSpace,
          Text(
            '${context.tr.documentationPhotos} (1)',
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          12.verticalSpace,
          NetworkFilePreviewWidget(attachmentModel: details.attachment),
        ],
      ),
    );
  }
}

class _RequiredActionsCard extends StatelessWidget {
  final FixedAssetsRequiredActions requiredActions;

  const _RequiredActionsCard({required this.requiredActions});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.requiredActions,
            style: AppStyles.s16W600.copyWith(color: AppColors.lightText),
          ),
          12.verticalSpace,
          const CustomDivider(),
          12.verticalSpace,
          _KeyValueRow(
            label: context.tr.doneActions,
            value: requiredActions.doneActions
                .map((e) => '${e.label(context)} -')
                .join('\n'),
          ),
          12.verticalSpace,
          _KeyValueRow(
            label: context.tr.nextActions,
            value: requiredActions.nextAction.label(context),
          ),
          12.verticalSpace,
          ContainerCustomTextField(
            backgroundColor: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    requiredActions.approvalRequestOwnerNote,
                    style: AppStyles.s13W400.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _KeyValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            value,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
