import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/fixed_assets/presentation/widgets/modify_asset_status_actions_widget.dart';
import 'package:assab/features/fixed_assets/presentation/widgets/modify_asset_status_asset_details_widget.dart';
import 'package:assab/features/fixed_assets/presentation/widgets/modify_asset_status_bottom_buttons_widget.dart';
import 'package:assab/features/fixed_assets/presentation/widgets/modify_asset_status_new_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/fixed_assets_search_response.dart';
import '../widgets/modify_asset_status_approval_request_owner_widget.dart';

class FixedAssetsModifyAssetStatusScreen extends StatefulWidget {
  final FixedAssetsSearchItem asset;

  const FixedAssetsModifyAssetStatusScreen({super.key, required this.asset});

  @override
  State<FixedAssetsModifyAssetStatusScreen> createState() =>
      _FixedAssetsModifyAssetStatusScreenState();
}

class _FixedAssetsModifyAssetStatusScreenState
    extends State<FixedAssetsModifyAssetStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.dark,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ModifyAssetStatusAssetDetailsWidget(
                            asset: widget.asset,
                          ),
                          12.verticalSpace,
                          BlocProvider(
                            create: (context) => getIt<ChooseItemCubit>(),
                            child: const ModifyAssetStatusNewStatusWidget(),
                          ),
                          12.verticalSpace,
                          BlocProvider(
                            create: (context) => getIt<ChooseItemCubit>(),
                            child: const ModifyAssetStatusActionsWidget(),
                          ),
                          12.verticalSpace,
                          const ModifyAssetStatusApprovalRequestOwnerWidget(),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  ModifyAssetStatusBottomButtonsWidget(
                    assetId: widget.asset.id,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppPaddingWidget(
      top: 30.r,
      child: Row(
        children: [
          const AppBackButton(isTransparent: true),
          10.horizontalSpace,
          Expanded(
            child: Text(
              context.tr.modifyAssetStatus,
              style: AppStyles.s16W600.copyWith(
                color: context.customColor.reversedTextColor,
              ),
            ),
          ), // To balance the back button
        ],
      ),
    );
  }
}
