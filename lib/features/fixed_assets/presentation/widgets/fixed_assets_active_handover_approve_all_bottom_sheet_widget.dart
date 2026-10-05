import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../data/models/fixed_assets_active_handover_session_details_response.dart';
import '../cubit/fixd_assets_active_handover_approval/fixd_assets_active_handover_approval_cubit.dart';
import '../cubit/fixd_assets_active_handover_approval/fixd_assets_active_handover_approval_state.dart';

class FixedAssetsActiveHandoverApproveAllBottomSheetWidget
    extends StatelessWidget {
  final String sessionId;
  final List<FixedAssetsActiveHandoverZone> zones;

  const FixedAssetsActiveHandoverApproveAllBottomSheetWidget({
    super.key,
    required this.sessionId,
    required this.zones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Approve Zone?',
              style: AppStyles.s16W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            Text(
              'Make sure all zones and assets have been reviewed.\nApproval locks all entries and ends edits.\n\nProceed with final approval?',
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            10.verticalSpace,
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: zones.length,
                itemBuilder: (context, index) {
                  final zone = zones[index];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: context.customColor.border),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.r,
                      vertical: 8.r,
                    ),
                    margin: EdgeInsets.only(bottom: 5.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            zone.zoneName,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  '${zone.assets.length} ${context.tr.assets}',
                                  style: AppStyles.s14W500.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                              ),
                              5.horizontalSpace,
                              AppSvg(
                                assetName: AppAssets.check,
                                colorFilter: ColorFilter.mode(
                                  context.theme.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            20.verticalSpace,
            BlocBuilder<
              FixdAssetsActiveHandoverApprovalCubit,
              FixdAssetsActiveHandoverApprovalState
            >(
              builder: (context, approvalState) {
                if (approvalState
                    is FixdAssetsActiveHandoverApprovalAllLoading) {
                  return const AppButtonLoading();
                }

                return ButtonTextIcon(
                  onTap: () {
                    NavigationService.I.pop();

                    context
                        .read<FixdAssetsActiveHandoverApprovalCubit>()
                        .approveAll(sessionId: sessionId);
                  },
                  label: context.tr.approveAll,
                  icon: const AppSvg(assetName: AppAssets.check),
                  textColor: context.customColor.reversedTextColor,
                  backgroundColor: context.theme.primaryColor,
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(15.r),
                  padding: EdgeInsets.symmetric(vertical: 14.r),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
