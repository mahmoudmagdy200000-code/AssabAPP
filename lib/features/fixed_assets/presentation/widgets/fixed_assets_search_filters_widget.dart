import 'package:assab/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../domain/enums/fixed_assets_quick_search_type.dart';
import '../../domain/enums/fixed_assets_search_type.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/widgets/custom_calendar.dart';
import 'fixed_assets_search_filters_widget_responsible_bottom_sheet.dart';
import 'fixed_assets_search_filters_widget_type_bottom_sheet.dart';
import 'fixed_assets_search_filters_widget_zone_bottom_sheet.dart';

class FixedAssetsSearchFiltersWidget extends StatelessWidget {
  const FixedAssetsSearchFiltersWidget({super.key});

  void _removeSelectedQuickSearch(ValidationCubit validationCubit) {
    validationCubit.validateFieldAndStoreTypedValue<FixedAssetsQuickSearchType>(
      fieldName: 'quickSearchType',
      value: FixedAssetsQuickSearchType.non,
      isValid: false,
    );
  }

  void _chooseSearchType(ValidationCubit validationCubit) {
    validationCubit.validateFieldAndStoreTypedValue<FixedAssetsSearchType>(
      fieldName: 'searchType',
      value: FixedAssetsSearchType.general,
      isValid: true,
    );
  }

  void _validateZone(
    ValidationCubit validationCubit, {
    required String zoneId,
    required String zoneName,
  }) {
    validationCubit.validateFieldAndStoreValue(
      fieldName: 'zoneId',
      value: zoneId,
      isValid: true,
    );
    validationCubit.validateFieldAndStoreValue(
      fieldName: 'zoneName',
      value: zoneName,
      isValid: true,
    );
  }

  void _validateType(
    ValidationCubit validationCubit, {
    required String typeId,
    required String typeName,
  }) {
    validationCubit.validateFieldAndStoreValue(
      fieldName: 'typeId',
      value: typeId,
      isValid: true,
    );
    validationCubit.validateFieldAndStoreValue(
      fieldName: 'typeName',
      value: typeName,
      isValid: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr.filterSearchResultBy,
          style: AppStyles.s14W500.copyWith(color: context.customColor.text3),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.all(10.r),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppGestureDetectorButton(
                      onTap: () {
                        final validationCubit = context.read<ValidationCubit>();

                        AppBottomSheet.customPageRoute(
                          context,
                          (context) => BlocProvider.value(
                            value: validationCubit,
                            child:
                                FixedAssetsSearchFiltersWidgetZoneBottomSheet(
                                  onZoneSelected: (zoneId, zoneName) {
                                    _removeSelectedQuickSearch(validationCubit);
                                    _chooseSearchType(validationCubit);
                                    _validateZone(
                                      validationCubit,
                                      zoneId: zoneId,
                                      zoneName: zoneName,
                                    );
                                  },
                                ),
                          ),
                        );
                      },
                      child: ContainerCustomTextField(
                        label: context.tr.zone,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 9.r,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    String?
                                  >(
                                    selector: (state) =>
                                        state.fieldsValue['zoneName'],
                                    builder: (context, value) {
                                      return Text(
                                        value?.isNotEmpty == true
                                            ? value!
                                            : context.tr.choose,
                                        style: AppStyles.s12W400.copyWith(
                                          color: value?.isNotEmpty == true
                                              ? context.customColor.text1
                                              : context.customColor.text3,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: context.customColor.text3,
                              size: 16.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppGestureDetectorButton(
                      onTap: () {
                        final validationCubit = context.read<ValidationCubit>();

                        AppBottomSheet.customPageRoute(
                          context,
                          (context) => BlocProvider.value(
                            value: validationCubit,
                            child:
                                FixedAssetsSearchFiltersWidgetTypeBottomSheet(
                                  onTypeSelected: (typeId, typeName) {
                                    _removeSelectedQuickSearch(validationCubit);
                                    _chooseSearchType(validationCubit);
                                    _validateType(
                                      validationCubit,
                                      typeId: typeId,
                                      typeName: typeName,
                                    );
                                  },
                                ),
                          ),
                        );
                      },
                      child: ContainerCustomTextField(
                        label: context.tr.type,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 9.r,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    String?
                                  >(
                                    selector: (state) =>
                                        state.fieldsValue['typeName'],
                                    builder: (context, value) {
                                      return Text(
                                        value?.isNotEmpty == true
                                            ? value!
                                            : context.tr.choose,
                                        style: AppStyles.s12W400.copyWith(
                                          color: value?.isNotEmpty == true
                                              ? context.customColor.text1
                                              : context.customColor.text3,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: context.customColor.text3,
                              size: 16.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: AppGestureDetectorButton(
                      onTap: () {
                        final validationCubit = context.read<ValidationCubit>();

                        AppBottomSheet.pageRoute(context, (context) {
                          return Expanded(
                            child: AppPaddingWidget(
                              child: CustomCalendar(
                                onDateSelected: (selectedDate) {
                                  _removeSelectedQuickSearch(validationCubit);
                                  _chooseSearchType(validationCubit);

                                  validationCubit.validateFieldAndStoreValue(
                                    fieldName: 'date',
                                    value: selectedDate.toIso8601String(),
                                    isValid: true,
                                  );

                                  NavigationService.I.pop();
                                },
                              ),
                            ),
                          );
                        });
                      },
                      child: ContainerCustomTextField(
                        label: context.tr.date,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 9.r,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    String?
                                  >(
                                    selector: (state) =>
                                        state.fieldsValue['date'],
                                    builder: (context, value) {
                                      return Text(
                                        value?.isNotEmpty == true
                                            ? DateFormatter.formatDateMDY(
                                                    DateTime.tryParse(
                                                      value ?? '',
                                                    ),
                                                  ) ??
                                                  '-'
                                            : context.tr.choose,
                                        style: AppStyles.s12W400.copyWith(
                                          color: value?.isNotEmpty == true
                                              ? context.customColor.text1
                                              : context.customColor.text3,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: context.customColor.text3,
                              size: 16.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppGestureDetectorButton(
                      onTap: () {
                        final validationCubit = context.read<ValidationCubit>();

                        AppBottomSheet.customPageRoute(
                          context,
                          (context) => BlocProvider.value(
                            value: validationCubit,
                            child:
                                const FixedAssetsSearchFiltersWidgetResponsibleBottomSheet(),
                          ),
                        );
                      },
                      child: ContainerCustomTextField(
                        label: context.tr.responsible,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 9.r,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child:
                                  BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    String?
                                  >(
                                    selector: (state) =>
                                        state.fieldsValue['responsibleName'],
                                    builder: (context, value) {
                                      return Text(
                                        value?.isNotEmpty == true
                                            ? value!
                                            : context.tr.choose,
                                        style: AppStyles.s12W400.copyWith(
                                          color: value?.isNotEmpty == true
                                              ? context.customColor.text1
                                              : context.customColor.text3,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: context.customColor.text3,
                              size: 16.r,
                            ),
                          ],
                        ),
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
