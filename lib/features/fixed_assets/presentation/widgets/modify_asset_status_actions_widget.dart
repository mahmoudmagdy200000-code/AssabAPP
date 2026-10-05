import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/choose_item/choose_item_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/file_preview_widget.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/models/media_file_model.dart';
import '../../domain/enums/fixed_assets_done_enum.dart';
import '../../domain/enums/fixed_assets_next_enum.dart';

class ModifyAssetStatusActionsWidget extends StatelessWidget {
  const ModifyAssetStatusActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocumentationPhotos(context),
        12.verticalSpace,
        _buildRequiredActions(context),
      ],
    );
  }

  Widget _buildDocumentationPhotos(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.documentationPhotos),
        // 4.verticalSpace,
        // Text(
        //   context.tr.youCanUploadOptionalVideosToo,
        //   style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        // ),
        16.verticalSpace,
        const UploadExpenseInvoiceReceipt(singleSelectionMode: true),
        BlocSelector<MediaCubit, MediaState, MediaFile?>(
          selector: (state) {
            if (state is MediaLoaded) {
              final files = state.allFiles.where((f) => f.selected).toList();

              if (files.isNotEmpty) {
                context
                    .read<ValidationCubit>()
                    .validateFieldAndStoreTypedValue<MediaFile>(
                      fieldName: 'photos',
                      value: files.first,
                      isValid: true,
                    );

                return files.first;
              }
            }

            return null;
          },
          builder: (context, file) {
            if (file == null) {
              return const SizedBox.shrink();
            }

            return FilePreviewWidget(
              file: file,
              icon: AppAssets.trashSvg,
              onTapIcon: () {
                context.read<ValidationCubit>().resetFieldValidity('photos');
                context.read<MediaCubit>().unselectFile(file);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRequiredActions(BuildContext context) {
    List<FixedAssetsNextEnum> nextActions = [
      FixedAssetsNextEnum.needTechnician,
      FixedAssetsNextEnum.halt,
      FixedAssetsNextEnum.replace,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextField(text: context.tr.requiredActions),
        12.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: context.customColor.text2,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.doneActions,
                style: AppStyles.s14W600.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              12.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          BlocSelector<ValidationCubit, ValidationState, bool>(
                            selector: (state) =>
                                state.fieldsValidity['initialCheck'] ?? false,
                            builder: (context, state) {
                              return AppCheckBox(
                                onChanged: (value) {
                                  context
                                      .read<ValidationCubit>()
                                      .validateFieldAndStoreTypedValue<
                                        FixedAssetsDoneEnum
                                      >(
                                        fieldName: 'initialCheck',
                                        value: FixedAssetsDoneEnum.initialCheck,
                                        isValid: value,
                                      );

                                  print(
                                    'initialCheck: ${context.read<ValidationCubit>().getTypedValue<FixedAssetsDoneEnum>('initialCheck')}',
                                  );
                                },
                                value: state,
                              );
                            },
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: Text(
                              context.tr.initialCheck,
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Row(
                        children: [
                          BlocSelector<ValidationCubit, ValidationState, bool>(
                            selector: (state) =>
                                state.fieldsValidity['cleaning'] ?? false,
                            builder: (context, state) {
                              return AppCheckBox(
                                onChanged: (value) {
                                  context
                                      .read<ValidationCubit>()
                                      .validateFieldAndStoreTypedValue<
                                        FixedAssetsDoneEnum
                                      >(
                                        fieldName: 'cleaning',
                                        value: FixedAssetsDoneEnum.cleaning,
                                        isValid: value,
                                      );
                                },
                                value: state,
                              );
                            },
                          ),
                          5.horizontalSpace,
                          Expanded(
                            child: Text(
                              context.tr.cleaning,
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              12.verticalSpace,
              Text(
                context.tr.nextActions,
                style: AppStyles.s14W600.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              12.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
                child: Column(
                  children: List.generate(nextActions.length, (index) {
                    return AppGestureDetectorButton(
                      onTap: () {
                        context.read<ChooseItemCubit>().selectItem(index);
                        context
                            .read<ValidationCubit>()
                            .validateFieldAndStoreTypedValue<
                              FixedAssetsNextEnum
                            >(
                              fieldName: 'next',
                              value: nextActions[index],
                              isValid: true,
                            );
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  nextActions[index].label(context),
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              BlocSelector<
                                ChooseItemCubit,
                                ChooseItemState,
                                bool
                              >(
                                selector: (state) =>
                                    state.selectedIndex == index,
                                builder: (context, state) {
                                  return SelectionCircule(isSelected: state);
                                },
                              ),
                            ],
                          ),
                          if (index < nextActions.length - 1) ...[
                            14.verticalSpace,
                            const CustomDivider(),
                            14.verticalSpace,
                          ],
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
