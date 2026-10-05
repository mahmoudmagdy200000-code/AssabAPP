import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';

class GroupedInvoicesWidgetTopSection extends StatelessWidget {
  final int index;
  final String id;
  final VoidCallback onRemove;
  final ValueNotifier<int?> showDetailsNotifier;

  const GroupedInvoicesWidgetTopSection({
    super.key,
    required this.index,
    required this.id,
    required this.onRemove,
    required this.showDetailsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text3),
          ),
          14.horizontalSpace,
          Expanded(
            child: AppGestureDetectorButton(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BlocSelector<
                            ValidationCubit,
                            ValidationState,
                            String?
                          >(
                            selector: (state) =>
                                state.fieldsValue['invoiceNumber_$id'],
                            builder: (context, state) {
                              return Text(
                                state ?? 'Invoice Number',
                                style: AppStyles.s14W600.copyWith(
                                  color: context.customColor.text1,
                                ),
                              );
                            },
                          ),
                          10.horizontalSpace,
                          if (index != 0)
                            AppGestureDetectorButton(
                              onTap: () {
                                context.read<AddItemCubit>().removeItem(
                                  'invoiceGroup',
                                  index,
                                );

                                onRemove();
                              },
                              child: AppSvg(
                                assetName: AppAssets.trashSvg,
                                width: 14.r,
                              ),
                            ),
                        ],
                      ),
                      4.verticalSpace,
                      BlocSelector<ValidationCubit, ValidationState, bool>(
                        selector: (state) {
                          final supplierIdValid =
                              state.fieldsValidity['supplierId_$id'] ?? false;
                          final supplierNameValid =
                              state.fieldsValidity['supplierName_$id'] ?? false;
                          final issueDateValid =
                              state.fieldsValidity['issueDate_$id'] ?? false;
                          final photosValid =
                              state.fieldsValidity['photos_$id'] ?? false;
                          final taxIdValid =
                              state.fieldsValidity['taxId_$id'] ?? false;
                          final taxSupplierNameValid =
                              state.fieldsValidity['taxSupplierName_$id'] ??
                              false;
                          final netAmountValid =
                              state.fieldsValidity['netAmount_$id'] ?? false;
                          final vatAmountValid =
                              state.fieldsValidity['vatAmount_$id'] ?? false;
                          final totalIncVatValid =
                              state.fieldsValidity['totalIncVat_$id'] ?? false;

                          final validationCubit = context
                              .read<ValidationCubit>();

                          if (validationCubit.fieldIsRequired('taxId_$id') &&
                              validationCubit.fieldIsRequired(
                                'taxSupplierName_$id',
                              ) &&
                              validationCubit.fieldIsRequired(
                                'netAmount_$id',
                              ) &&
                              validationCubit.fieldIsRequired(
                                'vatAmount_$id',
                              ) &&
                              validationCubit.fieldIsRequired(
                                'totalIncVat_$id',
                              )) {
                            return supplierIdValid &&
                                supplierNameValid &&
                                issueDateValid &&
                                photosValid &&
                                taxIdValid &&
                                taxSupplierNameValid &&
                                netAmountValid &&
                                vatAmountValid &&
                                totalIncVatValid;
                          }

                          return supplierIdValid &&
                              supplierNameValid &&
                              issueDateValid &&
                              photosValid;
                        },
                        builder: (context, state) {
                          return Row(
                            children: [
                              Icon(
                                state
                                    ? Icons.check
                                    : Icons.warning_amber_rounded,
                                size: 16.r,
                                color: state
                                    ? AppColors.lightGreen
                                    : context.customColor.error,
                              ),
                              4.horizontalSpace,
                              Text(
                                state
                                    ? context.tr.completedForm
                                    : context.tr.missingInformation,
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 18.r,
                    color: context.customColor.text1,
                    onPressed: () {
                      showDetailsNotifier.value =
                          showDetailsNotifier.value == index ? null : index;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
