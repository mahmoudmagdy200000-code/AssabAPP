import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/models/media_file_model.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../data/models/receive_assets_request.dart';
import '../../data/models/receive_assets_respons.dart';
import '../../domain/strategies/fixed_assets_transfer_types_strategy.dart';
import '../cubit/fixed_assets_receive_assets/fixed_assets_receive_assets_cubit.dart';
import '../screens/fixed_assets_success_screen.dart';
import 'fixed_assets_receive_assets_list_item_widget.dart';

class FixedAssetsReceiveAssetsListViewWidget extends StatefulWidget {
  final List<ReceiveAssetsData> items;
  final String requestId;
  final FixedAssetsTransferTypesStrategy transferTypeStrategy;

  const FixedAssetsReceiveAssetsListViewWidget({
    super.key,
    required this.items,
    required this.requestId,
    required this.transferTypeStrategy,
  });

  @override
  State<FixedAssetsReceiveAssetsListViewWidget> createState() =>
      _FixedAssetsReceiveAssetsListViewWidgetState();
}

class _FixedAssetsReceiveAssetsListViewWidgetState
    extends State<FixedAssetsReceiveAssetsListViewWidget> {
  bool _selectAssetsKeysAdded = false;

  void _selectAndUnSelectAllItems(
    BuildContext context, {
    required List<ReceiveAssetsData> items,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    final assetKeys = items.map((e) => 'asset_${e.id}');

    final allItemsSelected = assetKeys
        .map((key) => validationCubit.fieldIsValid(key))
        .every((isSelected) => isSelected);

    if (allItemsSelected) {
      for (var item in items) {
        final fieldName = 'asset_${item.id}';

        validationCubit.validateFieldAndStoreTypedValue<bool>(
          fieldName: fieldName,
          value: false,
          isValid: false,
        );

        _removeValidationFields(context, item: item);
      }
    } else {
      for (var item in items) {
        final fieldName = 'asset_${item.id}';
        final isAlreadySelected = validationCubit.fieldIsValid(fieldName);

        if (isAlreadySelected) continue;

        validationCubit.validateFieldAndStoreTypedValue<bool>(
          fieldName: fieldName,
          value: true,
          isValid: true,
        );

        _addValidationFields(context, item: item);
      }
    }
  }

  void _addValidationFields(
    BuildContext context, {
    required ReceiveAssetsData item,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.addDynamicFields({
      'assignedZoneId_${item.id}',
      'assignedZoneName_${item.id}',
      'assetTypeId_${item.id}',
      'assetTypeName_${item.id}',
      'assetsCount_${item.id}',
      'excellent_${item.id}',
      'needsAttention_${item.id}',
      'problem_${item.id}',
      'receiptPhoto_${item.id}',
    });
  }

  void _removeValidationFields(
    BuildContext context, {
    required ReceiveAssetsData item,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.removeDynamicFields({
      'assignedZoneId_${item.id}',
      'assignedZoneName_${item.id}',
      'assetTypeId_${item.id}',
      'assetTypeName_${item.id}',
      'assetsCount_${item.id}',
      'excellent_${item.id}',
      'needsAttention_${item.id}',
      'problem_${item.id}',
      'receiptPhoto_${item.id}',
    });
  }

  void _addSelectAssetsKeys(
    BuildContext context, {
    required List<ReceiveAssetsData> items,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    for (var item in items) {
      validationCubit.addDynamicFields({'asset_${item.id}'});

      validationCubit.validateFieldAndStoreTypedValue<bool>(
        fieldName: 'asset_${item.id}',
        value: false,
        isValid: false,
      );

      validationCubit.toggleFieldRequirement(
        'asset_${item.id}',
        isRequired: false,
      );
    }
  }

  ReceiveAssetsRequest _request(BuildContext context) {
    final validationState = context.read<ValidationCubit>();

    final List<ReceiveAssetsDataRequest> items = widget.items
        .map((item) {
          final isSelected = validationState.fieldIsValid('asset_${item.id}');

          if (isSelected) {
            return ReceiveAssetsDataRequest(
              assignedZoneId: validationState.getFieldValue(
                'assignedZoneId_${item.id}',
              ),
              assetId: item.id,
              assetTypeId: validationState.getFieldValue(
                'assetTypeId_${item.id}',
              ),
              assetCount:
                  validationState.getTypedValue<int>(
                    'assetsCount_${item.id}',
                  ) ??
                  0,
              excellentCount:
                  validationState.getTypedValue<int>('excellent_${item.id}') ??
                  0,
              needAttentionCount:
                  validationState.getTypedValue<int>(
                    'needsAttention_${item.id}',
                  ) ??
                  0,
              problemCount:
                  validationState.getTypedValue<int>('problem_${item.id}') ?? 0,
              image: validationState
                  .getTypedValue<MediaFile>('receiptPhoto_${item.id}')!
                  .toFile,
            );
          }

          return null;
        })
        .whereType<ReceiveAssetsDataRequest>()
        .toList();

    return ReceiveAssetsRequest(
      items: items,
      requestId: widget.requestId,
      type: widget.transferTypeStrategy.transferType.value,
    );
  }

  void _receiveAssets(BuildContext context) {
    context.read<FixedAssetsReceiveAssetsCubit>().receiveAssets(
      request: _request(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isNotEmpty) {
      final data = widget.items;

      if (!_selectAssetsKeysAdded) {
        _addSelectAssetsKeys(context, items: data);
        _selectAssetsKeysAdded = true;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.transferTypeStrategy.label(context),
            style: AppStyles.s20W500.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          AppGestureDetectorButton(
            onTap: () => _selectAndUnSelectAllItems(context, items: data),
            child: Row(
              children: [
                Text(
                  context.tr.selectAll,
                  style: AppStyles.s14W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                12.horizontalSpace,
                BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) {
                    return data.every(
                      (item) =>
                          state.fieldsValidity['asset_${item.id}'] ?? false,
                    );
                  },
                  builder: (context, allSelected) {
                    return AppCheckBox(
                      value: allSelected,
                      onChanged: (_) =>
                          _selectAndUnSelectAllItems(context, items: data),
                    );
                  },
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    FixedAssetsReceiveAssetsListItemWidget(item: data[index]),
                    if (index != data.length - 1) 12.verticalSpace,
                  ],
                );
              },
            ),
          ),
          20.verticalSpace,
          BlocConsumer<
            FixedAssetsReceiveAssetsCubit,
            FixedAssetsReceiveAssetsState
          >(
            listener: (context, state) {
              if (state is FixedAssetsReceiveAssetsSuccess) {
                NavigationService.I.popUntil((p1) {
                  return p1.settings.name == AppRouteName.fixedAssetsScreen;
                });

                AppBottomSheet.customPageRoute(
                  context,
                  (context) => FixedAssetsSuccessScreen(
                    title: context.tr.assetConfirmed,
                    message: context.tr.assetConfirmedDesc,
                  ),
                );
              } else if (state is FixedAssetsReceiveAssetsFailure) {
                AppDialog.showErrorDialog(
                  context: context,
                  failure: state.failure,
                );
              }
            },
            builder: (context, state) {
              if (state is FixedAssetsReceiveAssetsLoading) {
                return const AppButtonLoading();
              }

              return BlocSelector<ValidationCubit, ValidationState, bool>(
                selector: (state) => state.enableButton,
                builder: (context, state) {
                  return AppButton(
                    onClick: () => _receiveAssets(context),
                    text: context.tr.confirmReceipt,
                    enabled: state,
                  );
                },
              );
            },
          ),
          20.verticalSpace,
        ],
      );
    }

    if (widget.items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 42.r,
                color: context.customColor.text3,
              ),
              8.verticalSpace,
              Text(
                context.tr.fixedAssetsReceiveAssetsEmptyTitle,
                style: AppStyles.s14W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              6.verticalSpace,
              Text(
                context.tr.fixedAssetsReceiveAssetsEmptyDesc,
                textAlign: TextAlign.center,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const AppLoadingWidget();
  }
}
