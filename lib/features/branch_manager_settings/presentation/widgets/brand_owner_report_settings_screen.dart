import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../../domain/enums/brand_owner_report_setting_monthly_report_enum.dart';
import '../cubits/brand_owner_report_settings/brand_owner_report_settings_cubit.dart';
import '../cubits/brand_owner_report_settings/brand_owner_report_settings_state.dart';
import '../models/brand_owner_settings_save_status.dart';

class BrandOwnerReportSettingsScreen extends StatefulWidget {
  const BrandOwnerReportSettingsScreen({super.key});

  @override
  State<BrandOwnerReportSettingsScreen> createState() =>
      _BrandOwnerReportSettingsScreenState();
}

class _BrandOwnerReportSettingsScreenState
    extends State<BrandOwnerReportSettingsScreen> {
  late final BrandOwnerReportSettingsCubit _cubit;

  static const List<BrandOwnerReportSettingMonthlyReportEnum> _selections = [
    BrandOwnerReportSettingMonthlyReportEnum.assetStatus,
    BrandOwnerReportSettingMonthlyReportEnum.branchPerformance,
    BrandOwnerReportSettingMonthlyReportEnum.overallInvestment,
  ];

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BrandOwnerReportSettingsCubit>()..loadData();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Widget _buildSelectionSection(
    BuildContext context, {
    required String title,
    required List<BrandOwnerReportSettingMonthlyReportEnum> selected,
    required void Function(BrandOwnerReportSettingMonthlyReportEnum value)
    onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
        ),
        5.verticalSpace,
        Column(
          children: List.generate(_selections.length, (index) {
            final item = _selections[index];
            final isSelected = selected.contains(item);

            return AppGestureDetectorButton(
              onTap: () => onTap(item),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.customColor.border),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
                margin: EdgeInsets.only(
                  bottom: index == _selections.length - 1 ? 0 : 10.r,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    SelectionCircule(isSelected: isSelected),
                  ],
                ),
              ),
            );
          }),
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
                          'Report Settings',
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        Text(
                          'Set what reports are generated, and how often.',
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
                child: BlocListener<BrandOwnerReportSettingsCubit, BrandOwnerReportSettingsState>(
                  listener: (context, state) {
                    if (state is BrandOwnerReportSettingsLoaded) {
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
                      BrandOwnerReportSettingsCubit,
                      BrandOwnerReportSettingsState
                    >(
                      builder: (context, state) {
                        return switch (state) {
                          BrandOwnerReportSettingsInitial() =>
                            const AppLoadingWidget(),
                          BrandOwnerReportSettingsLoading() =>
                            const AppLoadingWidget(),
                          BrandOwnerReportSettingsFailure(:final failure) =>
                            AppFailureWidget(
                              failure: failure,
                              onRetry: () => context
                                  .read<BrandOwnerReportSettingsCubit>()
                                  .loadData(),
                            ),
                          BrandOwnerReportSettingsLoaded(:final data, :final saveStatus) => Column(
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
                                              'Configure your report preferences below:',
                                              style: AppStyles.s14W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      20.verticalSpace,
                                      _buildSelectionSection(
                                        context,
                                        title: 'Monthly Report:',
                                        selected: data.monthlyReports,
                                        onTap: _cubit.toggleMonthlyReport,
                                      ),
                                      10.verticalSpace,
                                      _buildSelectionSection(
                                        context,
                                        title: 'Quarterly Report:',
                                        selected: data.quarterlyReports,
                                        onTap: _cubit.toggleQuarterlyReport,
                                      ),
                                      10.verticalSpace,
                                      _buildSelectionSection(
                                        context,
                                        title: 'Annual Report:',
                                        selected: data.annualReports,
                                        onTap: _cubit.toggleAnnualReport,
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
