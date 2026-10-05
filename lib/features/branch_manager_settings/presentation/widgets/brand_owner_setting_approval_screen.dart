import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_overlay.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../cubits/brand_owner_setting_approval/brand_owner_setting_approval_cubit.dart';
import '../cubits/brand_owner_setting_approval/brand_owner_setting_approval_state.dart';
import '../models/brand_owner_settings_save_status.dart';

class BrandOwnerSettingApprovalScreen extends StatefulWidget {
  const BrandOwnerSettingApprovalScreen({super.key});

  @override
  State<BrandOwnerSettingApprovalScreen> createState() =>
      _BrandOwnerSettingApprovalScreenState();
}

class _BrandOwnerSettingApprovalScreenState
    extends State<BrandOwnerSettingApprovalScreen> {
  late final BrandOwnerSettingApprovalCubit _cubit;
  late final TextEditingController _minimumAssetsController;
  late final TextEditingController _excellentRatioController;
  late final TextEditingController _transferController;
  late final TextEditingController _modificationController;
  late final TextEditingController _disposalController;
  bool _syncingControllers = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<BrandOwnerSettingApprovalCubit>()..loadData();
    _minimumAssetsController = TextEditingController();
    _excellentRatioController = TextEditingController();
    _transferController = TextEditingController();
    _modificationController = TextEditingController();
    _disposalController = TextEditingController();

    _minimumAssetsController.addListener(_handleMinimumAssetsChanged);
    _excellentRatioController.addListener(_handleExcellentRatioChanged);
    _transferController.addListener(_handleTransferChanged);
    _modificationController.addListener(_handleModificationChanged);
    _disposalController.addListener(_handleDisposalChanged);
  }

  @override
  void dispose() {
    _minimumAssetsController.removeListener(_handleMinimumAssetsChanged);
    _excellentRatioController.removeListener(_handleExcellentRatioChanged);
    _transferController.removeListener(_handleTransferChanged);
    _modificationController.removeListener(_handleModificationChanged);
    _disposalController.removeListener(_handleDisposalChanged);

    _minimumAssetsController.dispose();
    _excellentRatioController.dispose();
    _transferController.dispose();
    _modificationController.dispose();
    _disposalController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _syncControllersFromData(BrandOwnerSettingApprovalLoaded state) {
    if (_syncingControllers) return;

    _syncingControllers = true;
    _minimumAssetsController.text = state.data.initialAuditMinimumAssets == 0
        ? ''
        : state.data.initialAuditMinimumAssets.toString();
    _excellentRatioController.text = state.data.initialAuditExcellentRatio == 0
        ? ''
        : state.data.initialAuditExcellentRatio.toString();
    _transferController.text = state.data.autoApproveTransfersWithin == 0
        ? ''
        : state.data.autoApproveTransfersWithin.toString();
    _modificationController.text =
        state.data.autoApproveModificationsWithin == 0
        ? ''
        : state.data.autoApproveModificationsWithin.toString();
    _disposalController.text = state.data.autoApproveDisposalsWithin == 0
        ? ''
        : state.data.autoApproveDisposalsWithin.toString();
    _syncingControllers = false;
  }

  void _handleMinimumAssetsChanged() {
    if (_syncingControllers) return;
    _cubit.updateInitialAuditMinimumAssets(_minimumAssetsController.text);
  }

  void _handleExcellentRatioChanged() {
    if (_syncingControllers) return;
    _cubit.updateInitialAuditExcellentRatio(_excellentRatioController.text);
  }

  void _handleTransferChanged() {
    if (_syncingControllers) return;
    _cubit.updateAutoApproveTransfersWithin(_transferController.text);
  }

  void _handleModificationChanged() {
    if (_syncingControllers) return;
    _cubit.updateAutoApproveModificationsWithin(_modificationController.text);
  }

  void _handleDisposalChanged() {
    if (_syncingControllers) return;
    _cubit.updateAutoApproveDisposalsWithin(_disposalController.text);
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String hintText,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return ContainerCustomTextField(
      backgroundColor: context.customColor.reversedTextColor,
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
      borderColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      label: label,
      isLabelOptional: false,
      isLabelRequired: false,
      labelColor: context.customColor.text3,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: controller,
              hintText: hintText,
              keyboardType: keyboardType,
            ),
          ),
          if (suffix != null) ...[10.horizontalSpace, suffix],
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.r),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.customColor.text2,
        body: BlocListener<BrandOwnerSettingApprovalCubit, BrandOwnerSettingApprovalState>(
          listener: (context, state) {
            if (state is BrandOwnerSettingApprovalLoaded) {
              if (!state.isDirty) {
                _syncControllersFromData(state);
              }

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
          child: Column(
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
                            'Approval Settings',
                            style: AppStyles.s16W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          Text(
                            'Control who approves what, and when.',
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
                  child:
                      BlocBuilder<
                        BrandOwnerSettingApprovalCubit,
                        BrandOwnerSettingApprovalState
                      >(
                        builder: (context, state) {
                          return switch (state) {
                            BrandOwnerSettingApprovalInitial() =>
                              const AppLoadingWidget(),
                            BrandOwnerSettingApprovalLoading() =>
                              const AppLoadingWidget(),
                            BrandOwnerSettingApprovalFailure(:final failure) =>
                              AppFailureWidget(
                                failure: failure,
                                onRetry: () => context
                                    .read<BrandOwnerSettingApprovalCubit>()
                                    .loadData(),
                              ),
                            BrandOwnerSettingApprovalLoaded(
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
                                          Row(
                                            children: [
                                              Container(
                                                width: 3.w,
                                                height: 50.h,
                                                color:
                                                    context.theme.primaryColor,
                                              ),
                                              10.horizontalSpace,
                                              Expanded(
                                                child: Text(
                                                  'Set thresholds and rules for audits, financial actions, and approval workflows across branches.',
                                                  style: AppStyles.s14W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text3,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          20.verticalSpace,
                                          Text(
                                            'Response Time',
                                            style: AppStyles.s16W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          5.verticalSpace,
                                          CustomDropdown<int>(
                                            items: const [12, 24, 48, 72],
                                            initialValue:
                                                data.responseTimeHours,
                                            displayTextBuilder: (value) =>
                                                value != null
                                                ? '$value Hours'
                                                : 'Select Response Time',
                                            borderRadius: 15.r,
                                            itemBuilder:
                                                (context, item, isSelected) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12.r,
                                                          vertical: 10.r,
                                                        ),
                                                    child: Text(
                                                      '$item Hours',
                                                      style: AppStyles.s14W500
                                                          .copyWith(
                                                            color: isSelected
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
                                            onChanged: (value) {
                                              _cubit.updateResponseTimeHours(
                                                value,
                                              );
                                            },
                                          ),
                                          10.verticalSpace,
                                          Text(
                                            'Initial Audit',
                                            style: AppStyles.s16W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          5.verticalSpace,
                                          _buildCard(
                                            context,
                                            Column(
                                              children: [
                                                _buildTextField(
                                                  context: context,
                                                  label: 'Minimum Assets:',
                                                  controller:
                                                      _minimumAssetsController,
                                                  hintText: '0',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  suffix: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: context
                                                        .customColor
                                                        .text1,
                                                    size: 16.r,
                                                  ),
                                                ),
                                                10.verticalSpace,
                                                _buildTextField(
                                                  context: context,
                                                  label: 'Excellent Ratio:',
                                                  controller:
                                                      _excellentRatioController,
                                                  hintText: '85',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  suffix: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: context
                                                        .customColor
                                                        .text1,
                                                    size: 16.r,
                                                  ),
                                                ),
                                                10.verticalSpace,
                                                ContainerCustomTextField(
                                                  backgroundColor: context
                                                      .customColor
                                                      .reversedTextColor,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12.r,
                                                    vertical: 10.r,
                                                  ),
                                                  borderColor:
                                                      Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                  labelColor:
                                                      context.customColor.text3,
                                                  child: Row(
                                                    children: [
                                                      AppCheckBox(
                                                        onChanged: _cubit
                                                            .updatePersonalApprovalForAllNewBranches,
                                                        value: data
                                                            .personalApprovalForAllNewBranches,
                                                      ),
                                                      10.horizontalSpace,
                                                      Expanded(
                                                        child: Text(
                                                          'Personal Approval for All New Branches',
                                                          style: AppStyles
                                                              .s12W500
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text1,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          10.verticalSpace,
                                          Text(
                                            'Financial Approval Limits:',
                                            style: AppStyles.s16W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          5.verticalSpace,
                                          _buildCard(
                                            context,
                                            Column(
                                              children: [
                                                _buildTextField(
                                                  context: context,
                                                  label:
                                                      'Auto Approve Transfers within:',
                                                  controller:
                                                      _transferController,
                                                  hintText: '20000',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  suffix:
                                                      const SaudiRiyalSvgWidget(),
                                                ),
                                                10.verticalSpace,
                                                _buildTextField(
                                                  context: context,
                                                  label:
                                                      'Auto Approve Modifications within:',
                                                  controller:
                                                      _modificationController,
                                                  hintText: '15000',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  suffix:
                                                      const SaudiRiyalSvgWidget(),
                                                ),
                                                10.verticalSpace,
                                                _buildTextField(
                                                  context: context,
                                                  label:
                                                      'Auto Approve Disposals within:',
                                                  controller:
                                                      _disposalController,
                                                  hintText: '10000',
                                                  keyboardType:
                                                      TextInputType.number,
                                                  suffix:
                                                      const SaudiRiyalSvgWidget(),
                                                ),
                                                10.verticalSpace,
                                                ContainerCustomTextField(
                                                  backgroundColor: context
                                                      .customColor
                                                      .reversedTextColor,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12.r,
                                                    vertical: 10.r,
                                                  ),
                                                  borderColor:
                                                      Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                  labelColor:
                                                      context.customColor.text3,
                                                  child: Row(
                                                    children: [
                                                      AppCheckBox(
                                                        onChanged: _cubit
                                                            .updateCriticalAssetsAlwaysRequireApproval,
                                                        value: data
                                                            .criticalAssetsAlwaysRequireApproval,
                                                      ),
                                                      10.horizontalSpace,
                                                      Expanded(
                                                        child: Text(
                                                          'Critical Assets Always Require Approval',
                                                          style: AppStyles
                                                              .s12W500
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text1,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                          borderRadius: BorderRadius.circular(
                                            15.r,
                                          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
