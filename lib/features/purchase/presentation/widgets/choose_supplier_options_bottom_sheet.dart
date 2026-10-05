import 'package:assab/core/enums/purchasing_officer_quality_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/purchase_sources_types.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/purchase_suppliers_response.dart';

class ChooseSupplierOptionsBottomSheet extends StatefulWidget {
  final PurchaseSuppliersData? supplier;
  final String sourceTypeFieldName;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;
  final int? selectedIndex;
  final String addedItemMainId;
  final VoidCallback? onConfirmed;

  const ChooseSupplierOptionsBottomSheet({
    super.key,
    this.supplier,
    required this.sourceTypeFieldName,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
    this.selectedIndex,
    required this.addedItemMainId,
    this.onConfirmed,
  });

  @override
  State<ChooseSupplierOptionsBottomSheet> createState() =>
      _ChooseSupplierOptionsBottomSheetState();
}

class _ChooseSupplierOptionsBottomSheetState
    extends State<ChooseSupplierOptionsBottomSheet> {
  late final ValueNotifier<int> _selectedQualityIndexNotifier;
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();
    _validationCubit = context.read<ValidationCubit>();
    _selectedQualityIndexNotifier = ValueNotifier<int>(-1);

    _syncDynamicFields();
  }

  @override
  void dispose() {
    _removeDynamicFields();
    _selectedQualityIndexNotifier.dispose();
    super.dispose();
  }

  void _syncDynamicFields() {
    _validationCubit.addDynamicFields({'quality_${widget.addedItemMainId}'});
  }

  void _removeDynamicFields() {
    if (!_validationCubit.fieldIsValid('quality_${widget.addedItemMainId}') ||
        !_validationCubit.fieldIsValid(widget.sourceTypeFieldName) ||
        !_validationCubit.fieldIsValid(widget.sourceIdFieldName) ||
        !_validationCubit.fieldIsValid(widget.sourceNameFieldName) ||
        !_validationCubit.fieldIsValid(widget.choosedSourceItemIdFieldName)) {
      _validationCubit.removeDynamicFields({
        'quality_${widget.addedItemMainId}',
      });
    }
  }

  void _onQualityOptionTap(
    int index,
    PurchasingOfficerQualityEnum selectedQuality,
  ) {
    _selectedQualityIndexNotifier.value = index;

    _validationCubit.validateFieldAndStoreValue(
      fieldName: 'quality_${widget.addedItemMainId}',
      value: selectedQuality.toString(),
      isValid: true,
    );
  }

  void _onConfirmDetailsTap() {
    if (widget.selectedIndex != null) {
      context.read<ChooseItemCubit>().selectItem(widget.selectedIndex!);
    }

    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: widget.sourceTypeFieldName,
      value: PurchaseSourcesTypes.supplier.toString(),
      isValid: true,
    );

    if (widget.supplier != null) {
      context.read<ValidationCubit>().validateFieldAndStoreValue(
        fieldName: widget.sourceIdFieldName,
        value: widget.supplier!.supplier.id,
        isValid: true,
      );

      context.read<ValidationCubit>().validateFieldAndStoreValue(
        fieldName: widget.choosedSourceItemIdFieldName,
        value: widget.supplier!.itemId,
        isValid: true,
      );

      context.read<ValidationCubit>().validateFieldAndStoreValue(
        fieldName: widget.sourceNameFieldName,
        value: widget.supplier!.supplier.name,
        isValid: true,
      );
    }

    widget.onConfirmed?.call();

    NavigationService.I.pop();
    NavigationService.I.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              PurchaseAppBar(
                title: context.tr.orderViaSupplier,
                subtitle: context.tr.completeRequestDetailsFormBelow,
                iconColor: context.customColor.text1,
                titleColor: context.customColor.text1,
                paddingTop: 0,
                paddingBottom: 8.r,
              ).sliverBoxAdapter,
              AppPaddingWidget(
                child: Column(
                  children: [
                    const CustomDivider(),
                    8.verticalSpace,
                    if (widget.supplier != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: context.customColor.border),
                        ),
                        padding: EdgeInsets.all(15.r),
                        child: Row(
                          children: [
                            ProfileImageWidget(
                              image: widget.supplier!.supplier.image,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.supplier!.supplier.name,
                                    style: AppStyles.s14W600.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      widget.supplier!.supplier.status
                                          .buildStatusWidget(context),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    12.verticalSpace,
                    LabelTextField(text: context.tr.qualityGrade),
                    5.verticalSpace,
                    ValueListenableBuilder(
                      valueListenable: _selectedQualityIndexNotifier,
                      builder: (context, value, child) {
                        return Row(
                          children: List.generate(3, (index) {
                            final options = [
                              context.tr.economy,
                              context.tr.standard,
                              context.tr.premium,
                            ];

                            final qualities = [
                              PurchasingOfficerQualityEnum.economy,
                              PurchasingOfficerQualityEnum.standard,
                              PurchasingOfficerQualityEnum.premium,
                            ];

                            final isSelected = index == value;

                            return Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextButton(
                                      text: options[index],
                                      onTap: () => _onQualityOptionTap(
                                        index,
                                        qualities[index],
                                      ),
                                      borderColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.border,
                                      textColor: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text4,
                                    ),
                                  ),
                                  if (index != 2) 8.horizontalSpace,
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ).sliverBoxAdapter,
              20.verticalSpace.sliverBoxAdapter,
            ],
          ),
        ),
        AppPaddingWidget(
          child: ValueListenableBuilder(
            valueListenable: _selectedQualityIndexNotifier,
            builder: (context, selectedQualityValue, child) {
              final isEnabled = selectedQualityValue != -1;

              return AppButton(
                onClick: _onConfirmDetailsTap,
                enabled: isEnabled,
                text: context.tr.confirmDetails,
              );
            },
          ),
        ),
      ],
    );
  }
}
