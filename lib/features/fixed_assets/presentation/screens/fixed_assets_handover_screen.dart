import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/purchasing_officer_notification_enum.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/fixed_assets_responsible_employee_response.dart';
import '../../data/models/fixed_assets_start_handover_request.dart';
import '../cubit/fixd_assets_start_handover/fixd_assets_start_handover_cubit.dart';
import '../cubit/fixd_assets_start_handover/fixd_assets_start_handover_state.dart';
import '../cubit/get_handover_included_zones/get_handover_included_zones_cubit.dart';
import '../cubit/get_handover_included_zones/get_handover_included_zones_state.dart';
import '../widgets/fixed_assets_search_filters_widget_responsible_bottom_sheet.dart';
import 'fixed_assets_success_screen.dart';

class FixedAssetsHandoverScreen extends StatelessWidget {
  const FixedAssetsHandoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    return Scaffold(
      backgroundColor: context.customColor.dark,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.handoverSessionPreparation,
            subtitle: context.tr.handoverSessionPreparationDesc,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(16.r),
              child: BlocBuilder<GetHandoverIncludedZonesCubit, GetHandoverIncludedZonesState>(
                builder: (context, state) {
                  if (state is GetHandoverIncludedZonesLoading) {
                    return const AppLoadingWidget();
                  } else if (state is GetHandoverIncludedZonesFailure) {
                    return AppFailureWidget(failure: state.failure);
                  } else if (state is GetHandoverIncludedZonesSuccess) {
                    final response = state.response;

                    return Column(
                      children: [
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              LabelTextField(
                                text: context.tr.recipientInfo,
                              ).sliverBoxAdapter,
                              4.verticalSpace.sliverBoxAdapter,
                              Text(
                                context.tr.chooseRecipientEmployeeToGetStarted,
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ).sliverBoxAdapter,
                              10.verticalSpace.sliverBoxAdapter,
                              BlocBuilder<ValidationCubit, ValidationState>(
                                builder: (context, validationState) {
                                  final selectedEmployee = validationState
                                      .getTypedValue<
                                        FixedAssetsResponsibleEmployeeData
                                      >('responsibleEmployee');

                                  if (selectedEmployee == null) {
                                    return ButtonTextIcon(
                                      label: context.tr.chooseEmployee,
                                      icon: Icon(
                                        Icons.add,
                                        color: context.theme.primaryColor,
                                        size: 16.r,
                                      ),
                                      onTap: () {
                                        AppBottomSheet.customPageRoute(
                                          context,
                                          (context) => BlocProvider.value(
                                            value: validationCubit,
                                            child: FixedAssetsSearchFiltersWidgetResponsibleBottomSheet(
                                              onEmployeeSelected: (employee) {
                                                validationCubit
                                                    .validateFieldAndStoreTypedValue<
                                                      FixedAssetsResponsibleEmployeeData
                                                    >(
                                                      fieldName:
                                                          'responsibleEmployee',
                                                      value: employee,
                                                      isValid: true,
                                                    );
                                                validationCubit
                                                    .validateFieldAndStoreValue(
                                                      fieldName:
                                                          'responsibleName',
                                                      value: employee.name,
                                                      isValid: true,
                                                    );
                                                validationCubit
                                                    .validateFieldAndStoreValue(
                                                      fieldName:
                                                          'responsibleId',
                                                      value: employee.id,
                                                      isValid: true,
                                                    );
                                                validationCubit
                                                    .validateFieldAndStoreValue(
                                                      fieldName:
                                                          'responsibleImage',
                                                      value: employee.image,
                                                      isValid: true,
                                                    );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      backgroundColor: Colors.transparent,
                                      textColor: context.theme.primaryColor,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16.r,
                                      ),
                                      borderRadius: BorderRadius.circular(15.r),
                                      borderColor: context.theme.primaryColor,
                                    ).sliverBoxAdapter;
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: context.customColor.text2,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.r,
                                      horizontal: 12.r,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: context
                                            .customColor
                                            .reversedTextColor,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.r,
                                        horizontal: 12.r,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ProfileImageWidget(
                                                image: selectedEmployee.image,
                                              ),
                                              10.horizontalSpace,
                                              Flexible(
                                                child: Text(
                                                  selectedEmployee.name,
                                                  style: AppStyles.s14W500
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text1,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          8.verticalSpace,
                                          ButtonTextIcon(
                                            label: context.tr.changeRecipient,
                                            icon: Icon(
                                              Icons.refresh,
                                              color: context.customColor.text4,
                                              size: 16.r,
                                            ),
                                            onTap: () {
                                              AppBottomSheet.customPageRoute(
                                                context,
                                                (context) => BlocProvider.value(
                                                  value: validationCubit,
                                                  child: FixedAssetsSearchFiltersWidgetResponsibleBottomSheet(
                                                    onEmployeeSelected: (employee) {
                                                      validationCubit
                                                          .validateFieldAndStoreTypedValue<
                                                            FixedAssetsResponsibleEmployeeData
                                                          >(
                                                            fieldName:
                                                                'responsibleEmployee',
                                                            value: employee,
                                                            isValid: true,
                                                          );
                                                      validationCubit
                                                          .validateFieldAndStoreValue(
                                                            fieldName:
                                                                'responsibleName',
                                                            value:
                                                                employee.name,
                                                            isValid: true,
                                                          );
                                                      validationCubit
                                                          .validateFieldAndStoreValue(
                                                            fieldName:
                                                                'responsibleId',
                                                            value: employee.id,
                                                            isValid: true,
                                                          );
                                                      validationCubit
                                                          .validateFieldAndStoreValue(
                                                            fieldName:
                                                                'responsibleImage',
                                                            value:
                                                                employee.image,
                                                            isValid: true,
                                                          );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                            backgroundColor:
                                                context.customColor.text2,
                                            textColor:
                                                context.customColor.text4,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 12.r,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              1000.r,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).sliverBoxAdapter;
                                },
                              ),
                              20.verticalSpace.sliverBoxAdapter,
                              Text(
                                context.tr.sessionDetails,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ).sliverBoxAdapter,
                              5.verticalSpace.sliverBoxAdapter,
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: context.customColor.border,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.r,
                                  vertical: 8.r,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${context.tr.date}: ',
                                              style: AppStyles.s12W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                          ),
                                          3.horizontalSpace,
                                          Flexible(
                                            child: Text(
                                              DateFormatter.formatDateMDY(
                                                    DateTime.now(),
                                                  ) ??
                                                  '-',
                                              style: AppStyles.s12W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${context.tr.time}: ',
                                              style: AppStyles.s12W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                          ),
                                          3.horizontalSpace,
                                          Flexible(
                                            child: Text(
                                              DateFormatter.formatTimeHM(
                                                    DateTime.now(),
                                                  ) ??
                                                  '-',
                                              style: AppStyles.s12W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '${context.tr.type}: ',
                                              style: AppStyles.s12W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                          ),
                                          3.horizontalSpace,
                                          Flexible(
                                            child: Text(
                                              context.tr.full,
                                              style: AppStyles.s12W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ).sliverBoxAdapter,
                              15.verticalSpace.sliverBoxAdapter,
                              LabelTextField(
                                text: context.tr.includedZones,
                              ).sliverBoxAdapter,
                              4.verticalSpace.sliverBoxAdapter,
                              Text(
                                context.tr.chooseWhatZonesToHandover,
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ).sliverBoxAdapter,
                              5.verticalSpace.sliverBoxAdapter,
                              BlocBuilder<ValidationCubit, ValidationState>(
                                builder: (context, validationState) {
                                  final selectedAssets =
                                      validationState.getListValue<String>(
                                        'selectedAssetIds',
                                      ) ??
                                      <String>[];

                                  // Calculate total assets across all zones
                                  final totalAssets = response.includedZones
                                      .fold<int>(
                                        0,
                                        (sum, zone) =>
                                            sum + zone.assetsInZone.length,
                                      );

                                  final allSelected =
                                      selectedAssets.isNotEmpty &&
                                      selectedAssets.length == totalAssets;

                                  return Row(
                                    children: [
                                      AppCheckBox(
                                        onChanged: (value) {
                                          final updatedAssets = value == true
                                              ? response.includedZones
                                                    .expand(
                                                      (zone) =>
                                                          zone.assetsInZone.map(
                                                            (asset) =>
                                                                asset.assetId,
                                                          ),
                                                    )
                                                    .toList()
                                              : <String>[];

                                          validationCubit
                                              .validateFieldAndStoreList<
                                                String
                                              >(
                                                fieldName: 'selectedAssetIds',
                                                value: updatedAssets,
                                                isValid:
                                                    updatedAssets.isNotEmpty,
                                              );
                                        },
                                        value: allSelected,
                                      ),
                                      5.horizontalSpace,
                                      Flexible(
                                        child: Text(
                                          context.tr.selectAllZones,
                                          style: AppStyles.s13W400.copyWith(
                                            color: context.customColor.text4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).sliverBoxAdapter,
                              10.verticalSpace.sliverBoxAdapter,
                              SliverList.builder(
                                itemCount: response.includedZones.length,
                                itemBuilder: (context, index1) {
                                  final zone = response.includedZones[index1];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      10.verticalSpace,
                                      BlocBuilder<
                                        ValidationCubit,
                                        ValidationState
                                      >(
                                        builder: (context, validationState) {
                                          final selectedAssets =
                                              validationState
                                                  .getListValue<String>(
                                                    'selectedAssetIds',
                                                  ) ??
                                              <String>[];

                                          // Assets in this zone that are selected
                                          final zoneAssetsSelected = zone
                                              .assetsInZone
                                              .where(
                                                (asset) => selectedAssets
                                                    .contains(asset.assetId),
                                              )
                                              .length;

                                          final allZoneAssetsSelected =
                                              zone.assetsInZone.isNotEmpty &&
                                              zoneAssetsSelected ==
                                                  zone.assetsInZone.length;

                                          return Row(
                                            children: [
                                              AppCheckBox(
                                                onChanged: (value) {
                                                  final updatedAssets =
                                                      List<String>.from(
                                                        selectedAssets,
                                                      );

                                                  if (value == true) {
                                                    // Select all assets in this zone
                                                    for (var asset
                                                        in zone.assetsInZone) {
                                                      if (!updatedAssets
                                                          .contains(
                                                            asset.assetId,
                                                          )) {
                                                        updatedAssets.add(
                                                          asset.assetId,
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    // Deselect all assets in this zone
                                                    for (var asset
                                                        in zone.assetsInZone) {
                                                      updatedAssets.remove(
                                                        asset.assetId,
                                                      );
                                                    }
                                                  }

                                                  validationCubit
                                                      .validateFieldAndStoreList<
                                                        String
                                                      >(
                                                        fieldName:
                                                            'selectedAssetIds',
                                                        value: updatedAssets,
                                                        isValid: updatedAssets
                                                            .isNotEmpty,
                                                      );
                                                },
                                                value: allZoneAssetsSelected,
                                              ),
                                              8.horizontalSpace,
                                              Flexible(
                                                child: Text(
                                                  '${zone.zoneName} (${zone.assetsInZone.length})',
                                                  style: AppStyles.s16W500
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text1,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      10.verticalSpace,
                                      Container(
                                        decoration: BoxDecoration(
                                          color: context.customColor.text2,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(10.r),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          separatorBuilder: (context, index) =>
                                              10.verticalSpace,
                                          itemCount: zone.assetsInZone.length,
                                          itemBuilder: (context, index2) {
                                            final asset =
                                                zone.assetsInZone[index2];
                                            return BlocBuilder<
                                              ValidationCubit,
                                              ValidationState
                                            >(
                                              builder: (context, validationState) {
                                                final selectedAssets =
                                                    validationState
                                                        .getListValue<String>(
                                                          'selectedAssetIds',
                                                        ) ??
                                                    <String>[];
                                                final isAssetSelected =
                                                    selectedAssets.contains(
                                                      asset.assetId,
                                                    );

                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: context
                                                        .customColor
                                                        .reversedTextColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.r,
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.all(10.r),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          AppCheckBox(
                                                            onChanged: (value) {
                                                              final updatedAssets =
                                                                  List<
                                                                    String
                                                                  >.from(
                                                                    selectedAssets,
                                                                  );
                                                              if (value ==
                                                                  true) {
                                                                if (!updatedAssets
                                                                    .contains(
                                                                      asset
                                                                          .assetId,
                                                                    )) {
                                                                  updatedAssets.add(
                                                                    asset
                                                                        .assetId,
                                                                  );
                                                                }
                                                              } else {
                                                                updatedAssets
                                                                    .remove(
                                                                      asset
                                                                          .assetId,
                                                                    );
                                                              }

                                                              validationCubit.validateFieldAndStoreList<
                                                                String
                                                              >(
                                                                fieldName:
                                                                    'selectedAssetIds',
                                                                value:
                                                                    updatedAssets,
                                                                isValid:
                                                                    updatedAssets
                                                                        .isNotEmpty,
                                                              );
                                                            },
                                                            value:
                                                                isAssetSelected,
                                                          ),
                                                          10.horizontalSpace,
                                                          Flexible(
                                                            child: AppNetworkImage(
                                                              image: asset
                                                                  .assetImageURL,
                                                              height: 60.r,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10.r,
                                                                  ),
                                                            ),
                                                          ),
                                                          10.horizontalSpace,
                                                          Flexible(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  asset
                                                                      .assetName,
                                                                  style: AppStyles
                                                                      .s14W500
                                                                      .copyWith(
                                                                        color: context
                                                                            .customColor
                                                                            .text1,
                                                                      ),
                                                                ),
                                                                5.verticalSpace,
                                                                Text(
                                                                  zone.zoneName,
                                                                  style: AppStyles
                                                                      .s13W400
                                                                      .copyWith(
                                                                        color: context
                                                                            .customColor
                                                                            .text3,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      10.verticalSpace,
                                                      const CustomDivider(),
                                                      10.verticalSpace,
                                                      Row(
                                                        children: [
                                                          Text(
                                                            asset.assetName,
                                                            style: AppStyles
                                                                .s13W400
                                                                .copyWith(
                                                                  color: context
                                                                      .customColor
                                                                      .text4,
                                                                ),
                                                          ),
                                                          10.horizontalSpace,
                                                          Flexible(
                                                            child: Row(
                                                              children: [
                                                                if (asset
                                                                        .totalExcellentConditionQuantityInZone >
                                                                    0) ...[
                                                                  Container(
                                                                    decoration: const BoxDecoration(
                                                                      color: AppColors
                                                                          .lightGreen,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          7.r,
                                                                        ),
                                                                    child: Text(
                                                                      '${asset.totalExcellentConditionQuantityInZone}',
                                                                      style: AppStyles
                                                                          .s11W400
                                                                          .copyWith(
                                                                            color:
                                                                                context.customColor.reversedTextColor,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  5.horizontalSpace,
                                                                ],
                                                                if (asset
                                                                        .totalNeedAttentionConditionQuantityInZone >
                                                                    0) ...[
                                                                  Container(
                                                                    decoration: const BoxDecoration(
                                                                      color: AppColors
                                                                          .yellow,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          7.r,
                                                                        ),
                                                                    child: Text(
                                                                      '${asset.totalNeedAttentionConditionQuantityInZone}',
                                                                      style: AppStyles
                                                                          .s11W400
                                                                          .copyWith(
                                                                            color:
                                                                                context.customColor.reversedTextColor,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  5.horizontalSpace,
                                                                ],
                                                                if (asset
                                                                        .totalProblemConditionQuantityInZone >
                                                                    0) ...[
                                                                  Container(
                                                                    decoration: const BoxDecoration(
                                                                      color: AppColors
                                                                          .errorLight,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          7.r,
                                                                        ),
                                                                    child: Text(
                                                                      '${asset.totalProblemConditionQuantityInZone}',
                                                                      style: AppStyles
                                                                          .s11W400
                                                                          .copyWith(
                                                                            color:
                                                                                context.customColor.reversedTextColor,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              // SliverGrid.builder(
                              //   gridDelegate:
                              //       SliverGridDelegateWithFixedCrossAxisCount(
                              //         crossAxisCount: 2,
                              //         mainAxisSpacing: 8.r,
                              //         crossAxisSpacing: 8.r,
                              //         childAspectRatio: 3.5,
                              //       ),
                              //   itemCount: response.includedZones.length,
                              //   itemBuilder: (context, index) {
                              //     return BlocBuilder<
                              //       ValidationCubit,
                              //       ValidationState
                              //     >(
                              //       builder: (context, validationState) {
                              //         final selectedZones =
                              //             validationState.getListValue<String>(
                              //               'includedZoneIds',
                              //             ) ??
                              //             <String>[];
                              //         final zoneId =
                              //             response.includedZones[index].zoneID;
                              //         final isSelected = selectedZones.contains(
                              //           zoneId,
                              //         );

                              //         return Container(
                              //           decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(
                              //               12.r,
                              //             ),
                              //             border: Border.all(
                              //               color: context.customColor.border,
                              //             ),
                              //           ),
                              //           padding: EdgeInsets.symmetric(
                              //             horizontal: 12.r,
                              //           ),
                              //           child: Row(
                              //             children: [
                              //               AppCheckBox(
                              //                 onChanged: (value) {
                              //                   final updatedZones =
                              //                       List<String>.from(
                              //                         selectedZones,
                              //                       );
                              //                   if (value == true) {
                              //                     if (!updatedZones.contains(
                              //                       zoneId,
                              //                     )) {
                              //                       updatedZones.add(zoneId);
                              //                     }
                              //                   } else {
                              //                     updatedZones.remove(zoneId);
                              //                   }

                              //                   validationCubit
                              //                       .validateFieldAndStoreList<
                              //                         String
                              //                       >(
                              //                         fieldName:
                              //                             'includedZoneIds',
                              //                         value: updatedZones,
                              //                         isValid: updatedZones
                              //                             .isNotEmpty,
                              //                       );
                              //                 },
                              //                 value: isSelected,
                              //               ),
                              //               5.horizontalSpace,
                              //               Flexible(
                              //                 child: Text(
                              //                   '${response.includedZones[index].zoneName} (${response.includedZones[index].assetsInZone.length})',
                              //                   style: AppStyles.s13W400
                              //                       .copyWith(
                              //                         color: context
                              //                             .customColor
                              //                             .text4,
                              //                       ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         );
                              //       },
                              //     );
                              //   },
                              // ),
                              10.verticalSpace.sliverBoxAdapter,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${context.tr.total}: ',
                                            style: AppStyles.s12W400.copyWith(
                                              color: context.customColor.text3,
                                            ),
                                          ),
                                        ),
                                        3.horizontalSpace,
                                        Flexible(
                                          child: Text(
                                            response.totalIncludedItems
                                                .toString(),
                                            style: AppStyles.s12W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${context.tr.value}: ',
                                            style: AppStyles.s12W400.copyWith(
                                              color: context.customColor.text3,
                                            ),
                                          ),
                                        ),
                                        3.horizontalSpace,
                                        Flexible(
                                          child: Text(
                                            '${response.totalValueOfIncludedZones.toStringAsFixed(2)} SAR',
                                            style: AppStyles.s12W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ).sliverBoxAdapter,
                              10.verticalSpace.sliverBoxAdapter,
                              // ButtonTextIcon(
                              //   label: context.tr.detailedList,
                              //   icon: Icon(
                              //     Icons.keyboard_arrow_down_rounded,
                              //     color: context.customColor.text1,
                              //     size: 16.r,
                              //   ),
                              //   onTap: () {
                              //     AppBottomSheet.show(
                              //       context,
                              //       (context) =>
                              //           FixedAssetsDetailedListZonesHandoverBottomSheetWidget(
                              //             includedZones: response.includedZones,
                              //           ),
                              //     );
                              //   },
                              //   reversed: true,
                              //   backgroundColor: context.customColor.text2,
                              //   textColor: context.customColor.text1,
                              //   padding: EdgeInsets.symmetric(vertical: 16.r),
                              //   borderRadius: BorderRadius.circular(15.r),
                              // ).sliverBoxAdapter,
                              10.verticalSpace.sliverBoxAdapter,
                              ContainerCustomTextField(
                                label: context.tr.additionalNote,
                                child: CustomTextField(
                                  maxLines: 3,
                                  hintText: context.tr.additionalNote,
                                  onChanged: (value) {
                                    validationCubit.validateFieldAndStoreValue(
                                      fieldName: 'note',
                                      value: value,
                                      isValid: value.isNotEmpty,
                                    );
                                  },
                                ),
                              ).sliverBoxAdapter,
                              15.verticalSpace.sliverBoxAdapter,
                              LabelTextField(
                                text: context.tr.sendInvitation,
                              ).sliverBoxAdapter,
                              4.verticalSpace.sliverBoxAdapter,
                              Text(
                                context.tr.notifyRecipientVia,
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ).sliverBoxAdapter,
                              4.verticalSpace.sliverBoxAdapter,
                              BlocBuilder<ValidationCubit, ValidationState>(
                                builder: (context, validationState) {
                                  final invitations =
                                      validationState.getListValue<
                                        PurchasingOfficerNotificationEnum
                                      >('sendInvitations') ??
                                      <PurchasingOfficerNotificationEnum>[];
                                  final smsSelected = invitations.contains(
                                    PurchasingOfficerNotificationEnum.sms,
                                  );
                                  final whatsappSelected = invitations.contains(
                                    PurchasingOfficerNotificationEnum.whatsApp,
                                  );

                                  return Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            border: Border.all(
                                              color: context.customColor.border,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.r,
                                            vertical: 8.r,
                                          ),
                                          child: Row(
                                            children: [
                                              AppCheckBox(
                                                onChanged: (value) {
                                                  final updatedInvitations =
                                                      List<
                                                        PurchasingOfficerNotificationEnum
                                                      >.from(invitations);
                                                  if (value == true) {
                                                    if (!updatedInvitations
                                                        .contains(
                                                          PurchasingOfficerNotificationEnum
                                                              .sms,
                                                        )) {
                                                      updatedInvitations.add(
                                                        PurchasingOfficerNotificationEnum
                                                            .sms,
                                                      );
                                                    }
                                                  } else {
                                                    updatedInvitations.remove(
                                                      PurchasingOfficerNotificationEnum
                                                          .sms,
                                                    );
                                                  }

                                                  validationCubit
                                                      .validateFieldAndStoreList<
                                                        PurchasingOfficerNotificationEnum
                                                      >(
                                                        fieldName:
                                                            'sendInvitations',
                                                        value:
                                                            updatedInvitations,
                                                        isValid:
                                                            updatedInvitations
                                                                .isNotEmpty,
                                                      );
                                                },
                                                value: smsSelected,
                                              ),
                                              5.horizontalSpace,
                                              Flexible(
                                                child: Text(
                                                  context.tr.sms,
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      8.horizontalSpace,
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            border: Border.all(
                                              color: context.customColor.border,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.r,
                                            vertical: 8.r,
                                          ),
                                          child: Row(
                                            children: [
                                              AppCheckBox(
                                                onChanged: (value) {
                                                  final updatedInvitations =
                                                      List<
                                                        PurchasingOfficerNotificationEnum
                                                      >.from(invitations);
                                                  if (value == true) {
                                                    if (!updatedInvitations
                                                        .contains(
                                                          PurchasingOfficerNotificationEnum
                                                              .whatsApp,
                                                        )) {
                                                      updatedInvitations.add(
                                                        PurchasingOfficerNotificationEnum
                                                            .whatsApp,
                                                      );
                                                    }
                                                  } else {
                                                    updatedInvitations.remove(
                                                      PurchasingOfficerNotificationEnum
                                                          .whatsApp,
                                                    );
                                                  }

                                                  validationCubit
                                                      .validateFieldAndStoreList<
                                                        PurchasingOfficerNotificationEnum
                                                      >(
                                                        fieldName:
                                                            'sendInvitations',
                                                        value:
                                                            updatedInvitations,
                                                        isValid:
                                                            updatedInvitations
                                                                .isNotEmpty,
                                                      );
                                                },
                                                value: whatsappSelected,
                                              ),
                                              5.horizontalSpace,
                                              Flexible(
                                                child: Text(
                                                  context.tr.whatsapp,
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).sliverBoxAdapter,
                              15.verticalSpace.sliverBoxAdapter,
                              LabelTextField(
                                text: context.tr.confirmations,
                              ).sliverBoxAdapter,
                              4.verticalSpace.sliverBoxAdapter,
                              BlocBuilder<ValidationCubit, ValidationState>(
                                builder: (context, validationState) {
                                  final recipientConfirmed =
                                      validationState
                                          .fieldsValidity['confirmRecipientInPerson'] ==
                                      true;
                                  final assetsReadyConfirmed =
                                      validationState
                                          .fieldsValidity['confirmAssetsReady'] ==
                                      true;

                                  return Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            border: Border.all(
                                              color: context.customColor.border,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.r,
                                            vertical: 8.r,
                                          ),
                                          child: Row(
                                            children: [
                                              AppCheckBox(
                                                onChanged: (value) {
                                                  validationCubit.validateField(
                                                    'confirmRecipientInPerson',
                                                    value == true,
                                                  );
                                                },
                                                value: recipientConfirmed,
                                              ),
                                              5.horizontalSpace,
                                              Flexible(
                                                child: Text(
                                                  context
                                                      .tr
                                                      .recipientIsHereInPerson,
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      8.horizontalSpace,
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            border: Border.all(
                                              color: context.customColor.border,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.r,
                                            vertical: 8.r,
                                          ),
                                          child: Row(
                                            children: [
                                              AppCheckBox(
                                                onChanged: (value) {
                                                  validationCubit.validateField(
                                                    'confirmAssetsReady',
                                                    value == true,
                                                  );
                                                },
                                                value: assetsReadyConfirmed,
                                              ),
                                              5.horizontalSpace,
                                              Flexible(
                                                child: Text(
                                                  context
                                                      .tr
                                                      .selectedAssetsAreAllReady,
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).sliverBoxAdapter,
                            ],
                          ),
                        ),
                        20.verticalSpace,
                        BlocListener<
                          FixdAssetsStartHandoverCubit,
                          FixdAssetsStartHandoverState
                        >(
                          listener: (context, state) {
                            if (state is FixdAssetsStartHandoverSuccess) {
                              NavigationService.I.pop();
                              AppBottomSheet.customPageRoute(
                                context,
                                (context) => FixedAssetsSuccessScreen(
                                  title: context.tr.handoverInitiated,
                                  message:
                                      context.tr.yourHandoverRequestHasBeenSent,
                                ),
                              );
                            } else if (state
                                is FixdAssetsStartHandoverFailure) {
                              AppDialog.showErrorDialog(
                                context: context,
                                failure: state.failure,
                              );
                            }
                          },
                          child:
                              BlocBuilder<
                                FixdAssetsStartHandoverCubit,
                                FixdAssetsStartHandoverState
                              >(
                                builder: (context, state) {
                                  if (state is FixdAssetsStartHandoverLoading) {
                                    return const AppButtonLoading();
                                  }

                                  return BlocSelector<
                                    ValidationCubit,
                                    ValidationState,
                                    bool
                                  >(
                                    selector: (validationState) {
                                      final hasAssets =
                                          validationState.getListLength(
                                            'selectedAssetIds',
                                          ) >
                                          0;
                                      final hasInvitations =
                                          validationState.getListLength(
                                            'sendInvitations',
                                          ) >
                                          0;
                                      final hasNote =
                                          validationState
                                              .fieldsValidity['note'] ==
                                          true;
                                      final recipientSelected =
                                          validationState
                                              .fieldsValidity['responsibleId'] ==
                                          true;
                                      final recipientConfirmed =
                                          validationState
                                              .fieldsValidity['confirmRecipientInPerson'] ==
                                          true;
                                      final assetsReadyConfirmed =
                                          validationState
                                              .fieldsValidity['confirmAssetsReady'] ==
                                          true;

                                      return recipientSelected &&
                                          hasAssets &&
                                          hasNote &&
                                          hasInvitations &&
                                          recipientConfirmed &&
                                          assetsReadyConfirmed;
                                    },
                                    builder: (context, enableButton) {
                                      return AppButton(
                                        onClick: () {
                                          context
                                              .read<
                                                FixdAssetsStartHandoverCubit
                                              >()
                                              .startHandover(
                                                request: FixedAssetsStartHandoverRequest(
                                                  recipientEmployeeId:
                                                      validationCubit
                                                          .getFieldValue(
                                                            'responsibleId',
                                                          ),
                                                  note: validationCubit
                                                      .getFieldValue('note'),
                                                  includedAssetIds:
                                                      validationCubit
                                                          .getListValue<String>(
                                                            'selectedAssetIds',
                                                          ) ??
                                                      <String>[],
                                                  sendInvitations:
                                                      validationCubit
                                                          .getListValue<
                                                            PurchasingOfficerNotificationEnum
                                                          >('sendInvitations')
                                                          ?.map(
                                                            (e) => e.toString(),
                                                          )
                                                          .toList() ??
                                                      <String>[],
                                                ),
                                              );
                                        },
                                        text: context.tr.startSessionAndNotify,
                                        enabled: enableButton,
                                      );
                                    },
                                  );
                                },
                              ),
                        ),
                      ],
                    );
                  }

                  return AppLocalFailure(onRetry: () {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
