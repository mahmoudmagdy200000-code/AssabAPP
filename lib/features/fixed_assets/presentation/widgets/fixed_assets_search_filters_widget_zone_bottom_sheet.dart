import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/selection_circule.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../data/models/fixed_assets_zones_response.dart';
import '../cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart';

class FixedAssetsSearchFiltersWidgetZoneBottomSheet extends StatelessWidget {
  final void Function(String zoneId, String zoneName)? onZoneSelected;

  const FixedAssetsSearchFiltersWidgetZoneBottomSheet({
    super.key,
    this.onZoneSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChooseItemCubit()..initTempSelection()),
        BlocProvider(
          create: (context) =>
              getIt<FixedAssetsGetZoneAndTypeCubit>()..getZones(),
        ),
      ],
      child: Scaffold(
        body: _FixedAssetsSearchFiltersWidgetZoneBottomSheet(
          onZoneSelected: onZoneSelected,
        ),
      ),
    );
  }
}

class _FixedAssetsSearchFiltersWidgetZoneBottomSheet extends StatelessWidget {
  final void Function(String zoneId, String zoneName)? onZoneSelected;

  const _FixedAssetsSearchFiltersWidgetZoneBottomSheet({this.onZoneSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      FixedAssetsGetZoneAndTypeCubit,
      FixedAssetsGetZoneAndTypeState
    >(
      builder: (context, state) {
        final List<FixedAssetsZoneData> zones = [];

        if (state is FixedAssetsGetZoneAndTypeLoading) {
          return const AppLoadingWidget();
        } else if (state is FixedAssetsGetZoneAndTypeFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () {
              context.read<FixedAssetsGetZoneAndTypeCubit>().getZones();
            },
            withBorder: false,
          );
        } else if (state is FixedAssetsGetZoneSuccess) {
          zones.addAll(state.zones.zones);
        }

        if (zones.isEmpty) {
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
                          context.tr.zoneListTitle,
                          style: AppStyles.s20W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.tr.searchForAssetZoneDesc,
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
                        itemCount: zones.length,
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
                              margin: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24.r,
                                    height: 24.r,
                                    decoration: BoxDecoration(
                                      color: context.customColor.text2,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        size: 14.r,
                                        color: context.customColor.text4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      zones[index].name,
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
                        context.read<ChooseItemCubit>().confirmTempSelection();

                        onZoneSelected?.call(
                          zones[state.tempSelectedIndex!].id,
                          zones[state.tempSelectedIndex!].name,
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
