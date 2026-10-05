import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/media/media_state.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_file_image.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/receive_assets_respons.dart';
import 'fixed_assets_search_filters_widget_type_bottom_sheet.dart';
import 'fixed_assets_search_filters_widget_zone_bottom_sheet.dart';

class FixedAssetsReceiveAssetsListItemWidget extends StatelessWidget {
  final ReceiveAssetsData item;

  const FixedAssetsReceiveAssetsListItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MediaCubit>(),
      child: _FixedAssetsReceiveAssetsListItemWidget(item: item),
    );
  }
}

class _FixedAssetsReceiveAssetsListItemWidget extends StatelessWidget {
  final ReceiveAssetsData item;

  const _FixedAssetsReceiveAssetsListItemWidget({required this.item});

  void _addValidationFields(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.addDynamicFields({
      'assignedZoneId_${item.id}',
      'assignedZoneName_${item.id}',
      'assetTypeId_${item.id}',
      'assetTypeName_${item.id}',
      'assetsCount_${item.id}',
      'excellent_${item.id}',
      'needsAttention_${item.id}',
      'problem_${item.id}',
      'receiptPhoto_${item.id}',
    });
  }

  void _removeValidationFields(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.removeDynamicFields({
      'assignedZoneId_${item.id}',
      'assignedZoneName_${item.id}',
      'assetTypeId_${item.id}',
      'assetTypeName_${item.id}',
      'assetsCount_${item.id}',
      'excellent_${item.id}',
      'needsAttention_${item.id}',
      'problem_${item.id}',
      'receiptPhoto_${item.id}',
    });
  }

  void _chooseAssignedZone(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    if (validationCubit.fieldIsValid('asset_${item.id}')) {
      AppBottomSheet.customPageRoute(
        context,
        (context) => BlocProvider.value(
          value: validationCubit,
          child: FixedAssetsSearchFiltersWidgetZoneBottomSheet(
            onZoneSelected: (zoneId, zoneName) {
              validationCubit.validateFieldAndStoreValue(
                fieldName: 'assignedZoneName_${item.id}',
                value: zoneName,
                isValid: true,
              );

              validationCubit.validateFieldAndStoreValue(
                fieldName: 'assignedZoneId_${item.id}',
                value: zoneId,
                isValid: true,
              );
            },
          ),
        ),
      );
    }
  }

  void _chooseAssetType(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    if (validationCubit.fieldIsValid('asset_${item.id}')) {
      AppBottomSheet.customPageRoute(
        context,
        (context) => BlocProvider.value(
          value: validationCubit,
          child: FixedAssetsSearchFiltersWidgetTypeBottomSheet(
            onTypeSelected: (typeId, typeName) {
              validationCubit.validateFieldAndStoreValue(
                fieldName: 'assetTypeName_${item.id}',
                value: typeName,
                isValid: true,
              );

              validationCubit.validateFieldAndStoreValue(
                fieldName: 'assetTypeId_${item.id}',
                value: typeId,
                isValid: true,
              );
            },
          ),
        ),
      );
    }
  }

