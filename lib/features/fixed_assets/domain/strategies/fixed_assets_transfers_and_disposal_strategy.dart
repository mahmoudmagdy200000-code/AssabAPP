import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_file_image.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_calendar.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/services/time_picker_service.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../data/models/fixed_assets_branches_response.dart';
import '../../presentation/cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart';
import '../../presentation/widgets/fixed_assets_branch_list_bottom_sheet_widget.dart';
import '../enums/fixed_assets_dispose_methods_enum.dart';
import '../enums/fixed_assets_transfers_and_disposal_enum.dart';

abstract class FixedAssetsTransfersAndDisposalStrategy {
  Widget buildRequestTypeWidget(BuildContext context);

  String labelText(BuildContext context);

  FixedAssetsTransfersAndDisposalEnum get type;

  void addValidationFields(BuildContext context) {}

  void removeValidationFields(BuildContext context) {}

  Widget buildItemWidget(BuildContext context, {required String assetId}) {
    final validationCubit = context.read<ValidationCubit>();
    validationCubit.removeDynamicFields({
      'transferReason_$assetId',
      'documentationPhotos_$assetId',
      'disposalReason_$assetId',
      'conditionDescription_$assetId',
      'visualEvidence_$assetId',
    });

    validationCubit.removeTypedField('transferReason_$assetId');
    validationCubit.removeTypedField('documentationPhotos_$assetId');
    validationCubit.removeTypedField('disposalReason_$assetId');
    validationCubit.removeTypedField('conditionDescription_$assetId');
    validationCubit.removeTypedField('visualEvidence_$assetId');

    return const SizedBox.shrink();
  }
}

