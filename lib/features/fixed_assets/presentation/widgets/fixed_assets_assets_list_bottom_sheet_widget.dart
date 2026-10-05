import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_search_empty_result_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/search/search_state.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/fixed_assets_search_response.dart';
import '../cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart';

class FixedAssetsAssetsListBottomSheetWidget extends StatefulWidget {
  const FixedAssetsAssetsListBottomSheetWidget({super.key});

  @override
  State<FixedAssetsAssetsListBottomSheetWidget> createState() =>
      _FixedAssetsAssetsListBottomSheetWidgetState();
}

class _FixedAssetsAssetsListBottomSheetWidgetState
    extends State<FixedAssetsAssetsListBottomSheetWidget> {
  late final SearchCubit<FixedAssetsSearchItem> _searchCubit;

  @override
  void initState() {
    super.initState();

    _searchCubit = context.read<SearchCubit<FixedAssetsSearchItem>>();
  }

  @override
  void dispose() {
    _searchCubit.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.tr.allAssets} 8',
              style: AppStyles.s20W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            Text(
              context.tr.chooseAnAssetForThisTransferDisposeRequest,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            12.verticalSpace,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
              child: Row(
                children: [
                  AppSvg(assetName: AppAssets.search, width: 16.r),
                  12.horizontalSpace,
                  Expanded(
                    child: CustomTextField(
                      onChanged: (value) {
                        context
                            .read<SearchCubit<FixedAssetsSearchItem>>()
                            .search(
                              value,
                              (item, query) => item.name.toLowerCase().contains(
                                query.toLowerCase(),
                              ),
                            );
                      },
                      hintText: context.tr.searchForBranchByFirstOrLastName,
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Expanded(
              child:
                  BlocListener<
                    FixedAssetsGetZoneAndTypeCubit,
                    FixedAssetsGetZoneAndTypeState
                  >(
                    listener: (context, state) {
                      if (state is FixedAssetsGetAssetsSuccess) {
                        context
                            .read<SearchCubit<FixedAssetsSearchItem>>()
                            .setData(state.assets.assets);
                      }
                    },
                    child:
                        BlocBuilder<
                          FixedAssetsGetZoneAndTypeCubit,
                          FixedAssetsGetZoneAndTypeState
                        >(
                          builder: (context, state) {
                            if (state is FixedAssetsGetZoneAndTypeLoading) {
                              return const AppLoadingWidget();
                            } else if (state
                                is FixedAssetsGetZoneAndTypeFailure) {
                              return AppFailureWidget(
                                failure: state.failure,
                                onRetry: () {
                                  context
                                      .read<FixedAssetsGetZoneAndTypeCubit>()
                                      .getBranches();
                                },
                              );
                            }

                            return BlocBuilder<
                              SearchCubit<FixedAssetsSearchItem>,
                              SearchState<FixedAssetsSearchItem>
                            >(
                              builder: (context, state) {
                                final assets = <FixedAssetsSearchItem>[];

                                if (state
                                    is SearchSuccess<FixedAssetsSearchItem>) {
                                  assets.addAll(state.results);
                                }

                                if (assets.isEmpty) {
                                  return const AppSearchEmptyResultWidget();
                                }

                                return ListView.builder(
                                  itemCount: assets.length,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    final asset = assets[index];

                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                        color: context
                                            .customColor
                                            .reversedTextColor,
                                      ),
                                      padding: EdgeInsets.all(12.r),
                                      margin: EdgeInsets.only(bottom: 12.r),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: AppNetworkImage(
                                                  image: asset.image,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12.r,
                                                      ),
                                                  height: 110.h,
                                                ),
                                              ),
                                              10.horizontalSpace,
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${asset.name} ${asset.code}',
                                                      style: AppStyles.s16W500
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text1,
                                                          ),
                                                    ),
                                                    8.verticalSpace,
                                                    Text(
                                                      asset.location.name,
                                                      style: AppStyles.s12W400
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text3,
                                                          ),
                                                    ),
                                                    asset.status
                                                        .toStrategy()
                                                        .buildConditionWidget(
                                                          context,
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          10.verticalSpace,
                                          CustomTextButton(
                                            text: context.tr.chooseAsset,
                                            backgroundColor:
                                                context.theme.primaryColor,
                                            textColor: context
                                                .customColor
                                                .reversedTextColor,
                                            onTap: () {
                                              final validationCubit = context
                                                  .read<ValidationCubit>();

                                              if (validationCubit.fieldIsExists(
                                                'asset_${asset.id}',
                                              )) {
                                                AppSnackBar.showError(
                                                  context,
                                                  context
                                                      .tr
                                                      .assetIsAlreadyChosen,
                                                );
                                                return;
                                              }

                                              validationCubit.addDynamicFields({
                                                'asset_${asset.id}',
                                              });

                                              validationCubit
                                                  .validateFieldAndStoreTypedValue<
                                                    FixedAssetsSearchItem
                                                  >(
                                                    fieldName:
                                                        'asset_${asset.id}',
                                                    value: asset,
                                                    isValid: true,
                                                  );

                                              NavigationService.I.pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
