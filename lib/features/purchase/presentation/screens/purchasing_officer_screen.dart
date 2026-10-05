import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/enums/purchase_sources_types.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_calendar.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/navigation/navigation_service.dart';
import '../../data/models/purchase_branch_items_response.dart';
import '../widgets/purchasing_officer_processing_time_section.dart';
import '../widgets/purchasing_officer_quality_section.dart';

class PurchasingOfficerScreen extends StatefulWidget {
  final PurchaseBranchItemData item;
  final int quantity;
  final String addedItemMainId;

  const PurchasingOfficerScreen({
    super.key,
    required this.item,
    required this.quantity,
    required this.addedItemMainId,
  });

  @override
  State<PurchasingOfficerScreen> createState() =>
      _PurchasingOfficerScreenState();
}

class _PurchasingOfficerScreenState extends State<PurchasingOfficerScreen> {
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();

    _validationCubit = context.read<ValidationCubit>();

    _syncDynamicFields();
  }

  @override
  void dispose() {
    _removeDynamicFields();
    super.dispose();
  }

  void _syncDynamicFields() {
    final String mainId = widget.addedItemMainId;

    _validationCubit.validateFieldAndStoreValue(
      fieldName: 'source_id_$mainId',
      value: PurchaseSourcesTypes.officer.toString(),
      isValid: true,
    );

    _validationCubit.validateFieldAndStoreValue(
      fieldName: 'choosed_item_source_id_$mainId',
      value: widget.item.itemId,
      isValid: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validationCubit.validateFieldAndStoreValue(
        fieldName: 'source_name_$mainId',
        value: context.tr.purchasingOfficer,
        isValid: true,
      );
    });

    _validationCubit.addDynamicFields({
      'quality_$mainId',
      'time_$mainId',
      'preferredDelivery_$mainId',
      'latestDelivery_$mainId',
      'specialInstructions_$mainId',
    });

    _validationCubit.toggleFieldRequirement(
      'specialInstructions_$mainId',
      isRequired: false,
    );
  }

  void _removeDynamicFields() {
    final String mainId = widget.addedItemMainId;

    if (!_validationCubit.fieldIsValid('quality_$mainId') ||
        !_validationCubit.fieldIsValid('time_$mainId') ||
        !_validationCubit.fieldIsValid('preferredDelivery_$mainId') ||
        !_validationCubit.fieldIsValid('latestDelivery_$mainId') ||
        !_validationCubit.fieldIsValid('sourceType_$mainId')) {
      _validationCubit.removeDynamicFields({
        'quality_$mainId',
        'time_$mainId',
        'preferredDelivery_$mainId',
        'latestDelivery_$mainId',
        'specialInstructions_$mainId',
      });
    }
  }

  void _selectPreferredDelivery(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.pageRoute(
      context,
      (context) => _buildCalender(
        context: context,
        onDateSelected: (selectedDate) {
          _validationAndStoreValue(
            validationCubit,
            'preferredDelivery_${widget.addedItemMainId}',
            selectedDate.toIso8601String(),
          );
        },
      ),
    );
  }

  void _selectLatestDelivery(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.pageRoute(
      context,
      (context) => _buildCalender(
        context: context,
        onDateSelected: (selectedDate) {
          _validationAndStoreValue(
            validationCubit,
            'latestDelivery_${widget.addedItemMainId}',
            selectedDate.toIso8601String(),
          );
        },
      ),
    );
  }

  void _validationAndStoreValue(
    ValidationCubit validationCubit,
    String fieldName,
    String value,
  ) {
    validationCubit.validateFieldAndStoreValue(
      fieldName: fieldName,
      value: value,
      isValid: value.isNotEmpty,
      log: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  10.verticalSpace,
                  PurchaseAppBar(
                    title: context.tr.orderViaPurchasingOfficer,
                    subtitle: context.tr.completeRequestDetailsFormBelow,
                    titleColor: context.customColor.text1,
                    iconColor: context.customColor.text1,
                  ),
                  8.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.r),
                    child: Column(
                      children: [
                        const CustomDivider(),
                        8.verticalSpace,
                        PurchaseItemPreviewWidget(
                          itemImage: widget.item.itemLogo,
                          itemName: widget.item.itemName,
                          itemPrice: widget.item.itemPrice,
                          itemQuantity:
                              (widget.item.itemPrice * widget.quantity).toInt(),
                          itemUnit: widget.item.itemUnit,
                        ),
                      ],
                    ),
                  ),
                  12.verticalSpace,
                  Container(
                    color: context.customColor.text2.withValues(alpha: 0.4),
                    padding: EdgeInsets.symmetric(
                      vertical: 12.r,
                      horizontal: 20.r,
                    ),
                    child: Column(
                      children: [
                        PurchasingOfficerQualitySection(
                          addedItemMainId: widget.addedItemMainId,
                        ),
                        20.verticalSpace,
                        PurchasingOfficerProcessingTimeSection(
                          addedItemMainId: widget.addedItemMainId,
                        ),
                        20.verticalSpace,
                        LabelTextField(text: context.tr.preferredDelivery),
                        3.verticalSpace,
                        BlocSelector<ValidationCubit, ValidationState, String?>(
                          selector: (state) => state
                              .fieldsValue['preferredDelivery_${widget.addedItemMainId}'],
                          builder: (context, state) {
                            return _buildTimePicker(
                              context: context,
                              label:
                                  DateFormatter.formatDateMDY(
                                    DateTime.tryParse(state ?? ''),
                                  ) ??
                                  context.tr.whenWouldYouLikeItDelivered,
                              onTap: () {
                                _selectPreferredDelivery(context);
                              },
                            );
                          },
                        ),
                        20.verticalSpace,
                        LabelTextField(text: context.tr.latestDelivery),
                        3.verticalSpace,
                        BlocSelector<ValidationCubit, ValidationState, String?>(
                          selector: (state) => state
                              .fieldsValue['latestDelivery_${widget.addedItemMainId}'],
                          builder: (context, state) {
                            return _buildTimePicker(
                              context: context,
                              label:
                                  DateFormatter.formatDateMDY(
                                    DateTime.tryParse(state ?? ''),
                                  ) ??
                                  context
                                      .tr
                                      .whatsTheFinalDeliveryDateYouCanAccept,
                              onTap: () {
                                _selectLatestDelivery(context);
                              },
                            );
                          },
                        ),
                        20.verticalSpace,
                        Row(
                          children: [
                            Text(
                              context.tr.specialInstructions,
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            8.horizontalSpace,
                            Text(
                              context.tr.optional,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        ContainerCustomTextField(
                          child: CustomTextField(
                            hintText: context.tr.specialInstructions,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              _validationAndStoreValue(
                                _validationCubit,
                                'specialInstructions_${widget.addedItemMainId}',
                                value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppPaddingWidget(
            child: BlocSelector<ValidationCubit, ValidationState, bool>(
              selector: (state) {
                final String mainId = widget.addedItemMainId;

                final quality =
                    state.fieldsValidity['quality_$mainId'] ?? false;
                final time = state.fieldsValidity['time_$mainId'] ?? false;
                final preferredDelivery =
                    state.fieldsValidity['preferredDelivery_$mainId'] ?? false;
                final latestDelivery =
                    state.fieldsValidity['latestDelivery_$mainId'] ?? false;

                return quality && time && preferredDelivery && latestDelivery;
              },
              builder: (context, state) {
                return AppButton(
                  onClick: () {
                    _validationAndStoreValue(
                      _validationCubit,
                      'sourceType_${widget.addedItemMainId}',
                      PurchaseSourcesTypes.officer.toString(),
                    );

                    NavigationService.I.pop();
                  },
                  enabled: state,
                  text: context.tr.confirmDetails,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required String label,
    required void Function() onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: ContainerCustomTextField(
        child: Row(
          children: [
            AppSvg(assetName: AppAssets.calendar, width: 20.r, height: 20.r),
            12.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ),
            10.horizontalSpace,
            Icon(Icons.keyboard_arrow_down, size: 16.r),
          ],
        ),
      ),
    );
  }

  Widget _buildCalender({
    required BuildContext context,
    required void Function(DateTime selectedDate) onDateSelected,
  }) {
    return AppPaddingWidget(
      child: SizedBox(
        height: 400.h,
        child: CustomCalendar(
          onDateSelected: (value) {
            onDateSelected(value);
            NavigationService.I.pop();
          },
        ),
      ),
    );
  }
}
