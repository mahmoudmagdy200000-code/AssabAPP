import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/cubit/get_returns/get_returns_cubit.dart';
import '../../presentation/widgets/returns_management_empty_widget.dart';

abstract class ReturnsManagementStrategy {
  Widget buildTopSection(BuildContext context) {
    return const SizedBox.shrink();
  }

  void get(BuildContext context);

  Widget buildEmptyWidget(BuildContext context);
}

class InProgressReturnsManagementStrategy extends ReturnsManagementStrategy {
  @override
  Widget buildTopSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Text(
            context.tr.needToReturnAnOrderItem,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          Text(
            context
                .tr
                .clickTheButtonBelowToOpenYourPurchaseHistorySelectACompletedOrderThenTapReturnItemToStartTheReturnProcess,
            textAlign: TextAlign.center,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          ButtonTextIcon(
            onTap: () {
              NavigationService.I.popToFirst();

              NavigationService.I.pushNamed(AppRouteName.purchaseHistoryScreen);
            },
            label: context.tr.purchaseHistory,
            reversed: true,
            textStyle: AppStyles.s12W500.copyWith(
              color: context.customColor.text1,
            ),
            spaceBetweenTextAndIcon: 7.r,
            borderRadius: BorderRadius.circular(1000.r),
            padding: EdgeInsets.symmetric(vertical: 11.r),
            icon: AppSvg(
              assetName: AppAssets.arrowRight,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void get(BuildContext context) {
    context.read<GetReturnsCubit>().getInprogressReturns();
  }

  @override
  Widget buildEmptyWidget(BuildContext context) {
    return ReturnsManagementEmptyWidget(
      image: AppAssets.pendingPng,
      title: context.tr.noReturnsInProgressYet,
      description: context
          .tr
          .onceYouStartReturningAnItemItllAppearHereForTrackingAndFollowUp,
    );
  }
}

class CompletedReturnsManagementStrategy extends ReturnsManagementStrategy {
  @override
  void get(BuildContext context) {
    context.read<GetReturnsCubit>().getCompletedReturns();
  }

  @override
  Widget buildEmptyWidget(BuildContext context) {
    return ReturnsManagementEmptyWidget(
      image: AppAssets.returnManagementPng,
      title: context.tr.noCompletedReturnsYet,
      description: context
          .tr
          .returnedItemsThatAreFullyProcessedAndClosedWillBeListedHere,
    );
  }
}
