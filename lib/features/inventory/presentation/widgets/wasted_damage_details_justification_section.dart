import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/upload_expense_invoice_receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/media/media_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/wasted_for_reason_enum.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/widgets/file_preview_widget.dart';

class WastedDamageDetailsJustificationSection extends StatelessWidget {
  final String? itemId;

  const WastedDamageDetailsJustificationSection({super.key, this.itemId});

  String _key(String base) => itemId != null ? '${base}_$itemId' : base;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<ValidationCubit, ValidationState, WastedForReasonEnum?>(
          selector: (state) =>
              state.getTypedValue<WastedForReasonEnum?>(_key('reasonForWaste')),
          builder: (context, state) {
            if (state != WastedForReasonEnum.other) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.detailedJustificationForManager,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                8.verticalSpace,
                ContainerCustomTextField(
                  backgroundColor: context.customColor.reversedTextColor,
                  child: CustomTextField(
                    hintText: context.tr.accurateDescriptionOfSituation,
                    maxLines: 4,
                    onChanged: (value) {
                      context
                          .read<ValidationCubit>()
                          .validateFieldAndStoreValue(
                            fieldName: _key('justification'),
                            value: value,
                            isValid: value.isNotEmpty,
                          );
                    },
                  ),
                ),
                8.verticalSpace,
              ],
            );
          },
        ),
        Container(
          decoration: BoxDecoration(
            color: context.customColor.reversedTextColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
          child: Column(
            spacing: 10.h,
            children: [
              LabelTextField(text: context.tr.explanatoryPhoto),
              const UploadExpenseInvoiceReceipt(
                singleSelectionMode: true,
                isFlexible: true,
              ),
              BlocSelector<MediaCubit, MediaState, List<MediaFile>>(
                selector: (state) {
                  if (state is MediaLoaded) {
                    final files = state.allFiles
                        .where((f) => f.selected)
                        .toList();

                    if (files.isNotEmpty) {
                      context
                          .read<ValidationCubit>()
                          .validateFieldAndStoreTypedValue<MediaFile>(
                            fieldName: _key('photo'),
                            value: files.first,
                            isValid: files.isNotEmpty,
                          );
                    }

                    return files;
                  }

                  return const [];
                },
                builder: (context, allFiles) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allFiles.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) => FilePreviewWidget(
                      file: allFiles[index],
                      icon: AppAssets.trashSvg,
                      onTapIcon: () {
                        context.read<MediaCubit>().removeFile(allFiles[index]);
                      },
                    ),
                  );
                },
              ),
              Row(
                spacing: 8.w,
                children: [
                  AppSvg(
                    assetName: AppAssets.warning,
                    width: 16.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.orange,
                      BlendMode.srcIn,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      context.tr.requiredForDamageGreaterThan20Sar,
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
