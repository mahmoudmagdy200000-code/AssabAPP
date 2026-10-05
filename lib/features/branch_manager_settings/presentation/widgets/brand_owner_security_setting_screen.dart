import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/custom_switch_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../cubits/brand_owner_security_setting/brand_owner_security_setting_cubit.dart';
import '../cubits/brand_owner_security_setting/brand_owner_security_setting_state.dart';
import '../models/brand_owner_settings_save_status.dart';

class BrandOwnerSecuritySettingScreen extends StatefulWidget {
  const BrandOwnerSecuritySettingScreen({super.key});

  @override
  State<BrandOwnerSecuritySettingScreen> createState() =>
      _BrandOwnerSecuritySettingScreenState();
}

class _BrandOwnerSecuritySettingScreenState
    extends State<BrandOwnerSecuritySettingScreen> {
  late final BrandOwnerSecuritySettingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BrandOwnerSecuritySettingCubit>()..loadData();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Widget _buildSwitchCard({
    required BuildContext context,
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
                          'Security Settings',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          'Owner Comprehensive Settings',
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
                child: BlocListener<BrandOwnerSecuritySettingCubit, BrandOwnerSecuritySettingState>(
                  listener: (context, state) {
                    if (state is BrandOwnerSecuritySettingLoaded) {
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
                  child: BlocBuilder<BrandOwnerSecuritySettingCubit, BrandOwnerSecuritySettingState>(
                  builder: (context, state) {
                    return switch (state) {
                      BrandOwnerSecuritySettingInitial() =>
                        const AppLoadingWidget(),
                      BrandOwnerSecuritySettingLoading() =>
                        const AppLoadingWidget(),
                      BrandOwnerSecuritySettingFailure(:final failure) =>
                        AppFailureWidget(
                          failure: failure,
                          onRetry: () => context
                              .read<BrandOwnerSecuritySettingCubit>()
                              .loadData(),
                        ),
                      BrandOwnerSecuritySettingLoaded(:final data, :final saveStatus) => Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 3.w,
                                        height: 50.h,
                                        color: context.theme.primaryColor,
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          'Your data is encrypted, backed up daily, and reviewed monthly for security compliance.',
                                          style: AppStyles.s14W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  8.verticalSpace,
                                  _buildSwitchCard(
                                    context: context,
                                    title: 'Data Encryption',
                                    description:
                                        'All information is encrypted to protect against unauthorized access.',
                                    value: data.dataEncryption,
                                    onChanged: _cubit.updateDataEncryption,
                                  ),
                                  8.verticalSpace,
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: context.customColor.border,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(12.r),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Daily Backup',
                                                style: AppStyles.s14W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                              Text(
                                                'System data is securely backed up every 24 hours to prevent loss.',
                                                style: AppStyles.s13W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text3,
                                                    ),
                                              ),
                                              5.verticalSpace,
                                              ContainerCustomTextField(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.r,
                                                  vertical: 14.r,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                label: 'Backup Interval:',
                                                isLabelOptional: false,
                                                isLabelRequired: false,
                                                labelColor:
                                                    context.customColor.text3,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .watch_later_outlined,
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                      size: 16.r,
                                                    ),
                                                    10.horizontalSpace,
                                                    Expanded(
                                                      child: CustomDropdown<int>(
                                                        items: const [
                                                          12,
                                                          24,
                                                          48,
                                                          72,
                                                        ],
                                                        initialValue: data
                                                            .dailyBackupIntervalHours,
                                                        displayTextBuilder:
                                                            (
                                                              value,
                                                            ) => value != null
                                                            ? '$value Hours'
                                                            : 'Select Interval',
                                                        borderRadius: 12.r,
                                                        itemBuilder: (context, item, isSelected) {
                                                          return Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12.r,
                                                                  vertical:
                                                                      10.r,
                                                                ),
                                                            child: Text(
                                                              '$item Hours',
                                                              style: AppStyles.s14W500.copyWith(
                                                                color:
                                                                    isSelected
                                                                    ? context
                                                                          .theme
                                                                          .primaryColor
                                                                    : context
                                                                          .customColor
                                                                          .text1,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        onChanged: (value) => _cubit
                                                            .updateDailyBackupIntervalHours(
                                                              value.toString(),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        CustomSwitchButton(
                                          value: data.dailyBackupEnabled,
                                          onChanged:
                                              _cubit.updateDailyBackupEnabled,
                                        ),
                                      ],
                                    ),
                                  ),
                                  8.verticalSpace,
                                  _buildSwitchCard(
                                    context: context,
                                    title: 'Monthly Security Audit',
                                    description:
                                        'A scheduled review ensures ongoing compliance and system integrity.',
                                    value: data.monthlySecurityAudit,
                                    onChanged:
                                        _cubit.updateMonthlySecurityAudit,
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
                                  padding: EdgeInsets.symmetric(vertical: 14.r),
                                  backgroundColor: Colors.transparent,
                                  borderRadius: 15.r,
                                  textColor: context.customColor.text1,
                                ),
                              ),
                              Expanded(
                                child: AppButton(
                                  text: 'Save Changes',
                                  onClick: () => _cubit.save(),
                                  padding: EdgeInsets.symmetric(vertical: 14.r),
                                  borderRadius: BorderRadius.circular(15.r),
                                  enabled: state.canSubmit &&
                                      saveStatus !=
                                          BrandOwnerSettingsSaveStatus.saving,
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
