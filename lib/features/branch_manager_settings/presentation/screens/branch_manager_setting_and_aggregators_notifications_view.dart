import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/branch_manager_setting_and_aggregators_entity.dart';
import '../cubits/branch_manager_setting_and_aggregators_cubit.dart';

class BranchManagerSettingAndAggregatorsNotificationsView
    extends StatelessWidget {
  final List<BranchManagerNotificationEntity> notifications;

  const BranchManagerSettingAndAggregatorsNotificationsView({
    super.key,
    required this.notifications,
  });

  void _toggleNotification(
    BuildContext context,
    BranchManagerNotificationType type,
    bool value,
  ) {
    context.read<BranchManagerSettingAndAggregatorsCubit>().updateNotification(
      type: type,
      enabled: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(8.r),
      child: SingleChildScrollView(
        child: Column(
          spacing: 12.h,
          children: [
            _buildNotificationItem(
              context,
              title: 'Shift Variance Alerts',
              description:
                  'Get notified whenever a handover report shows sales or payment discrepancies.',
              value: notifications
                  .firstWhere(
                    (item) =>
                        item.type ==
                        BranchManagerNotificationType.shiftVarianceAlerts,
                  )
                  .enabled,
              onTap: (value) {
                _toggleNotification(
                  context,
                  BranchManagerNotificationType.shiftVarianceAlerts,
                  value,
                );
              },
            ),
            _buildNotificationItem(
              context,
              title: 'Daily Inventory Reminders',
              description:
                  'Send push/email reminders to me & staff to start or complete daily inventory tasks.',
              value: notifications
                  .firstWhere(
                    (item) =>
                        item.type ==
                        BranchManagerNotificationType.dailyInventoryReminders,
                  )
                  .enabled,
              onTap: (value) {
                _toggleNotification(
                  context,
                  BranchManagerNotificationType.dailyInventoryReminders,
                  value,
                );
              },
            ),
            _buildNotificationItem(
              context,
              title: 'Approved Aggregators Only',
              description:
                  'Only allow payment platforms you’ve approved, unauthorized ones won’t show up.',
              value: notifications
                  .firstWhere(
                    (item) =>
                        item.type ==
                        BranchManagerNotificationType.approvedAggregatorsOnly,
                  )
                  .enabled,
              onTap: (value) {
                _toggleNotification(
                  context,
                  BranchManagerNotificationType.approvedAggregatorsOnly,
                  value,
                );
              },
            ),
            _buildNotificationItem(
              context,
              title: 'Asset Transfer Requests',
              description:
                  'Get notified instantly when assets are being transferred in or out of your branch.',
              value: notifications
                  .firstWhere(
                    (item) =>
                        item.type ==
                        BranchManagerNotificationType.assetTransferRequests,
                  )
                  .enabled,
              onTap: (value) {
                _toggleNotification(
                  context,
                  BranchManagerNotificationType.assetTransferRequests,
                  value,
                );
              },
            ),
            _buildNotificationItem(
              context,
              title: 'Allow Split Shift Handovers',
              description:
                  'Enable cashiers to hand over in segments (e.g., lunch shift vs. dinner shift).',
              value: notifications
                  .firstWhere(
                    (item) =>
                        item.type ==
                        BranchManagerNotificationType.allowSplitShiftHandovers,
                  )
                  .enabled,
              onTap: (value) {
                _toggleNotification(
                  context,
                  BranchManagerNotificationType.allowSplitShiftHandovers,
                  value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required String title,
    required String description,
    required bool value,
    required void Function(bool value) onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                5.verticalSpace,
                Text(
                  description,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          CustomSwitchButton(value: value, onChanged: onTap),
        ],
      ),
    );
  }
}
