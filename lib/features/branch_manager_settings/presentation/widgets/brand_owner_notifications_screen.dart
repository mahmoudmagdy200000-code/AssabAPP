import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_switch_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../data/models/brand_owner_settings_models.dart';
import '../../domain/entities/brand_owner_settings_entities.dart';
import '../cubits/brand_owner_notifications/brand_owner_notifications_cubit.dart';
import '../cubits/brand_owner_notifications/brand_owner_notifications_state.dart';
import '../models/brand_owner_settings_save_status.dart';

class BrandOwnerNotificationsScreen extends StatefulWidget {
  const BrandOwnerNotificationsScreen({super.key});

  @override
  State<BrandOwnerNotificationsScreen> createState() =>
      _BrandOwnerNotificationsScreenState();
}

class _BrandOwnerNotificationsScreenState
    extends State<BrandOwnerNotificationsScreen> {
  late final BrandOwnerNotificationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BrandOwnerNotificationsCubit>()..loadData();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
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
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Text(
                  description,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          CustomSwitchButton(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  bool _isEnabled(
    List<BrandOwnerNotificationEntity> notifications,
    BrandOwnerNotificationSettingType type,
  ) {
    return notifications
        .firstWhere(
          (item) => item.type == type,
          orElse: () => BrandOwnerNotificationModel(type: type, enabled: false),
        )
        .enabled;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.customColor.text2,
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
                          'Notifications & alerts',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          'Customize alerts to keep your workday on track.',
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                padding: EdgeInsets.all(16.r),
                child: BlocListener<BrandOwnerNotificationsCubit, BrandOwnerNotificationsState>(
                  listener: (context, state) {
                    if (state is BrandOwnerNotificationsLoaded) {
                      switch (state.saveStatus) {
                        case BrandOwnerSettingsSaveStatus.idle:
                          AppOverlay.hideCustomOverlay();
                        case BrandOwnerSettingsSaveStatus.saving:
                          AppOverlay.showCustomOverlay(
                            child: const AppLoadingWidget(),
                            barrierDismissible: false,
                            animated: true,
                          );
                        case BrandOwnerSettingsSaveStatus.success:
                          AppOverlay.hideCustomOverlay();
                          AppSnackBar.showSuccess(
                            context,
                            'Changes saved successfully',
                          );
                        case BrandOwnerSettingsSaveStatus.failure:
                          AppOverlay.hideCustomOverlay();
                          if (state.saveFailure != null) {
                            AppDialog.showErrorDialog(
                              context: context,
                              failure: state.saveFailure!,
                            );
                          }
                      }
                    }
                  },
                  child: BlocBuilder<BrandOwnerNotificationsCubit, BrandOwnerNotificationsState>(
                    builder: (context, state) {
                      return switch (state) {
                        BrandOwnerNotificationsInitial() =>
                          const AppLoadingWidget(),
                        BrandOwnerNotificationsLoading() =>
                          const AppLoadingWidget(),
                        BrandOwnerNotificationsFailure(:final failure) =>
                          AppFailureWidget(
                            failure: failure,
                            onRetry: () => context
                                .read<BrandOwnerNotificationsCubit>()
                                .loadData(),
                          ),
                        BrandOwnerNotificationsLoaded(
                          :final data,
                          :final saveStatus,
                        ) =>
                          Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildNotificationCard(
                                        context,
                                        title: 'Audit',
                                        description:
                                            'Get notified when there is a new audit',
                                        value: _isEnabled(
                                          data.notifications,
                                          BrandOwnerNotificationSettingType
                                              .audit,
                                        ),
                                        onChanged: (value) {
                                          _cubit.toggleNotification(
                                            BrandOwnerNotificationSettingType
                                                .audit,
                                            value,
                                          );
                                        },
                                      ),
                                      12.verticalSpace,
                                      _buildNotificationCard(
                                        context,
                                        title: 'Transfer',
                                        description:
                                            'Get notified when there is a new transfer request.',
                                        value: _isEnabled(
                                          data.notifications,
                                          BrandOwnerNotificationSettingType
                                              .transfer,
                                        ),
                                        onChanged: (value) {
                                          _cubit.toggleNotification(
                                            BrandOwnerNotificationSettingType
                                                .transfer,
                                            value,
                                          );
                                        },
                                      ),
                                      12.verticalSpace,
                                      _buildNotificationCard(
                                        context,
                                        title: 'Status Modification',
                                        description:
                                            'You’ll be alerted when an employee submits an asset status update.',
                                        value: _isEnabled(
                                          data.notifications,
                                          BrandOwnerNotificationSettingType
                                              .statusModification,
                                        ),
                                        onChanged: (value) {
                                          _cubit.toggleNotification(
                                            BrandOwnerNotificationSettingType
                                                .statusModification,
                                            value,
                                          );
                                        },
                                      ),
                                      12.verticalSpace,
                                      _buildNotificationCard(
                                        context,
                                        title: 'Handover',
                                        description:
                                            'Get notified when there is a new handover request (E.g Cash, Assets ,Shifts, etc).',
                                        value: _isEnabled(
                                          data.notifications,
                                          BrandOwnerNotificationSettingType
                                              .handover,
                                        ),
                                        onChanged: (value) {
                                          _cubit.toggleNotification(
                                            BrandOwnerNotificationSettingType
                                                .handover,
                                            value,
                                          );
                                        },
                                      ),
                                      12.verticalSpace,
                                      _buildNotificationCard(
                                        context,
                                        title: 'Major Discrepancies',
                                        description:
                                            'Get notified when there is a discrepancy in asset or cash handovers/transfers.',
                                        value: _isEnabled(
                                          data.notifications,
                                          BrandOwnerNotificationSettingType
                                              .majorDiscrepancies,
                                        ),
                                        onChanged: (value) {
                                          _cubit.toggleNotification(
                                            BrandOwnerNotificationSettingType
                                                .majorDiscrepancies,
                                            value,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              20.verticalSpace,
                              Row(
                                spacing: 10.w,
                                children: [
                                  Expanded(
                                    child: CustomTextButton(
                                      text: 'Reset to Default',
                                      onTap: () => _cubit.resetToDefaults(),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.r,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      borderRadius: 15.r,
                                      textColor: context.customColor.text1,
                                    ),
                                  ),
                                  Expanded(
                                    child: AppButton(
                                      text: 'Save Changes',
                                      onClick: () => _cubit.save(),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.r,
                                      ),
                                      borderRadius: BorderRadius.circular(15.r),
                                      enabled:
                                          state.canSubmit &&
                                          saveStatus !=
                                              BrandOwnerSettingsSaveStatus
                                                  .saving,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      };
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
