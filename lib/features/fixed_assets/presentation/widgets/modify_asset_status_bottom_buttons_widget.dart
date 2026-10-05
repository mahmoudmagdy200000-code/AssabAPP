import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/models/media_file_model.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/fixed_assets_modify_request.dart';
import '../../domain/enums/fixed_assets_done_enum.dart';
import '../../domain/enums/fixed_assets_next_enum.dart';
import '../cubit/modify_asset/modify_asset_cubit.dart';
import '../cubit/modify_asset/modify_asset_state.dart';
import '../screens/fixed_assets_success_screen.dart';

class ModifyAssetStatusBottomButtonsWidget extends StatelessWidget {
  final String assetId;

  const ModifyAssetStatusBottomButtonsWidget({
    super.key,
    required this.assetId,
  });

  FixedAssetsModifyRequest request(BuildContext context) {
    final validationState = context.read<ValidationCubit>();

    final doneActions = [
      validationState.getTypedValue<FixedAssetsDoneEnum>('initialCheck')?.value,
      validationState.getTypedValue<FixedAssetsDoneEnum>('cleaning')?.value,
    ].whereType<String>().toList();

    return FixedAssetsModifyRequest(
      assetId: assetId,
      newStatus: validationState.getFieldValue('newStatus'),
      reason: validationState.getFieldValue('reason'),
      attachment: validationState.getTypedValue<MediaFile>('photos')!.toFile,
      doneActions: doneActions,
      nextAction:
          validationState.getTypedValue<FixedAssetsNextEnum>('next')?.value ??
          '',
      approvalRequestOwnerNote: validationState.getFieldValue(
        'approvalRequestOwnerNote',
      ),
    );
  }

  void _modifyAssetStatus(BuildContext context) {
    context.read<ModifyAssetCubit>().modifyAssetStatus(
      request: request(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Expanded(
        //   child: ButtonTextIcon(
        //     onTap: () {
        //       NavigationService.I.pushNamed(
        //         AppRouteName.fixedAssetsModificationDetailsScreen,
        //       );
        //     },
        //     label: context.tr.saveToDraft,
        //     icon: AppSvg(
        //       assetName: AppAssets.draft,
        //       width: 15.r,
        //       colorFilter: ColorFilter.mode(
        //         context.customColor.text1,
        //         BlendMode.srcIn,
        //       ),
        //     ),
        //     borderColor: context.customColor.border,
        //     textColor: context.customColor.text1,
        //     borderRadius: BorderRadius.circular(1000.r),
        //     padding: EdgeInsets.symmetric(vertical: 16.r),
        //   ),
        // ),
        // 16.horizontalSpace,
        Expanded(
          child: BlocListener<ModifyAssetCubit, ModifyAssetState>(
            listener: (context, state) {
              if (state is ModifyAssetSuccess) {
                NavigationService.I.pop();

                AppBottomSheet.customPageRoute(
                  context,
                  (context) => FixedAssetsSuccessScreen(
                    title: context.tr.modificationSubmitted,
                    message: context.tr.modificationSubmittedDesc,
                  ),
                );
              } else if (state is ModifyAssetFailure) {
                AppDialog.showErrorDialog(
                  context: context,
                  failure: state.failure,
                );
              }
            },
            child: BlocBuilder<ModifyAssetCubit, ModifyAssetState>(
              builder: (context, state) {
                if (state is ModifyAssetLoading) {
                  return const AppButtonLoading();
                }

                return BlocSelector<ValidationCubit, ValidationState, bool>(
                  selector: (state) {
                    if (state.fieldsValidity['newStatus'] == true &&
                        state.fieldsValidity['reason'] == true &&
                        state.fieldsValidity['photos'] == true &&
                        (state.fieldsValidity['initialCheck'] == true ||
                            state.fieldsValidity['cleaning'] == true) &&
                        state.fieldsValidity['next'] == true &&
                        state.fieldsValidity['approvalRequestOwnerNote'] ==
                            true) {
                      return true;
                    }

                    return false;
                  },
                  builder: (context, enableButton) {
                    return AppButton(
                      onClick: () => _modifyAssetStatus(context),
                      text: context.tr.send,
                      enabled: enableButton,
                      borderRadius: BorderRadius.circular(1000.r),
                      padding: EdgeInsets.symmetric(vertical: 16.r),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
