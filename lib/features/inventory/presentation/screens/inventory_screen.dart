import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_icon_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../data/models/monthly_inventory_local_model.dart';
import '../../domain/strategies/inventory_user_type.dart';
import '../cubit/get_inventory_requests/get_inventory_requests_cubit.dart';
import '../cubit/get_inventory_requests/get_inventory_requests_state.dart';
import '../widgets/inventory_more_actions__bottom_sheet_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  void _onClickCoreTask(int index, BuildContext context) {
    switch (index) {
      case 0:
        NavigationService.I.pushNamed(AppRouteName.dailyInventoryScreen);
        break;
      case 1:
        context.read<GetInventoryRequestsCubit>().getMonthlyInventoryRequests();
        break;
      case 2:
        // Navigate to Smart Monthly Inventory Screen
        break;
      case 3:
        NavigationService.I.pushNamed(AppRouteName.wastedInventoryScreen);
        break;
      case 4:
        // Navigate to Reports and Review Screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GetInventoryRequestsCubit>(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppPaddingWidget(
                top: 30.r,
                child: Row(
                  children: [
                    AppBackButton(
                      isTransparent: true,
                      iconColor: context.customColor.text1,
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.inventoryManagement,
                            style: AppStyles.s18W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          Text(
                            '${DateFormatter.formatDateMDY(DateTime.now())} | ${DateFormatter.formatTimeHM(DateTime.now())}',
                            style: AppStyles.s12W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.horizontalSpace,
                    AppIconButton(
                      icon: Icons.more_vert_rounded,
                      onPressed: () {
                        AppBottomSheet.customPageRoute(
                          context,
                          (context) =>
                              const InventoryMoreActionsBottomSheetWidget(),
                        );
                      },
                      backgroundColor: context.theme.primaryColor,
                      iconColor: context.customColor.reversedTextColor,
                    ),
                  ],
                ),
              ),
              CustomDivider(thickness: 7.h),
              AppPaddingWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.urgentNotifications,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        children: [
                          AppGestureDetectorButton(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.r,
                                vertical: 10.r,
                              ),
                              child: Row(
                                children: [
                                  AppSvg(
                                    assetName: AppAssets.warning,
                                    width: 14.r,
                                  ),
                                  6.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      context.tr.todaysInventoryNotCompletedYet,
                                      style: AppStyles.s12W500.copyWith(
                                        color: context.customColor.text1,
                                      ),
                                    ),
                                  ),
                                  6.horizontalSpace,
                                  AppSvg(
                                    assetName: AppAssets.arrowRight,
                                    width: 14.r,
                                    colorFilter: ColorFilter.mode(
                                      context.customColor.text3,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                          8.verticalSpace,
                          _buildRowTextValue(
                            context: context,
                            title: context.tr.yesterdaysReport,
                            value: context.tr.discrepanciesNeedClarification,
                          ),
                          16.verticalSpace,
                          _buildRowTextValue(
                            context: context,
                            title: context.tr.wasteAndDamageDraftsSaved,
                            value: '2',
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    Text(
                      context.tr.coreTasks,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    Container(
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.all(6.r),
                      child:
                          BlocListener<
                            GetInventoryRequestsCubit,
                            GetInventoryRequestsState
                          >(
                            listener: (context, state) {
                              if (state is GetMonthlyInventoryRequestsSuccess) {
                                if (state.isMonthlyInventoryExistSession) {
                                  NavigationService.I.pushNamed(
                                    AppRouteName.monthlyInventoryStartScreen,
                                    arguments: MonthlyInventoryLocalModel(
                                      sessionId:
                                          state.monthlyInventoryExistSessionId,
                                      userType:
                                          InventoryUserTypeBranchManager(),
                                    ),
                                  );
                                } else {
                                  NavigationService.I.pushNamed(
                                    AppRouteName.monthlyInventoryScreen,
                                  );
                                }
                              } else if (state is GetInventoryRequestsFailure) {
                                AppDialog.showErrorDialog(
                                  context: context,
                                  failure: state.failure,
                                );
                              }
                            },
                            child: ListView.builder(
                              itemCount: 5,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final texts = [
                                  context.tr.dailyInventoryValue,
                                  context.tr.monthlyInventory,
                                  context.tr.smartMonthlyInventory,
                                  context.tr.wasteAndDamageMgmt,
                                  context.tr.reportsAndReview,
                                ];

                                final icons = [
                                  AppAssets.clockSvg,
                                  AppAssets.calendar,
                                  AppAssets.ai,
                                  AppAssets.trashSvg,
                                  AppAssets.viewReports,
                                ];

                                final loading =
                                    context
                                            .watch<GetInventoryRequestsCubit>()
                                            .state
                                        is GetInventoryRequestsLoading;

                                if (loading) {
                                  return Container(
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      color:
                                          context.customColor.reversedTextColor,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.r,
                                      vertical: 8.r,
                                    ),
                                    margin: EdgeInsetsDirectional.only(
                                      end: index == 4 ? 0.r : 8.r,
                                    ),
                                    child: const AppLoadingWidget(),
                                  );
                                }

                                return AppGestureDetectorButton(
                                  onTap: () => _onClickCoreTask(index, context),
                                  child: Container(
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      color:
                                          context.customColor.reversedTextColor,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.r,
                                      vertical: 8.r,
                                    ),
                                    margin: EdgeInsetsDirectional.only(
                                      end: index == 4 ? 0.r : 8.r,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppSvgButton(
                                          assetName: icons[index],
                                          onTap: () {},
                                          iconSize: 14.r,
                                        ),
                                        6.verticalSpace,
                                        Text(
                                          texts[index],
                                          softWrap: true,
                                          style: AppStyles.s11W500.copyWith(
                                            color: context.customColor.text4,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    ),
                    16.verticalSpace,
                    Text(
                      context.tr.quickOverview,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    _buildRowTextValue(
                      context: context,
                      title: context.tr.inventoryStatus,
                      value: context.tr.dailyInventoryValue,
                    ),
                    16.verticalSpace,
                    _buildRowTextValue(
                      context: context,
                      title: context.tr.productsCount(212),
                      value: context.tr.productsCountValue,
                    ),
                    16.verticalSpace,
                    _buildRowTextValue(
                      context: context,
                      title: context.tr.inventoryState,
                      value: context.tr.pendingNotStarted,
                      customWidgetAfterValue: const AppSvg(
                        assetName: AppAssets.warning,
                      ),
                    ),
                    16.verticalSpace,
                    _buildRowTextValue(
                      context: context,
                      title: context.tr.schedule,
                      value: context.tr.scheduleValue,
                    ),
                    16.verticalSpace,
                    Text(
                      context.tr.personalAndWasteOverview,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    _buildRowTextValue(
                      context: context,
                      title: context.tr.yourPersonalBalance,
                      value: context.tr.personalBalanceValue,
                    ),
                    16.verticalSpace,
                    _buildRowTextValue(
                      context: context,
                      title: context.tr.dailyWasteReviewStatus,
                      customValue: ButtonTextIcon(
                        onTap: () {},
                        label: context.tr.needsReview,
                        icon: AppSvg(
                          assetName: AppAssets.arrowRight,
                          colorFilter: ColorFilter.mode(
                            context.theme.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        borderColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 10.r),
                        reversed: true,
                        spaceBetweenTextAndIcon: 7.r,
                      ),
                    ),
                    16.verticalSpace,
                    _buildRowTextValue(
                      context: context,
                      title: context.tr.increaseFromYesterdayValue,
                      value: '78',
                      customWidgetAfterValue: const SaudiRiyalSvgWidget(),
                      reverceCustomWidgetAfterValue: true,
                    ),
                    16.verticalSpace,
                    Text(
                      context.tr.yourPersonalAccount,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    8.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SaudiRiyalSvgWidget(),
                              5.horizontalSpace,
                              Text(
                                '-125',
                                style: AppStyles.s16W600.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: context.customColor.border,
                                  ),
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.r,
                                  vertical: 7.r,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      context.tr.shortage,
                                      style: AppStyles.s10W500.copyWith(
                                        color: AppColors.orange,
                                      ),
                                    ),
                                    6.horizontalSpace,
                                    AppSvg(
                                      assetName: AppAssets.warning,
                                      width: 12.r,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.orange,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          Text(
                            context.tr.chooseFromButtonsToResolveShortage,
                            style: AppStyles.s13W400.copyWith(
                              color: context.customColor.text3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          8.verticalSpace,
                          const CustomDivider(),
                          8.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.accountDetails,
                                  onTap: () {},
                                  borderRadius: 1000.r,
                                  backgroundColor: context.theme.primaryColor,
                                  borderColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 19.r),
                                  textColor:
                                      context.customColor.reversedTextColor,
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.requestReview,
                                  onTap: () {},
                                  borderRadius: 1000.r,
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 19.r),
                                  textColor: context.customColor.text4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowTextValue({
    required BuildContext context,
    required String title,
    String? value,
    Widget? customWidgetAfterValue,
    bool reverceCustomWidgetAfterValue = false,
    Widget? customValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        customValue ??
            Text(
              value ?? '',
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
        if (customWidgetAfterValue != null) ...[
          if (reverceCustomWidgetAfterValue) ...[
            customWidgetAfterValue,
            6.horizontalSpace,
          ] else ...[
            6.horizontalSpace,
            customWidgetAfterValue,
          ],
        ],
      ],
    );
  }
}