class TransferToBranchFixedAssetsTransfersAndDisposalStrategy
    extends FixedAssetsTransfersAndDisposalStrategy {
  @override
  String labelText(BuildContext context) => context.tr.transferToBranch;

  @override
  FixedAssetsTransfersAndDisposalEnum get type =>
      FixedAssetsTransfersAndDisposalEnum.transferToBranch;

  @override
  void addValidationFields(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({
      'recipientBranch',
      'transferDetails',
    });
    context.read<ValidationCubit>().toggleFieldRequirement(
      'transferDetails',
      isRequired: false,
    );
  }

  @override
  void removeValidationFields(BuildContext context) {
    context.read<ValidationCubit>().removeDynamicFields({
      'recipientBranch',
      'transferDetails',
    });
    context.read<ValidationCubit>().removeTypedField('recipientBranch');
    context.read<ValidationCubit>().removeTypedField('transferDetails');
  }

  @override
  Widget buildRequestTypeWidget(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<FixedAssetsGetZoneAndTypeCubit>()..getBranches(),
        ),
        BlocProvider(create: (context) => SearchCubit<FixedAssetsBranchItem>()),
        BlocProvider(
          create: (context) => getIt<ChooseItemCubit>()..initTempSelection(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return AppGestureDetectorButton(
            onTap: () {
              final branchesCubit = context
                  .read<FixedAssetsGetZoneAndTypeCubit>();
              final searchCubit = context
                  .read<SearchCubit<FixedAssetsBranchItem>>();
              final chooseItemCubit = context.read<ChooseItemCubit>();
              final validationCubit = context.read<ValidationCubit>();

              searchCubit.clear();

              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: chooseItemCubit),
                    BlocProvider.value(value: branchesCubit),
                    BlocProvider.value(value: searchCubit),
                    BlocProvider.value(value: validationCubit),
                  ],
                  child: const FixedAssetsBranchListBottomSheetWidget(),
                ),
              );
            },
            child: ContainerCustomTextField(
              label: context.tr.recipientBranch,
              child: Row(
                children: [
                  Expanded(
                    child:
                        BlocSelector<
                          ValidationCubit,
                          ValidationState,
                          FixedAssetsBranchItem?
                        >(
                          selector: (state) =>
                              state.getTypedValue<FixedAssetsBranchItem?>(
                                'recipientBranch',
                              ),
                          builder: (context, state) {
                            return Text(
                              state?.name ?? context.tr.chooseStoreBranch,
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
                    Icons.keyboard_arrow_down_rounded,
                    size: 16.r,
                    color: context.customColor.text1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildItemWidget(BuildContext context, {required String assetId}) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.removeDynamicFields({
      'disposalReason_$assetId',
      'conditionDescription_$assetId',
      'visualEvidence_$assetId',
    });

    validationCubit.removeTypedField('disposalReason_$assetId');
    validationCubit.removeTypedField('conditionDescription_$assetId');
    validationCubit.removeTypedField('visualEvidence_$assetId');

    if (!validationCubit.fieldIsExists('transferReason_$assetId') &&
        !validationCubit.fieldIsExists('documentationPhotos_$assetId')) {
      validationCubit.addDynamicFields({
        'transferReason_$assetId',
        'documentationPhotos_$assetId',
      });
    }

    return BlocProvider(
      create: (context) => getIt<MediaCubit>(),
      child: Column(
        children: [
          ContainerCustomTextField(
            label: context.tr.transferReason,
            child: CustomTextField(
              hintText: context.tr.transferReasonHint,
              onChanged: (value) {
                context
                    .read<ValidationCubit>()
                    .validateFieldAndStoreTypedValue<String>(
                      fieldName: 'transferReason_$assetId',
                      value: value,
                      isValid: value.trim().isNotEmpty,
                    );
              },
              maxLines: 2,
            ),
          ),
          10.verticalSpace,
          LabelTextField(text: context.tr.documentationPhotos),
          const UploadExpenseInvoiceReceipt(singleSelectionMode: true),
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
                        fieldName: 'documentationPhotos_$assetId',
                        value: files.first,
                        isValid: true,
                      );
                  return files.first;
                }
              }

              return null;
            },
            builder: (context, media) {
              if (media == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  10.verticalSpace,
                  AppFileImage(
                    image: media.path,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class DisposalFixedAssetsTransfersAndDisposalStrategy
    extends FixedAssetsTransfersAndDisposalStrategy {
  @override
  String labelText(BuildContext context) => context.tr.finalDisposal;

  @override
  FixedAssetsTransfersAndDisposalEnum get type =>
      FixedAssetsTransfersAndDisposalEnum.disposal;

  @override
  void addValidationFields(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({
      'proposedDisposalDate',
      'proposedDisposalTime',
      'disposalMethod',
    });
  }

  @override
  void removeValidationFields(BuildContext context) {
    context.read<ValidationCubit>().removeDynamicFields({
      'proposedDisposalDate',
      'proposedDisposalTime',
      'disposalMethod',
    });
  }

  @override
  Widget buildRequestTypeWidget(BuildContext context) {
    return Column(
      children: [
        AppGestureDetectorButton(
          onTap: () {
            final validationCubit = context.read<ValidationCubit>();
            AppBottomSheet.show(
              context,
              (context) => AppPaddingWidget(
                top: 0,
                child: CustomCalendar(
                  onDateSelected: (value) {
                    validationCubit.validateFieldAndStoreTypedValue<String?>(
                      fieldName: 'proposedDisposalDate',
                      value: DateFormatter.formatDateMDY(value),
                      isValid: true,
                    );

                    NavigationService.I.pop();
                  },
                ),
              ),
            );
          },
          child: ContainerCustomTextField(
            label: context.tr.proposedDisposalDate,
            child: Row(
              children: [
                Expanded(
                  child:
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) {
                          return state.getTypedValue<String?>(
                            'proposedDisposalDate',
                          );
                        },
                        builder: (context, value) {
                          return Text(
                            value ?? context.tr.choose,
                            style: AppStyles.s12W400.copyWith(
                              color: value != null
                                  ? context.customColor.text1
                                  : context.customColor.text3,
                              fontWeight: value != null
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          );
                        },
                      ),
                ),
                10.horizontalSpace,
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.r,
                  color: context.customColor.text1,
                ),
              ],
            ),
          ),
        ),
        4.verticalSpace,
        AppGestureDetectorButton(
          onTap: () {
            TimePickerService.showTimePickerDialog(
              context,
              onTimePicked: (time) {
                context
                    .read<ValidationCubit>()
                    .validateFieldAndStoreTypedValue<String?>(
                      fieldName: 'proposedDisposalTime',
                      value: time?.format(context),
                      isValid: true,
                    );
              },
            );
          },
          child: ContainerCustomTextField(
            label: context.tr.proposedDisposalTime,
            child: Row(
              children: [
                Expanded(
                  child:
                      BlocSelector<ValidationCubit, ValidationState, String?>(
                        selector: (state) {
                          return state.getTypedValue<String?>(
                            'proposedDisposalTime',
                          );
                        },
                        builder: (context, value) {
                          return Text(
                            value ?? context.tr.choose,
                            style: AppStyles.s12W400.copyWith(
                              color: value != null
                                  ? context.customColor.text1
                                  : context.customColor.text3,
                              fontWeight: value != null
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          );
                        },
                      ),
                ),
                10.horizontalSpace,
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.r,
                  color: context.customColor.text1,
                ),
              ],
            ),
          ),
        ),
        4.verticalSpace,
        LabelTextField(
          text: context.tr.disposalMethod,
          isLabelOptional: true,
          isLabelRequired: false,
        ),
        CustomDropdown<FixedAssetsDisposeMethodsEnum>(
          items: const [
            FixedAssetsDisposeMethodsEnum.scrap,
            FixedAssetsDisposeMethodsEnum.sell,
            FixedAssetsDisposeMethodsEnum.returnToSupplier,
            FixedAssetsDisposeMethodsEnum.other,
          ],
          displayTextBuilder: (value) =>
              value?.label(context) ?? context.tr.choose,
          borderRadius: 20.r,
          backgroundColor: context.customColor.text2,
          iconSize: 16.r,
          itemBuilder: (context, item, isSelected) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
              color: Colors.transparent,
              child: Text(
                item.label(context),
                style: AppStyles.s14W400.copyWith(
                  color: isSelected
                      ? context.theme.primaryColor
                      : context.customColor.text1,
                ),
              ),
            );
          },
          onChanged: (value) {
            context
                .read<ValidationCubit>()
                .validateFieldAndStoreTypedValue<FixedAssetsDisposeMethodsEnum>(
                  fieldName: 'disposalMethod',
                  value: value,
                  isValid: true,
                );
          },
        ),
      ],
    );
  }

  @override
  Widget buildItemWidget(BuildContext context, {required String assetId}) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.removeDynamicFields({
      'transferReason_$assetId',
      'documentationPhotos_$assetId',
    });
    validationCubit.removeTypedField('transferReason_$assetId');
    validationCubit.removeTypedField('documentationPhotos_$assetId');

    if (!validationCubit.fieldIsExists('disposalReason_$assetId') &&
        !validationCubit.fieldIsExists('conditionDescription_$assetId') &&
        !validationCubit.fieldIsExists('visualEvidence_$assetId')) {
      validationCubit.addDynamicFields({
        'disposalReason_$assetId',
        'conditionDescription_$assetId',
        'visualEvidence_$assetId',
      });
    }

    return BlocProvider(
      create: (context) => getIt<MediaCubit>(),
      child: Column(
        children: [
          ContainerCustomTextField(
            label: context.tr.disposalReason,
            child: CustomTextField(
              hintText: context.tr.disposalReasonHint,
              onChanged: (value) {
                context
                    .read<ValidationCubit>()
                    .validateFieldAndStoreTypedValue<String>(
                      fieldName: 'disposalReason_$assetId',
                      value: value,
                      isValid: value.trim().isNotEmpty,
                    );
              },
              maxLines: 2,
            ),
          ),
          10.verticalSpace,
          ContainerCustomTextField(
            label: context.tr.conditionDescription,
            child: CustomTextField(
              hintText: context.tr.conditionDescriptionHint,
              onChanged: (value) {
                context
                    .read<ValidationCubit>()
                    .validateFieldAndStoreTypedValue<String>(
                      fieldName: 'conditionDescription_$assetId',
                      value: value,
                      isValid: value.trim().isNotEmpty,
                    );
              },
              maxLines: 2,
            ),
          ),
          10.verticalSpace,
          LabelTextField(text: context.tr.visualEvidence),
          const UploadExpenseInvoiceReceipt(singleSelectionMode: true),
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
                        fieldName: 'visualEvidence_$assetId',
                        value: files.first,
                        isValid: true,
                      );
                  return files.first;
                }
              }

              return null;
            },
            builder: (context, media) {
              if (media == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  10.verticalSpace,
                  AppFileImage(
                    image: media.path,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ExternalTransferFixedAssetsTransfersAndDisposalStrategy
    extends FixedAssetsTransfersAndDisposalStrategy {
  @override
  String labelText(BuildContext context) => context.tr.externalTransfer;

  @override
  FixedAssetsTransfersAndDisposalEnum get type =>
      FixedAssetsTransfersAndDisposalEnum.externalTransfer;

  @override
  Widget buildRequestTypeWidget(BuildContext context) {
    return Text(
      context.tr.approvalFromManagerRequired,
      style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
    );
  }
}
