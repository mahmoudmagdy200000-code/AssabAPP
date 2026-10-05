import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_file_image.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:assab/features/fixed_assets/presentation/cubit/update_asset_settings/update_asset_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../data/models/fixed_assets_search_response.dart';
import '../../data/models/fixed_assets_search_setting_request.dart';
import '../../data/models/fixed_assets_zones_response.dart';
import '../cubit/update_asset_settings/update_asset_settings_cubit.dart';
import 'setting_new_location_widget.dart';

class FixedAssetsSearchScreenItemSettingBottomSheet extends StatelessWidget {
  final FixedAssetsSearchItem item;

  const FixedAssetsSearchScreenItemSettingBottomSheet({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MediaCubit>(),
      child: _FixedAssetsSearchScreenItemSettingBottomSheet(item: item),
    );
  }
}

class _FixedAssetsSearchScreenItemSettingBottomSheet extends StatelessWidget {
  final FixedAssetsSearchItem item;

  const _FixedAssetsSearchScreenItemSettingBottomSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    Text(
                      item.code,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      context.tr.updateImageAndLocation,
                      style: AppStyles.s12W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    14.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.tr.currentLocation,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text4,
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Text(
                            item.location.name,
                            textAlign: TextAlign.end,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    const CustomDivider(),
                    15.verticalSpace,
                    SettingNewLocationWidget(oldLocationId: item.location.id),
                    15.verticalSpace,
                    LabelTextField(
                      text: context.tr.updateImage,
                      isLabelOptional: false,
                      isLabelRequired: false,
                    ),
                    const UploadExpenseInvoiceReceipt(
                      singleSelectionMode: true,
                    ),
                    10.verticalSpace,
                    BlocSelector<MediaCubit, MediaState, MediaFile?>(
                      selector: (state) {
                        if (state is MediaLoaded) {
                          final files = state.allFiles
                              .where((file) => file.selected)
                              .toList();

                          if (files.isNotEmpty) {
                            context
                                .read<ValidationCubit>()
                                .validateFieldAndStoreTypedValue<MediaFile>(
                                  fieldName: 'newImage',
                                  value: files.first,
                                  isValid: true,
                                );

                            return files.first;
                          }
                        }

                        return null;
                      },
                      builder: (context, mediaFile) {
                        if (mediaFile == null) {
                          return const SizedBox.shrink();
                        }

                        return Stack(
                          children: [
                            AppFileImage(
                              image: mediaFile.path,
                              borderRadius: BorderRadius.zero,
                            ),
                            Positioned(
                              top: 8.r,
                              right: 8.r,
                              child: AppGestureDetectorButton(
                                onTap: () {
                                  context.read<MediaCubit>().unselectFile(
                                    mediaFile,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.customColor.border,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(6.r),
                                  child: AppSvg(
                                    assetName: AppAssets.trashSvg,
                                    width: 16.r,
                                    colorFilter: ColorFilter.mode(
                                      context.customColor.error,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.cancel,
                    onTap: () {
                      NavigationService.I.pop();
                    },
                    padding: EdgeInsets.symmetric(vertical: 16.r),
                    textColor: context.customColor.text1,
                    borderRadius: 15.r,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child:
                      BlocListener<
                        UpdateAssetSettingsCubit,
                        UpdateAssetSettingsState
                      >(
                        listener: (context, state) {
                          if (state is UpdateAssetSettingsSuccess) {
                            NavigationService.I.pop();
                          } else if (state is UpdateAssetSettingsFailure) {
                            AppDialog.showErrorDialog(
                              context: context,
                              failure: state.failure,
                            );
                          }
                        },
                        child:
                            BlocBuilder<
                              UpdateAssetSettingsCubit,
                              UpdateAssetSettingsState
                            >(
                              builder: (context, state) {
                                if (state is UpdateAssetSettingsLoading) {
                                  return const AppButtonLoading();
                                }

                                return BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  bool
                                >(
                                  selector: (state) =>
                                      state.fieldsValidity['newLocation'] ==
                                      true,
                                  builder: (context, isValid) {
                                    return AppButton(
                                      onClick: () {
                                        final validationState = context
                                            .read<ValidationCubit>();

                                        context
                                            .read<UpdateAssetSettingsCubit>()
                                            .updateAssetSettings(
                                              request:
                                                  FixedAssetsSearchSettingRequest(
                                                    assetId: item.id,
                                                    newZoneId:
                                                        (validationState
                                                            .getTypedValue<
                                                              FixedAssetsZoneData
                                                            >('newLocation')
                                                            ?.id) ??
                                                        '',
                                                    newImage: validationState
                                                        .getTypedValue<
                                                          MediaFile
                                                        >('newImage')
                                                        ?.toFile,
                                                  ),
                                            );
                                      },
                                      text: context.tr.save,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.r,
                                      ),
                                      enabled: isValid,
                                      borderRadius: BorderRadius.circular(15.r),
                                    );
                                  },
                                );
                              },
                            ),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
