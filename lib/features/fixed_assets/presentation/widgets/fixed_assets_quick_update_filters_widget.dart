import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../domain/enums/fixed_assets_quick_search_type.dart';
import '../../domain/enums/fixed_assets_search_type.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';

class FixedAssetsQuickUpdateFiltersWidget extends StatelessWidget {
  const FixedAssetsQuickUpdateFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      {
        'title': context.tr.updatedToday,
        'icon': AppAssets.timer,
        'type': FixedAssetsQuickSearchType.updateToday,
      },
      {
        'title': context.tr.updatedYesterday,
        'icon': AppAssets.time04,
        'type': FixedAssetsQuickSearchType.updateYesterday,
      },
      {
        'title': context.tr.notUpdated1Month,
        'icon': AppAssets.calendar,
        'type': FixedAssetsQuickSearchType.notUpdate1Month,
      },
      {
        'title': context.tr.notUpdated2Months,
        'icon': AppAssets.wait,
        'type': FixedAssetsQuickSearchType.notUpdate2Month,
      },
      {
        'title': context.tr.inMyCustody,
        'icon': AppAssets.personSvg,
        'type': FixedAssetsQuickSearchType.inMyCustody,
      },
      {
        'title': context.tr.underMaintenance,
        'icon': AppAssets.tool,
        'type': FixedAssetsQuickSearchType.underMaintenance,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.tr.quickSearchByUpdate,
          style: AppStyles.s14W500.copyWith(color: context.customColor.text4),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
          child: Column(
            children: List.generate(filters.length, (index) {
              final filter = filters[index];

              return AppGestureDetectorButton(
                onTap: () {
                  final validationCubit = context.read<ValidationCubit>();

                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'zoneId',
                    value: '',
                    isValid: false,
                  );

                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'zoneName',
                    value: '',
                    isValid: false,
                  );

                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'typeId',
                    value: '',
                    isValid: false,
                  );

                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'typeName',
                    value: '',
                    isValid: false,
                  );

                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'responsibleId',
                    value: '',
                    isValid: false,
                  );

                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'responsibleName',
                    value: '',
                    isValid: false,
                  );

                  validationCubit.validateFieldAndStoreValue(
                    fieldName: 'date',
                    value: '',
                    isValid: false,
                  );

                  validationCubit
                      .validateFieldAndStoreTypedValue<FixedAssetsSearchType>(
                        fieldName: 'searchType',
                        value: FixedAssetsSearchType.quick,
                        isValid: true,
                      );

                  validationCubit.validateFieldAndStoreTypedValue<
                    FixedAssetsQuickSearchType
                  >(
                    fieldName: 'quickSearchType',
                    value: filter['type'] as FixedAssetsQuickSearchType,
                    isValid: true,
                  );
                },
                child: BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) =>
                      (state.fieldsValidity['quickSearchType'] ?? false) &&
                      state.getTypedValue<FixedAssetsQuickSearchType>(
                            'quickSearchType',
                          ) ==
                          filter['type'],
                  builder: (context, state) {
                    return Column(
                      children: [
                        _buildFilterItem(
                          context,
                          filter['title'] as String,
                          filter['icon'] as String,
                          isSelected: state,
                        ),
                        if (filter != filters.last) ...[
                          SizedBox(height: 15.h),
                          const CustomDivider(),
                          SizedBox(height: 15.h),
                        ],
                      ],
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterItem(
    BuildContext context,
    String title,
    String icon, {
    bool isSelected = false,
  }) {
    return Row(
      children: [
        AppSvg(
          assetName: icon,
          width: 20.r,
          height: 20.r,
          colorFilter: ColorFilter.mode(
            context.customColor.text3,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
          ),
        ),
        8.horizontalSpace,
        SelectionCircule(isSelected: isSelected),
      ],
    );
  }
}
