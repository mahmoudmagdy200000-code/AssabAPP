import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/search/search_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/fixed_assets/presentation/screens/fixed_assets_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/fixed_assets_branches_response.dart';
import '../../data/models/fixed_assets_search_response.dart';
import '../../data/models/fixed_assets_transfer_and_dispose_request.dart';
import '../../domain/enums/fixed_assets_dispose_methods_enum.dart';
import '../../domain/enums/fixed_assets_transfers_and_disposal_enum.dart';
import '../../domain/strategies/fixed_assets_transfers_and_disposal_strategy.dart';
import '../cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart';
import '../cubit/transfer_or_dispose_assets/transfer_or_dispose_assets_cubit.dart';
import '../cubit/transfer_or_dispose_assets/transfer_or_dispose_assets_state.dart';
import '../widgets/fixed_assets_assets_list_bottom_sheet_widget.dart';
import '../widgets/fixed_assets_transfers_and_disposal_acknowledgments_section.dart';
import '../widgets/fixed_assets_transfers_and_disposal_request_type_section.dart';
import '../widgets/fixed_assets_transfers_and_disposal_transfer_details_section.dart';

class FixedAssetsTransfersAndDisposalScreen extends StatelessWidget {
  final FixedAssetsTransfersAndDisposalStrategy? strategy;
  final List<FixedAssetsSearchItem> assets;

  const FixedAssetsTransfersAndDisposalScreen({
    super.key,
    this.strategy,
    required this.assets,
  });
  FixedAssetsTransferAndDisposeRequest request(BuildContext context) {
    final validationState = context.read<ValidationCubit>().state;

    final type = validationState
        .getTypedValue<FixedAssetsTransfersAndDisposalEnum>('requestType');

    return FixedAssetsTransferAndDisposeRequest(
      type: type!,
      branchId: validationState
          .getTypedValue<FixedAssetsBranchItem>('recipientBranch')
          ?.id,
      autoApprove:
          validationState.getTypedValue<bool>('transferDetails') ?? false,
      disposalDate: validationState.getTypedValue<String>(
        'proposedDisposalDate',
      ),
      disposalTime: validationState.getTypedValue<String>(
        'proposedDisposalTime',
      ),
      disposalMethod: validationState
          .getTypedValue<FixedAssetsDisposeMethodsEnum>('disposalMethod'),
      assets: validationState.fieldsValueTyped.entries
          .where((entry) => entry.key.startsWith('asset_'))
          .map((entry) => entry.value as FixedAssetsSearchItem)
          .map(
            (item) => FixedAssetsTransferAndDisposeItem(
              assetId: item.id,
              disposalReason: validationState.getTypedValue<String>(
                'disposalReason_${item.id}',
              ),
              transferReason: validationState.getTypedValue<String>(
                'transferReason_${item.id}',
              ),
              conditionDescription: validationState.getTypedValue<String>(
                'conditionDescription_${item.id}',
              ),
              documentationPhotos: validationState
                  .getTypedValue<MediaFile>('documentationPhotos_${item.id}')
                  ?.toFile,
              visualEvidence: validationState
                  .getTypedValue<MediaFile>('visualEvidence_${item.id}')
                  ?.toFile,
            ),
          )
          .toList(),
    );
  }