  void _selectAsset(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    if (validationCubit.fieldIsExists('asset_${item.id}')) {
      validationCubit.validateFieldAndStoreTypedValue<bool>(
        fieldName: 'asset_${item.id}',
        value: !validationCubit.fieldIsValid('asset_${item.id}'),
        isValid: !validationCubit.fieldIsValid('asset_${item.id}'),
      );

      if (validationCubit.fieldIsValid('asset_${item.id}')) {
        _addValidationFields(context);
      } else {
        _removeValidationFields(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocSelector<ValidationCubit, ValidationState, bool>(
            selector: (state) =>
                state.fieldsValidity['asset_${item.id}'] ?? false,
            builder: (context, state) {
              return AppCheckBox(
                onChanged: (value) => _selectAsset(context),
                value: state,
              );
            },
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 122.r,
                      height: 89.r,
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: AppNetworkImage(
                        image: item.assetImage,
                        width: 122.r,
                        height: 89.r,
                        fit: BoxFit.contain,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.assetName,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            item.assetCode,
                            style: AppStyles.s13W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Divider(color: context.customColor.border, height: 1),
                10.verticalSpace,
                AppGestureDetectorButton(
                  onTap: () => _chooseAssignedZone(context),
                  child: ContainerCustomTextField(
                    label: context.tr.assignedZone,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              BlocSelector<
                                ValidationCubit,
                                ValidationState,
                                String?
                              >(
                                selector: (state) => state
                                    .fieldsValue['assignedZoneName_${item.id}'],
                                builder: (context, state) {
                                  return Text(
                                    state ?? context.tr.choose,
                                    style: AppStyles.s12W400.copyWith(
                                      color: state != null
                                          ? context.customColor.text1
                                          : context.customColor.text3,
                                      fontWeight: state != null
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                  );
                                },
                              ),
                        ),
                        10.horizontalSpace,
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20.r,
                          color: context.customColor.text3,
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                AppGestureDetectorButton(
                  onTap: () => _chooseAssetType(context),
                  child: ContainerCustomTextField(
                    label: context.tr.assetType,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              BlocSelector<
                                ValidationCubit,
                                ValidationState,
                                String?
                              >(
                                selector: (state) => state
                                    .fieldsValue['assetTypeName_${item.id}'],
                                builder: (context, state) {
                                  return Text(
                                    state ?? context.tr.choose,
                                    style: AppStyles.s12W400.copyWith(
                                      color: state != null
                                          ? context.customColor.text1
                                          : context.customColor.text3,
                                      fontWeight: state != null
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                  );
                                },
                              ),
                        ),
                        10.horizontalSpace,
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 20.r,
                          color: context.customColor.text3,
                        ),
                      ],
                    ),
                  ),
                ),
                10.verticalSpace,
                ContainerCustomTextField(
                  label: context.tr.assetsCount_a,
                  child: BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (state) =>
                        state.fieldsValidity['asset_${item.id}'] ?? false,
                    builder: (context, state) {
                      return CustomTextField(
                        hintText: '0',
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreTypedValue<int>(
                                fieldName: 'assetsCount_${item.id}',
                                value: int.tryParse(value) ?? 0,
                                isValid: int.tryParse(value) != null,
                              );
                        },
                        isEnabled: state,
                      );
                    },
                  ),
                ),
                10.verticalSpace,
                ContainerCustomTextField(
                  label: context.tr.excellent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 20.r,
                        color: AppColors.lightGreen,
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child:
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              bool
                            >(
                              selector: (state) =>
                                  state.fieldsValidity['asset_${item.id}'] ??
                                  false,
                              builder: (context, state) {
                                return CustomTextField(
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    context
                                        .read<ValidationCubit>()
                                        .validateFieldAndStoreTypedValue<int>(
                                          fieldName: 'excellent_${item.id}',
                                          value: int.tryParse(value) ?? 0,
                                          isValid: int.tryParse(value) != null,
                                        );
                                  },
                                  isEnabled: state,
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                ContainerCustomTextField(
                  label: context.tr.needsAttention,
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 20.r, color: AppColors.yellow),
                      12.horizontalSpace,
                      Expanded(
                        child:
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              bool
                            >(
                              selector: (state) =>
                                  state.fieldsValidity['asset_${item.id}'] ??
                                  false,
                              builder: (context, state) {
                                return CustomTextField(
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    context
                                        .read<ValidationCubit>()
                                        .validateFieldAndStoreTypedValue<int>(
                                          fieldName:
                                              'needsAttention_${item.id}',
                                          value: int.tryParse(value) ?? 0,
                                          isValid: int.tryParse(value) != null,
                                        );
                                  },
                                  isEnabled: state,
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                ContainerCustomTextField(
                  label: context.tr.problem,
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 20.r, color: AppColors.red),
                      12.horizontalSpace,
                      Expanded(
                        child:
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              bool
                            >(
                              selector: (state) =>
                                  state.fieldsValidity['asset_${item.id}'] ??
                                  false,
                              builder: (context, state) {
                                return CustomTextField(
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    context
                                        .read<ValidationCubit>()
                                        .validateFieldAndStoreTypedValue<int>(
                                          fieldName: 'problem_${item.id}',
                                          value: int.tryParse(value) ?? 0,
                                          isValid: int.tryParse(value) != null,
                                        );
                                  },
                                  isEnabled: state,
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                LabelTextField(text: context.tr.receiptPhoto),
                const UploadExpenseInvoiceReceipt(
                  singleSelectionMode: true,
                  isFlexible: true,
                ),
                BlocSelector<MediaCubit, MediaState, MediaFile?>(
                  selector: (state) {
                    if (state is MediaLoaded) {
                      final file = state.allFiles
                          .where((f) => f.selected)
                          .firstOrNull;

                      final validationCubit = context.read<ValidationCubit>();

                      if (context.read<ValidationCubit>().fieldIsValid(
                            'asset_${item.id}',
                          ) &&
                          file != null) {
                        validationCubit
                            .validateFieldAndStoreTypedValue<MediaFile>(
                              fieldName: 'receiptPhoto_${item.id}',
                              value: file,
                              isValid: file.selected,
                            );
                      }

                      return file;
                    }

                    return null;
                  },
                  builder: (context, file) {
                    if (file == null) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        10.verticalSpace,
                        AppFileImage(image: file.toFile.path),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
