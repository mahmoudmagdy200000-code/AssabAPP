import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_local_failure.dart';
import '../cubit/fixd_assets_active_handover_approval/fixd_assets_active_handover_approval_cubit.dart';
import '../cubit/fixd_assets_active_handover_approval/fixd_assets_active_handover_approval_state.dart';
import '../cubit/get_active_handover_session_details/get_active_handover_session_details_cubit.dart';
import '../cubit/get_active_handover_session_details/get_active_handover_session_details_state.dart';
import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/media/media_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_file_image.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';

import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/fixed_assets_active_handover_session_details_response.dart';
import '../../data/models/fixed_assets_active_handover_approve_zone_request.dart';
import '../../domain/enums/fixed_assets_condition_enum.dart';
import '../widgets/fixed_assets_active_handover_approve_all_bottom_sheet_widget.dart';

class FixedAssetsActiveHandoverSessionZoneAssetsDetailsView
    extends StatelessWidget {
  final String sessionId;

  const FixedAssetsActiveHandoverSessionZoneAssetsDetailsView({
    super.key,
    required this.sessionId,
  });

  String _inspectionKey(String assetId) => 'handoverInspection_$assetId';

  String _noteKey(String assetId) => 'handoverNote_$assetId';

  String _photoKey(String assetId) => 'handoverPhoto_$assetId';

  String _newQtyKey(String assetId) => 'handoverNewQty_$assetId';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetActiveHandoverSessionDetailsCubit,
      GetActiveHandoverSessionDetailsState
    >(
      builder: (context, state) {
        if (state is GetActiveHandoverSessionDetailsLoading) {
          return const AppLoadingWidget();
        } else if (state is GetActiveHandoverSessionDetailsFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () {
              context
                  .read<GetActiveHandoverSessionDetailsCubit>()
                  .getActiveHandoverSessionDetails(sessionId: sessionId);
            },
          );
        } else if (state is GetActiveHandoverSessionDetailsSuccess) {
          return _buildSessionDetails(context, response: state.response);
        }

        return AppLocalFailure(
          onRetry: () {
            context
                .read<GetActiveHandoverSessionDetailsCubit>()
                .getActiveHandoverSessionDetails(sessionId: sessionId);
          },
        );
      },
    );
  }

  Widget _buildSessionDetails(
    BuildContext context, {
    required FixedAssetsActiveHandoverSessionDetailsResponse response,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    final anyZoneApproved = response.zones.any((zone) => zone.isZoneApproved);
    final allZonesApproved =
        response.zones.isNotEmpty &&
        response.zones.every((zone) => zone.isZoneApproved);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr.zoneDetails,
          style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
        ),
        Row(
          children: [
            Flexible(
              child: Text(
                context.tr.reviewZonesDesc(response.zones.length),
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ),
            10.verticalSpace,
            BlocBuilder<
              FixdAssetsActiveHandoverApprovalCubit,
              FixdAssetsActiveHandoverApprovalState
            >(
              builder: (context, approvalState) {
                if (anyZoneApproved &&
                    approvalState
                        is! FixdAssetsActiveHandoverApprovalAllLoading) {
                  return const SizedBox.shrink();
                }

                if (approvalState
                    is FixdAssetsActiveHandoverApprovalAllLoading) {
                  return AppButtonLoading(width: 110.w);
                }

                return ButtonTextIcon(
                  onTap: () {
                    final approvalCubit = context
                        .read<FixdAssetsActiveHandoverApprovalCubit>();

                    AppBottomSheet.showModal(
                      context,
                      (context) => BlocProvider.value(
                        value: approvalCubit,
                        child:
                            FixedAssetsActiveHandoverApproveAllBottomSheetWidget(
                              sessionId: response.sessionId,
                              zones: response.zones,
                            ),
                      ),
                    );
                  },
                  label: context.tr.approveAll,
                  icon: const AppSvg(assetName: AppAssets.check),
                  textColor: context.customColor.reversedTextColor,
                  backgroundColor: context.theme.primaryColor,
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(1000.r),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                );
              },
            ),
          ],
        ),
        20.verticalSpace,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(8.r),
            child: ListView.builder(
              itemCount: response.zones.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final zone = response.zones[index];

                return BlocBuilder<
                  FixdAssetsActiveHandoverApprovalCubit,
                  FixdAssetsActiveHandoverApprovalState
                >(
                  builder: (context, approvalState) {
                    final isZoneLoading =
                        approvalState
                                is FixdAssetsActiveHandoverApprovalZoneLoading &&
                            approvalState.loadingZoneIds.contains(
                              zone.zoneId,
                            ) ||
                        approvalState
                                is FixdAssetsActiveHandoverApprovalZoneSuccess &&
                            approvalState.loadingZoneIds.contains(
                              zone.zoneId,
                            ) ||
                        approvalState
                                is FixdAssetsActiveHandoverApprovalFailure &&
                            approvalState.loadingZoneIds.contains(zone.zoneId);
                    final isZoneApprovedByState =
                        zone.isZoneApproved ||
                        approvalState
                                is FixdAssetsActiveHandoverApprovalZoneSuccess &&
                            approvalState.zoneId == zone.zoneId;
                    final isAllLocked =
                        approvalState
                            is FixdAssetsActiveHandoverApprovalAllLoading ||
                        allZonesApproved;
                    final isZoneLocked =
                        isAllLocked || isZoneLoading || isZoneApprovedByState;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index != 0) 10.verticalSpace,
                        Text(
                          zone.zoneName,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        5.verticalSpace,
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, assetIndex) {
                            final asset = zone.assets[assetIndex];

                            return BlocBuilder<
                              ValidationCubit,
                              ValidationState
                            >(
                              builder: (context, validationState) {
                                final inspectionKey = _inspectionKey(
                                  asset.assetId,
                                );
                                final noteKey = _noteKey(asset.assetId);
                                final photoKey = _photoKey(asset.assetId);
                                final newQtyKey = _newQtyKey(asset.assetId);

                                final inspectionValue =
                                    validationState.getTypedValue<String>(
                                      inspectionKey,
                                    ) ??
                                    FixedAssetsConditionEnum.excellent.value;
                                final selectedCondition =
                                    FixedAssetsConditionEnum.fromString(
                                      inspectionValue,
                                    );

                                const conditions =
                                    FixedAssetsConditionEnum.values;
                                final showRecipientDetails =
                                    selectedCondition !=
                                    FixedAssetsConditionEnum.excellent;

                                final newQty = validationState
                                    .getTypedValue<int>(newQtyKey);
                                final hasNewQty = newQty != null;
                                final newQtyValue = newQty ?? asset.currentQty;

                                final recipientNote = validationState
                                    .getTypedValue<String>(noteKey);
                                final recipientPhotoPath = validationState
                                    .getTypedValue<String>(photoKey);

                                final isPhotoRequired =
                                    selectedCondition ==
                                    FixedAssetsConditionEnum.problem;
                                final isPhotoOptional =
                                    selectedCondition ==
                                    FixedAssetsConditionEnum.needAttention;

                                return BlocProvider(
                                  create: (context) => getIt<MediaCubit>(),
                                  child: BlocListener<MediaCubit, MediaState>(
                                    listener: (context, mediaState) {
                                      if (mediaState is MediaLoaded) {
                                        final files = mediaState.allFiles
                                            .where((file) => file.selected)
                                            .toList();
                                        final selectedPath = files.isNotEmpty
                                            ? files.first.path
                                            : null;

                                        if (selectedPath !=
                                            recipientPhotoPath) {
                                          validationCubit
                                              .validateFieldAndStoreTypedValue<
                                                String?
                                              >(
                                                fieldName: photoKey,
                                                value: selectedPath,
                                                isValid:
                                                    selectedPath?.isNotEmpty ==
                                                    true,
                                              );
                                        }
                                      }
                                    },
                                    child: IgnorePointer(
                                      ignoring: isZoneLocked,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context
                                              .customColor
                                              .reversedTextColor,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(10.r),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: AppNetworkImage(
                                                    image: asset.assetImageUrl,
                                                    height: 60.r,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.r,
                                                        ),
                                                  ),
                                                ),
                                                10.horizontalSpace,
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        asset.assetName,
                                                        style: AppStyles.s14W500
                                                            .copyWith(
                                                              color: context
                                                                  .customColor
                                                                  .text1,
                                                            ),
                                                      ),
                                                      5.verticalSpace,
                                                      Text(
                                                        asset.assetCode,
                                                        style: AppStyles.s13W400
                                                            .copyWith(
                                                              color: context
                                                                  .customColor
                                                                  .text3,
                                                            ),
                                                      ),
                                                      5.verticalSpace,
                                                      Text(
                                                        zone.zoneName,
                                                        style: AppStyles.s13W400
                                                            .copyWith(
                                                              color: context
                                                                  .customColor
                                                                  .text3,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            10.verticalSpace,
                                            const CustomDivider(),
                                            10.verticalSpace,
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: ContainerCustomTextField(
                                                    label: hasNewQty
                                                        ? context.tr.newQuantity
                                                        : context.tr.quantity,
                                                    child: CustomTextField(
                                                      key: ValueKey(
                                                        '${newQtyKey}_$newQtyValue',
                                                      ),
                                                      initialValue: newQtyValue
                                                          .toString(),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      isEnabled: !isZoneLocked,
                                                      onChanged: (value) {
                                                        final parsedQty =
                                                            int.tryParse(value);
                                                        final updatedQty =
                                                            parsedQty == null ||
                                                                parsedQty ==
                                                                    asset
                                                                        .currentQty
                                                            ? null
                                                            : parsedQty;

                                                        validationCubit
                                                            .validateFieldAndStoreTypedValue<
                                                              int?
                                                            >(
                                                              fieldName:
                                                                  newQtyKey,
                                                              value: updatedQty,
                                                              isValid:
                                                                  updatedQty !=
                                                                  null,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                if (hasNewQty) ...[
                                                  10.horizontalSpace,
                                                  Flexible(
                                                    child:
                                                        ContainerCustomTextField(
                                                          label: context
                                                              .tr
                                                              .quantity,
                                                          child: CustomTextField(
                                                            initialValue: asset
                                                                .currentQty
                                                                .toString(),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            isEnabled: false,
                                                          ),
                                                        ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            10.verticalSpace,
                                            const LabelTextField(
                                              text: 'Recipient Inspection',
                                            ),
                                            Column(
                                              children: List.generate(conditions.length, (
                                                conditionIndex,
                                              ) {
                                                final condition =
                                                    conditions[conditionIndex];
                                                final strategy = condition
                                                    .toStrategy();
                                                final isSelected =
                                                    condition ==
                                                    selectedCondition;

                                                return Column(
                                                  children: [
                                                    strategy.buildRecipientInspectionWidget(
                                                      context,
                                                      isSelected: isSelected,
                                                      onTap: isZoneLocked
                                                          ? null
                                                          : () {
                                                              validationCubit
                                                                  .validateFieldAndStoreTypedValue<
                                                                    String
                                                                  >(
                                                                    fieldName:
                                                                        inspectionKey,
                                                                    value: condition
                                                                        .value,
                                                                    isValid:
                                                                        true,
                                                                  );

                                                              if (condition ==
                                                                  FixedAssetsConditionEnum
                                                                      .excellent) {
                                                                validationCubit
                                                                    .validateFieldAndStoreTypedValue<
                                                                      String?
                                                                    >(
                                                                      fieldName:
                                                                          noteKey,
                                                                      value:
                                                                          null,
                                                                      isValid:
                                                                          false,
                                                                    );
                                                                validationCubit
                                                                    .validateFieldAndStoreTypedValue<
                                                                      String?
                                                                    >(
                                                                      fieldName:
                                                                          photoKey,
                                                                      value:
                                                                          null,
                                                                      isValid:
                                                                          false,
                                                                    );
                                                              }
                                                            },
                                                    ),
                                                    if (conditionIndex !=
                                                        conditions.length - 1)
                                                      10.verticalSpace,
                                                  ],
                                                );
                                              }),
                                            ),
                                            if (showRecipientDetails) ...[
                                              10.verticalSpace,
                                              const LabelTextField(
                                                text: 'Recipient Notes',
                                              ),
                                              ContainerCustomTextField(
                                                child: CustomTextField(
                                                  key: ValueKey(
                                                    '${noteKey}_${recipientNote ?? ''}',
                                                  ),
                                                  maxLines: 4,
                                                  initialValue: recipientNote,
                                                  isEnabled: !isZoneLocked,
                                                  onChanged: (value) {
                                                    validationCubit
                                                        .validateFieldAndStoreTypedValue<
                                                          String?
                                                        >(
                                                          fieldName: noteKey,
                                                          value: value.isEmpty
                                                              ? null
                                                              : value,
                                                          isValid:
                                                              value.isNotEmpty,
                                                        );
                                                  },
                                                  hintText:
                                                      'Describe the issue you are reporting',
                                                ),
                                              ),
                                              10.verticalSpace,
                                              LabelTextField(
                                                text: 'Photo Evidence',
                                                isLabelOptional:
                                                    isPhotoOptional,
                                                isLabelRequired:
                                                    isPhotoRequired,
                                              ),
                                              IgnorePointer(
                                                ignoring: isZoneLocked,
                                                child:
                                                    const UploadExpenseInvoiceReceipt(
                                                      singleSelectionMode: true,
                                                    ),
                                              ),
                                              BlocSelector<
                                                MediaCubit,
                                                MediaState,
                                                MediaFile?
                                              >(
                                                selector: (state) {
                                                  if (state is MediaLoaded) {
                                                    final files = state.allFiles
                                                        .where(
                                                          (file) =>
                                                              file.selected,
                                                        )
                                                        .toList();

                                                    if (files.isNotEmpty) {
                                                      return files.first;
                                                    }
                                                  }

                                                  return null;
                                                },
                                                builder: (context, mediaFile) {
                                                  final photoPath =
                                                      mediaFile?.path ??
                                                      recipientPhotoPath;

                                                  return photoPath != null
                                                      ? Column(
                                                          children: [
                                                            10.verticalSpace,
                                                            Stack(
                                                              children: [
                                                                AppFileImage(
                                                                  image:
                                                                      photoPath,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .zero,
                                                                ),
                                                                Positioned(
                                                                  top: 5,
                                                                  right: 5,
                                                                  child: AppGestureDetectorButton(
                                                                    onTap:
                                                                        isZoneLocked
                                                                        ? () {}
                                                                        : () {
                                                                            if (mediaFile !=
                                                                                null) {
                                                                              context
                                                                                  .read<
                                                                                    MediaCubit
                                                                                  >()
                                                                                  .unselectFile(
                                                                                    mediaFile,
                                                                                  );
                                                                            }

                                                                            validationCubit.validateFieldAndStoreTypedValue<
                                                                              String?
                                                                            >(
                                                                              fieldName: photoKey,
                                                                              value: null,
                                                                              isValid: false,
                                                                            );
                                                                          },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: context
                                                                            .customColor
                                                                            .dark
                                                                            .withValues(
                                                                              alpha: 0.4,
                                                                            ),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                            5.r,
                                                                          ),
                                                                      child: AppSvg(
                                                                        assetName:
                                                                            AppAssets.trashSvg,
                                                                        width:
                                                                            20.r,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox();
                                                },
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) =>
                              10.verticalSpace,
                          itemCount: zone.assets.length,
                        ),
                        10.verticalSpace,
                        if (approvalState
                            is FixdAssetsActiveHandoverApprovalAllLoading)
                          const AppButtonLoading()
                        else if (zone.isZoneApproved)
                          CustomTextButton(
                            text: context.tr.zoneApproved,
                            onTap: () {},
                            textColor: context.customColor.text3,
                            backgroundColor: context.customColor.text3
                                .withValues(alpha: 0.2),
                            borderColor: Colors.transparent,
                            borderRadius: 1000.r,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.r,
                              vertical: 8.r,
                            ),
                          )
                        else
                          BlocBuilder<ValidationCubit, ValidationState>(
                            builder: (context, validationState) {
                              final canApproveZone = zone.assets.every((asset) {
                                final inspectionKey = _inspectionKey(
                                  asset.assetId,
                                );
                                final noteKey = _noteKey(asset.assetId);
                                final photoKey = _photoKey(asset.assetId);

                                final inspection =
                                    validationState.getTypedValue<String>(
                                      inspectionKey,
                                    ) ??
                                    FixedAssetsConditionEnum.excellent.value;
                                final selectedCondition =
                                    FixedAssetsConditionEnum.fromString(
                                      inspection,
                                    );

                                // Excellent: no extra requirements
                                if (selectedCondition ==
                                    FixedAssetsConditionEnum.excellent) {
                                  return true;
                                }

                                final note = validationState
                                    .getTypedValue<String>(noteKey);
                                final isNoteValid =
                                    note != null && note.isNotEmpty;

                                final isNoteRequired =
                                    selectedCondition !=
                                    FixedAssetsConditionEnum.excellent;
                                if (isNoteRequired && !isNoteValid) {
                                  return false;
                                }

                                final isPhotoRequired =
                                    selectedCondition ==
                                    FixedAssetsConditionEnum.problem;
                                if (isPhotoRequired) {
                                  final photoPath = validationState
                                      .getTypedValue<String>(photoKey);
                                  if (photoPath == null || photoPath.isEmpty) {
                                    return false;
                                  }
                                }

                                return true;
                              });

                              return Row(
                                children: [
                                  Expanded(
                                    child: isZoneLoading
                                        ? const AppButtonLoading()
                                        : AppButton(
                                            text: context.tr.approveZone,
                                            onClick: () {
                                              final validationState =
                                                  validationCubit.state;

                                              final request =
                                                  FixedAssetsActiveHandoverApproveZoneRequest(
                                                    sessionId:
                                                        response.sessionId,
                                                    zoneId: zone.zoneId,
                                                    assets: zone.assets.map((
                                                      asset,
                                                    ) {
                                                      final inspectionKey =
                                                          _inspectionKey(
                                                            asset.assetId,
                                                          );
                                                      final noteKey = _noteKey(
                                                        asset.assetId,
                                                      );
                                                      final photoKey =
                                                          _photoKey(
                                                            asset.assetId,
                                                          );
                                                      final newQtyKey =
                                                          _newQtyKey(
                                                            asset.assetId,
                                                          );

                                                      final inspection =
                                                          validationState
                                                              .getTypedValue<
                                                                String
                                                              >(
                                                                inspectionKey,
                                                              ) ??
                                                          FixedAssetsConditionEnum
                                                              .excellent
                                                              .value;
                                                      final isDefaultInspection =
                                                          inspection ==
                                                          FixedAssetsConditionEnum
                                                              .excellent
                                                              .value;
                                                      final note =
                                                          isDefaultInspection
                                                          ? null
                                                          : validationState
                                                                .getTypedValue<
                                                                  String
                                                                >(noteKey);
                                                      final photoPath =
                                                          isDefaultInspection
                                                          ? null
                                                          : validationState
                                                                .getTypedValue<
                                                                  String
                                                                >(photoKey);
                                                      final newQty =
                                                          validationState
                                                              .getTypedValue<
                                                                int
                                                              >(newQtyKey);

                                                      return FixedAssetsActiveHandoverApproveZoneAssetRequest(
                                                        assetId: asset.assetId,
                                                        recipientInspection:
                                                            inspection,
                                                        recipientNote: note,
                                                        recipientPhotoPath:
                                                            photoPath,
                                                        newQty: newQty,
                                                      );
                                                    }).toList(),
                                                  );

                                              context
                                                  .read<
                                                    FixdAssetsActiveHandoverApprovalCubit
                                                  >()
                                                  .approveZone(
                                                    request: request,
                                                  );
                                            },
                                            textColor: canApproveZone
                                                ? context
                                                      .customColor
                                                      .reversedTextColor
                                                : context.customColor.text3,
                                            borderColor: Colors.transparent,
                                            background: canApproveZone
                                                ? context.theme.primaryColor
                                                : context.customColor.text3
                                                      .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              1000.r,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.r,
                                              vertical: 8.r,
                                            ),
                                            enabled: canApproveZone,
                                          ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        20.verticalSpace,
        AppButton(
          onClick: () {
            context.read<PagingCubit>().nextStep();
          },
          text: context.tr.nextReviewAssets,
          enabled: allZonesApproved,
        ),
        BlocListener<
          FixdAssetsActiveHandoverApprovalCubit,
          FixdAssetsActiveHandoverApprovalState
        >(
          listener: (context, approvalState) {
            if (approvalState is FixdAssetsActiveHandoverApprovalAllSuccess ||
                approvalState is FixdAssetsActiveHandoverApprovalZoneSuccess) {
              context
                  .read<GetActiveHandoverSessionDetailsCubit>()
                  .refreshActiveHandoverSessionDetails();
            } else if (approvalState
                is FixdAssetsActiveHandoverApprovalFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: approvalState.failure,
              );
            }
          },
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }
}
