import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/models/custody_requests_response.dart';
import '../cubit/custody_get_requets/custody_get_requets_cubit.dart';
import 'custody_empty_widget.dart';
import 'recent_branch_custody_requests_section.dart';
import 'see_all_branch_custody_requests.dart';

class BranchCustodyBalanceRequestsView extends StatelessWidget {
  final List<CustodyRequestItem> requests;

  const BranchCustodyBalanceRequestsView({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return CustodyEmptyWidget(
        asset: AppAssets.custodyPng,
        title: context.tr.noRequestsYet,
        desc:
            context.tr.youHaveNotSentAnyCustodyRequestsToStoreOwnerForApprovals,
      );
    }

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.tr.recentBranchCustodyRequests,
                  style: AppStyles.s16W600.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              10.horizontalSpace,
              AppGestureDetectorButton(
                onTap: () {
                  AppBottomSheet.customPageRoute(
                    context,
                    (context) => BlocProvider(
                      create: (context) => getIt<CustodyGetRequetsCubit>(),
                      child: const SeeAllBranchCustodyRequests(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.r,
                    horizontal: 12.r,
                  ),
                  child: Row(
                    children: [
                      Text(
                        context.tr.seeAll,
                        style: AppStyles.s12W400.copyWith(
                          color: context.theme.primaryColor,
                        ),
                      ),
                      6.horizontalSpace,
                      AppSvg(
                        assetName: AppAssets.arrowRight,
                        colorFilter: ColorFilter.mode(
                          context.theme.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).sliverBoxAdapter,
        RecentBranchCustodyRequestsSection(requests: requests),
      ],
    );
  }
}