  void _transferOrDisposeAssets(BuildContext context) {
    final request = this.request(context);

    context.read<TransferOrDisposeAssetsCubit>().transferOrDisposeAssets(
      request: request,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.dark,
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              children: [
                const AppBackButton(isTransparent: true),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.transferDisposeAsset,
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.reversedTextColor,
                        ),
                      ),
                      Text(
                        context.tr.transferAssetDesc,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        const FixedAssetsTransfersAndDisposalRequestTypeSection()
                            .sliverBoxAdapter,
                        12.verticalSpace.sliverBoxAdapter,
                        LabelTextField(
                          text: context.tr.chooseAssets,
                        ).sliverBoxAdapter,
                        Text(
                          context
                              .tr
                              .clickButtonBelowToSearchForAssetsForThisRequest,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ).sliverBoxAdapter,
                        10.verticalSpace.sliverBoxAdapter,
                        ButtonTextIcon(
                          onTap: () {
                            final fixedAssetsGetZoneAndTypeCubit = context
                                .read<FixedAssetsGetZoneAndTypeCubit>();
                            final searchCubit = context
                                .read<SearchCubit<FixedAssetsSearchItem>>();
                            final validationCubit = context
                                .read<ValidationCubit>();

                            AppBottomSheet.customPageRoute(
                              context,
                              (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: fixedAssetsGetZoneAndTypeCubit,
                                  ),
                                  BlocProvider.value(value: searchCubit),
                                  BlocProvider.value(value: validationCubit),
                                ],
                                child:
                                    const FixedAssetsAssetsListBottomSheetWidget(),
                              ),
                            );
                          },
                          label: context.tr.chooseAssets,
                          icon: Icon(
                            Icons.add,
                            color: context.theme.primaryColor,
                          ),
                          textStyle: AppStyles.s14W400.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ).sliverBoxAdapter,
                        12.verticalSpace.sliverBoxAdapter,
                        BlocSelector<
                          ValidationCubit,
                          ValidationState,
                          List<FixedAssetsSearchItem>
                        >(
                          selector: (state) {
                            final items = <FixedAssetsSearchItem>[];

                            state.fieldsValueTyped.forEach((key, value) {
                              if (key.startsWith('asset_') &&
                                  value is FixedAssetsSearchItem) {
                                items.add(value);
                              }
                            });

                            return items;
                          },
                          builder: (context, state) {
                            if (state.isEmpty) {
                              return const SizedBox.shrink().sliverBoxAdapter;
                            }

                            return DecoratedSliver(
                              decoration: BoxDecoration(
                                color: context.customColor.text2,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              sliver: SliverPadding(
                                padding: EdgeInsets.all(8.r),
                                sliver: SliverList.builder(
                                  itemCount: state.length,
                                  itemBuilder: (context, index) {
                                    final asset = state[index];

                                    return Stack(
                                      key: ValueKey(asset.id),
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: context
                                                .customColor
                                                .reversedTextColor,
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                            border: Border.all(
                                              color: context.customColor.border,
                                            ),
                                          ),
                                          padding: EdgeInsets.all(12.r),
                                          margin: EdgeInsets.only(
                                            bottom: index == state.length - 1
                                                ? 0
                                                : 8.r,
                                          ),
                                          child: Column(
                                            spacing: 12.r,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: AppNetworkImage(
                                                      image: '',
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${asset.name} ${asset.code}',
                                                          style: AppStyles
                                                              .s16W500
                                                              .copyWith(
                                                                color: context
                                                                    .customColor
                                                                    .text1,
                                                              ),
                                                        ),
                                                        8.verticalSpace,
                                                        Text(
                                                          asset.location.name,
                                                          style: AppStyles
                                                              .s12W400
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
                                              _buildTextRow(
                                                context: context,
                                                title: context.tr.zone,
                                                value: asset.location.name,
                                              ),
                                              // _buildTextRow(
                                              //   context: context,
                                              //   title: context.tr.type,
                                              //   value: asset..name,
                                              // ),
                                              _buildTextRow(
                                                context: context,
                                                title: context.tr.status,
                                                customValueWidget: asset.status
                                                    .toStrategy()
                                                    .buildConditionWidget(
                                                      context,
                                                    ),
                                              ),
                                              _buildTextRow(
                                                context: context,
                                                title: context.tr.value,
                                                value: asset.value,
                                                showCurrency: true,
                                              ),
                                              _buildTextRow(
                                                context: context,
                                                title: context.tr.custody,
                                                value: asset.custody,
                                              ),
                                              BlocSelector<
                                                ValidationCubit,
                                                ValidationState,
                                                FixedAssetsTransfersAndDisposalEnum?
                                              >(
                                                selector: (state) {
                                                  return state.getTypedValue<
                                                    FixedAssetsTransfersAndDisposalEnum?
                                                  >('requestType');
                                                },
                                                builder: (context, requestType) {
                                                  if (requestType == null) {
                                                    return const SizedBox.shrink();
                                                  }

                                                  return KeyedSubtree(
                                                    key: ValueKey(requestType),
                                                    child: requestType.strategy
                                                        .buildItemWidget(
                                                          context,
                                                          assetId: asset.id,
                                                        ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 8.r,
                                          right: 8.r,
                                          child: AppSvgButton(
                                            assetName: AppAssets.trashSvg,
                                            iconColor:
                                                context.customColor.error,
                                            onTap: () {
                                              final validationCubit = context
                                                  .read<ValidationCubit>();

                                              validationCubit
                                                  .removeDynamicFields({
                                                    'asset_${asset.id}',
                                                  });
                                              validationCubit.removeTypedField(
                                                'asset_${asset.id}',
                                              );

                                              validationCubit.removeDynamicFields({
                                                'transferReason_${asset.id}',
                                                'documentationPhotos_${asset.id}',
                                                'disposalReason_${asset.id}',
                                                'conditionDescription_${asset.id}',
                                                'visualEvidence_${asset.id}',
                                              });

                                              validationCubit.removeTypedField(
                                                'transferReason_${asset.id}',
                                              );
                                              validationCubit.removeTypedField(
                                                'documentationPhotos_${asset.id}',
                                              );
                                              validationCubit.removeTypedField(
                                                'disposalReason_${asset.id}',
                                              );
                                              validationCubit.removeTypedField(
                                                'conditionDescription_${asset.id}',
                                              );
                                              validationCubit.removeTypedField(
                                                'visualEvidence_${asset.id}',
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        12.verticalSpace.sliverBoxAdapter,
                        const FixedAssetsTransfersAndDisposalAcknowledgmentsSection()
                            .sliverBoxAdapter,
                        12.verticalSpace.sliverBoxAdapter,
                        const FixedAssetsTransfersAndDisposalTransferDetailsSection()
                            .sliverBoxAdapter,
                      ],
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextButton(
                          text: context.tr.cancel,
                          onTap: () {
                            NavigationService.I.pop();
                          },
                          borderRadius: 16.r,
                          padding: EdgeInsets.symmetric(vertical: 16.r),
                          textColor: context.customColor.text1,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child:
                            BlocListener<
                              TransferOrDisposeAssetsCubit,
                              TransferOrDisposeAssetsState
                            >(
                              listener: (context, state) {
                                if (state is TransferOrDisposeAssetsSuccess) {
                                  NavigationService.I.pop();
                                  AppBottomSheet.customPageRoute(
                                    context,
                                    (context) => FixedAssetsSuccessScreen(
                                      title: context.tr.requestSubmitted,
                                    ),
                                  );
                                } else if (state
                                    is TransferOrDisposeAssetsFailure) {
                                  AppDialog.showErrorDialog(
                                    context: context,
                                    failure: state.failure,
                                  );
                                }
                              },
                              child:
                                  BlocBuilder<
                                    TransferOrDisposeAssetsCubit,
                                    TransferOrDisposeAssetsState
                                  >(
                                    builder: (context, state) {
                                      if (state
                                          is TransferOrDisposeAssetsLoading) {
                                        return const AppButtonLoading();
                                      }

                                      return BlocSelector<
                                        ValidationCubit,
                                        ValidationState,
                                        bool
                                      >(
                                        selector: (state) =>
                                            state.enableButton &&
                                            state.fieldsValueTyped.keys.any(
                                              (key) => key.startsWith('asset_'),
                                            ),
                                        builder: (context, state) {
                                          return AppButton(
                                            text: context.tr.submitNow,
                                            onClick: () =>
                                                _transferOrDisposeAssets(
                                                  context,
                                                ),
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16.r,
                                            ),
                                            enabled: state,
                                          );
                                        },
                                      );
                                    },
                                  ),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customValueWidget,
    bool showCurrency = false,
  }) {
    return Row(
      spacing: 8.r,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        if (customValueWidget != null)
          customValueWidget
        else
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4.r,
              children: [
                if (showCurrency) const SaudiRiyalSvgWidget(),
                Flexible(
                  child: Text(
                    value ?? '',
                    style: AppStyles.s13W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
