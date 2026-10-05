import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../data/models/fixed_assets_zones_response.dart';
import '../cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart';

class SettingNewLocationWidget extends StatefulWidget {
  final String oldLocationId;

  const SettingNewLocationWidget({super.key, required this.oldLocationId});

  @override
  State<SettingNewLocationWidget> createState() =>
      _SettingNewLocationWidgetState();
}

class _SettingNewLocationWidgetState extends State<SettingNewLocationWidget> {
  late ValueNotifier<bool> _isLocationDropdownOpen;

  @override
  void initState() {
    super.initState();

    _isLocationDropdownOpen = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _isLocationDropdownOpen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FixedAssetsGetZoneAndTypeCubit>()..getZones(),
      child: Column(
        children: [
          LabelTextField(text: context.tr.newLocation),
          Row(
            children: [
              Expanded(
                child: ContainerCustomTextField(
                  borderRadius: BorderRadius.circular(12.r),
                  borderColor: context.customColor.border,
                  padding: EdgeInsets.symmetric(
                    vertical: 12.r,
                    horizontal: 16.r,
                  ),
                  child: Row(
                    children: [
                      BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        FixedAssetsZoneData?
                      >(
                        selector: (state) => state
                            .getTypedValue<FixedAssetsZoneData?>('newLocation'),
                        builder: (context, state) {
                          return Text(
                            state?.name ?? 'e.g Kitchen - Preparation',
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
                    ],
                  ),
                ),
              ),
              12.horizontalSpace,
              AppGestureDetectorButton(
                onTap: () => _isLocationDropdownOpen.value =
                    !_isLocationDropdownOpen.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(13.r),
                  child: ValueListenableBuilder(
                    valueListenable: _isLocationDropdownOpen,
                    builder: (context, value, child) {
                      return Icon(
                        value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: context.customColor.text1,
                        size: 15.r,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: _isLocationDropdownOpen,
            builder: (context, value, child) {
              if (!value) {
                return const SizedBox.shrink();
              }

              return BlocBuilder<
                FixedAssetsGetZoneAndTypeCubit,
                FixedAssetsGetZoneAndTypeState
              >(
                builder: (context, state) {
                  final zones = <FixedAssetsZoneData>[];

                  if (state is FixedAssetsGetZoneAndTypeLoading) {
                    return const AppLoadingWidget();
                  } else if (state is FixedAssetsGetZoneAndTypeFailure) {
                    return AppFailureWidget(
                      failure: state.failure,
                      onRetry: () {
                        context
                            .read<FixedAssetsGetZoneAndTypeCubit>()
                            .getZones();
                      },
                    );
                  } else if (state is FixedAssetsGetZoneSuccess) {
                    zones.addAll(state.zones.zones);
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      8.verticalSpace,
                      Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: context.customColor.reversedTextColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: context.customColor.text2,
                              blurRadius: 10.r,
                              spreadRadius: 6.r,
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.r,
                                horizontal: 16.r,
                              ),
                              child: Text(
                                '${zones.length} ${context.tr.activeLocations}',
                                style: AppStyles.s12W500.copyWith(
                                  color: context.customColor.text4,
                                ),
                              ),
                            ),
                            4.verticalSpace,
                            CustomDivider(color: context.customColor.border),
                            4.verticalSpace,
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return AppGestureDetectorButton(
                                    onTap: () {
                                      if (zones[index].id !=
                                          widget.oldLocationId) {
                                        context
                                            .read<ValidationCubit>()
                                            .validateFieldAndStoreTypedValue<
                                              FixedAssetsZoneData
                                            >(
                                              fieldName: 'newLocation',
                                              value: zones[index],
                                              isValid: true,
                                            );

                                        _isLocationDropdownOpen.value = false;
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.r,
                                            horizontal: 16.r,
                                          ),
                                          child: Text(
                                            zones[index].name,
                                            style: AppStyles.s14W400.copyWith(
                                              color:
                                                  zones[index].id !=
                                                      widget.oldLocationId
                                                  ? context.customColor.text1
                                                  : context.customColor.text3,
                                            ),
                                          ),
                                        ),
                                        if (index != zones.length - 1)
                                          const CustomDivider(),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: zones.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
