import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../cubits/brand_owner_retention_settings/brand_owner_retention_settings_cubit.dart';
import '../cubits/brand_owner_retention_settings/brand_owner_retention_settings_state.dart';
import '../models/brand_owner_settings_save_status.dart';

class BrandOwnerRetentionSettingsScreen extends StatefulWidget {
  const BrandOwnerRetentionSettingsScreen({super.key});

  @override
  State<BrandOwnerRetentionSettingsScreen> createState() =>
      _BrandOwnerRetentionSettingsScreenState();
}

class _BrandOwnerRetentionSettingsScreenState
    extends State<BrandOwnerRetentionSettingsScreen> {
  late final BrandOwnerRetentionSettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BrandOwnerRetentionSettingsCubit>()..loadData();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Widget _buildDropdownCard({
    required BuildContext context,
    required String title,
    required String description,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        Text(
          description,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
        5.verticalSpace,
        CustomDropdown<int>(
          items: List.generate(10, (index) => index + 1),
          initialValue: value,
          displayTextBuilder: (selected) =>
              selected != null ? '$selected Years' : 'Select value',
          borderRadius: 15.r,
          itemBuilder: (context, item, isSelected) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
              child: Text(
                '$item Years',
                style: AppStyles.s14W500.copyWith(
                  color: isSelected
                      ? context.theme.primaryColor
                      : context.customColor.text1,
                ),
              ),
            );
          },
          onChanged: onChanged,
        ),
      ],
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
                          'Retention Settings',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          'Owner Comprehensive Settings.',
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
                child: BlocListener<BrandOwnerRetentionSettingsCubit, BrandOwnerRetentionSettingsState>(
                  listener: (context, state) {
                    if (state is BrandOwnerRetentionSettingsLoaded) {
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
                  child: BlocBuilder<
                    BrandOwnerRetentionSettingsCubit,
                    BrandOwnerRetentionSettingsState
                  >(
                      builder: (context, state) {
                        return switch (state) {
                          BrandOwnerRetentionSettingsInitial() =>
                            const AppLoadingWidget(),
                          BrandOwnerRetentionSettingsLoading() =>
                            const AppLoadingWidget(),
                          BrandOwnerRetentionSettingsFailure(:final failure) =>
                            AppFailureWidget(
                              failure: failure,
                              onRetry: () => context
                                  .read<BrandOwnerRetentionSettingsCubit>()
                                  .loadData(),
                            ),
                          BrandOwnerRetentionSettingsLoaded(:final data, :final saveStatus) => Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              'Control how long records, logs, and data are stored before automatic deletion or archiving.',
                                              style: AppStyles.s14W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      20.verticalSpace,
                                      _buildDropdownCard(
                                        context: context,
                                        title: 'Photo Retention:',
                                        description:
                                            'Set how long uploaded photos should be stored before automatic deletion.',
                                        value: data.photoRetentionYears,
                                        onChanged:
                                            _cubit.updatePhotoRetentionYears,
                                      ),
                                      10.verticalSpace,
                                      _buildDropdownCard(
                                        context: context,
                                        title: 'Handover Reports:',
                                        description:
                                            'Define the storage duration for submitted handover reports across all branches.',
                                        value:
                                            data.handoverReportsRetentionYears,
                                        onChanged: _cubit
                                            .updateHandoverReportsRetentionYears,
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
