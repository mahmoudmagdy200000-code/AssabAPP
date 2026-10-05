import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/enums/fixed_assets_quick_search_type.dart';
import '../../domain/enums/fixed_assets_search_type.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_search_empty_result_widget.dart';
import '../../../../core/widgets/profile_image_widget.dart';
import '../../../../core/widgets/selection_circule.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../data/models/fixed_assets_responsible_employee_response.dart';
import '../cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart';

class FixedAssetsSearchFiltersWidgetResponsibleBottomSheet
    extends StatelessWidget {
  final void Function(FixedAssetsResponsibleEmployeeData employee)?
  onEmployeeSelected;

  const FixedAssetsSearchFiltersWidgetResponsibleBottomSheet({
    super.key,
    this.onEmployeeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChooseItemCubit()..initTempSelection()),
        BlocProvider(
          create: (context) =>
              getIt<FixedAssetsGetZoneAndTypeCubit>()
                ..getResponsibleEmployees(),
        ),
      ],
      child: Scaffold(
        body: _FixedAssetsSearchFiltersWidgetResponsibleBottomSheet(
          onEmployeeSelected,
        ),
      ),
    );
  }
}

class _FixedAssetsSearchFiltersWidgetResponsibleBottomSheet
    extends StatelessWidget {
  final void Function(FixedAssetsResponsibleEmployeeData employee)?
  onEmployeeSelected;

  const _FixedAssetsSearchFiltersWidgetResponsibleBottomSheet(
    this.onEmployeeSelected,
  );

  void _removeSelectedQuickSearch(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    validationCubit.validateFieldAndStoreTypedValue<FixedAssetsQuickSearchType>(
      fieldName: 'quickSearchType',
      value: FixedAssetsQuickSearchType.non,
      isValid: false,
    );
  }

  void _chooseSearchType(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.validateFieldAndStoreTypedValue<FixedAssetsSearchType>(
      fieldName: 'searchType',
      value: FixedAssetsSearchType.general,
      isValid: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      FixedAssetsGetZoneAndTypeCubit,
      FixedAssetsGetZoneAndTypeState
    >(
      builder: (context, state) {
        final List<FixedAssetsResponsibleEmployeeData> employees = [];

        if (state is FixedAssetsGetZoneAndTypeLoading) {
          return const AppLoadingWidget();
        } else if (state is FixedAssetsGetZoneAndTypeFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () {
              context
                  .read<FixedAssetsGetZoneAndTypeCubit>()
                  .getResponsibleEmployees();
            },
            withBorder: false,
          );
        } else if (state is FixedAssetsGetResponsibleEmployeesSuccess) {
          employees.addAll(state.employees.data);
        }

        if (employees.isEmpty) {
          return const AppSearchEmptyResultWidget();
        }

        return BlocBuilder<ChooseItemCubit, ChooseItemState>(
          builder: (context, state) {
            return Scaffold(
              body: AppPaddingWidget(
                top: 30.r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.tr.employeesList,
                          style: AppStyles.s20W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.tr.searchForEmployeesDesc,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: context.customColor.border,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.r,
                            vertical: 10.r,
                          ),
                          child: Row(
                            children: [
                              AppSvg(assetName: AppAssets.search, width: 16.r),
                              12.horizontalSpace,
                              Expanded(
                                child: CustomTextField(
                                  onChanged: (value) {},
                                  hintText: context.tr.searchByName,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final isSelected = state.tempSelectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              context.read<ChooseItemCubit>().selectTempItem(
                                index,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: context.theme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isSelected
                                      ? context.theme.primaryColor
                                      : context.customColor.border,
                                ),
                              ),
                              margin: EdgeInsets.only(bottom: 8.r),
                              child: Row(
                                children: [
                                  ProfileImageWidget(
                                    image: employees[index].image,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      employees[index].name,
                                      style: AppStyles.s14W500.copyWith(
                                        color: isSelected
                                            ? context.theme.primaryColor
                                            : context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                  SelectionCircule(isSelected: isSelected),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AppButton(
                      onClick: () {
                        _removeSelectedQuickSearch(context);
                        _chooseSearchType(context);

                        context.read<ChooseItemCubit>().confirmTempSelection();

                        context
                            .read<ValidationCubit>()
                            .validateFieldAndStoreValue(
                              fieldName: 'responsibleName',
                              value: employees[state.tempSelectedIndex!].name,
                              isValid: true,
                            );

                        context
                            .read<ValidationCubit>()
                            .validateFieldAndStoreValue(
                              fieldName: 'responsibleId',
                              value: employees[state.tempSelectedIndex!].id,
                              isValid: true,
                            );

                        onEmployeeSelected?.call(
                          employees[state.tempSelectedIndex!],
                        );

                        NavigationService.I.pop();
                      },
                      text: context.tr.confirmSelection,
                      enabled: state.tempSelectedIndex != null,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
