import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../inventory/data/models/daily_inventory_local_model.dart';
import '../../../inventory/data/models/monthly_inventory_local_model.dart';
import '../../../inventory/domain/strategies/inventory_user_type.dart';
import '../../../inventory/presentation/cubit/create_inventory/create_inventory_cubit.dart';
import '../../../inventory/presentation/screens/wasted_mandatory_awareness_screen.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/cashier_tasks_response.dart';
import '../cubit/get_tasks/get_tasks_cubit.dart';
import '../cubit/get_tasks/get_tasks_state.dart';

class CashierNewAssignmentsScreen extends StatelessWidget {
  const CashierNewAssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              spacing: 16.w,
              children: [
                AppBackButton(
                  isTransparent: true,
                  iconColor: context.customColor.text1,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.newAssignments,
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
                // AppSvgButton(
                //   assetName: AppAssets.viewReports,
                //   onTap: () {},
                //   iconColor: context.theme.primaryColor,
                //   borderColor: context.theme.primaryColor,
                // ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: context.customColor.text2,
              padding: EdgeInsets.all(20.r),
              child: CustomScrollView(
                slivers: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      context.tr.assignedTasks,
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ).sliverBoxAdapter,
                  8.verticalSpace.sliverBoxAdapter,
                  BlocBuilder<GetTasksCubit, GetTasksState>(
                    builder: (context, state) {
                      final dailyList = <CashierTasksResponseDailyQuick>[];
                      final monthlyList = <CashierTasksResponseMonthly>[];
                      final wasteAndDamageList =
                          <CashierTasksResponseWasteDamage>[];

                      if (state is GetTasksLoading) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: AppLoadingWidget(),
                        );
                      } else if (state is GetTasksFailure) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: AppFailureWidget(
                            failure: state.failure,
                            onRetry: () =>
                                context.read<GetTasksCubit>().getTasks(),
                            withBorder: false,
                          ),
                        ).sliverBoxAdapter;
                      } else if (state is GetTasksSuccess) {
                        dailyList.addAll(state.response.dailyQuick);
                        monthlyList.addAll(state.response.monthly);
                        wasteAndDamageList.addAll(state.response.wasteDamage);
                      }

                      if (dailyList.isEmpty &&
                          monthlyList.isEmpty &&
                          wasteAndDamageList.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              context.tr.noTasksFound,
                              style: AppStyles.s16W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList.builder(
                        itemCount:
                            dailyList.length +
                            monthlyList.length +
                            wasteAndDamageList.length,
                        itemBuilder: (context, index) {
                          if (index < dailyList.length) {
                            return _buildDailyInventiryCart(
                              context,
                              dailyList[index],
                            );
                          } else if (index <
                              dailyList.length + monthlyList.length) {
                            return _buildMonthlyInventiryCart(
                              context,
                              monthlyList[index - dailyList.length],
                            );
                          } else {
                            return _buildWastedAndDamageCart(
                              context,
                              wasteAndDamageList[index -
                                  dailyList.length -
                                  monthlyList.length],
                            );
                          }
                        },
                      );
                    },
                  ),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Text(
                  //     context.tr.yourPersonalStatistics,
                  //     style: AppStyles.s16W600.copyWith(
                  //       color: context.customColor.text1,
                  //     ),
                  //   ),
                  // ).sliverBoxAdapter,
                  // 8.verticalSpace.sliverBoxAdapter,
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: context.customColor.reversedTextColor,
                  //     borderRadius: BorderRadius.circular(15.r),
                  //     border: Border.all(color: context.customColor.border),
                  //   ),
                  //   padding: EdgeInsets.all(16.r),
                  //   child: Column(
                  //     spacing: 10.h,
                  //     children: [
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(15.r),
                  //           border: Border.all(
                  //             color: context.customColor.border,
                  //           ),
                  //         ),
                  //         padding: EdgeInsets.all(16.r),
                  //         child: Text(
                  //           context.tr.thisMonthsAchievements('Month Name'),
                  //           style: AppStyles.s14W500.copyWith(
                  //             color: context.theme.primaryColor,
                  //           ),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ),
                  //       _buildRowPersonalStatistics(
                  //         context: context,
                  //         title: context.tr.dailyInventoryCompleted,
                  //         value: Flexible(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.end,
                  //             children: [
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.end,
                  //                 children: [
                  //                   Flexible(
                  //                     child: Text(
                  //                       '19',
                  //                       style: AppStyles.s13W500.copyWith(
                  //                         color: context.customColor.text1,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Flexible(
                  //                     child: Text(
                  //                       '/20 ${context.tr.days}',
                  //                       style: AppStyles.s13W500.copyWith(
                  //                         color: context.customColor.text3,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               10.horizontalSpace,
                  //               Text(
                  //                 '(95%)',
                  //                 style: AppStyles.s13W500.copyWith(
                  //                   color: AppColors.lightGreen,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       _buildRowPersonalStatistics(
                  //         context: context,
                  //         title: context.tr.averageInventoryTime,
                  //         value: Text(
                  //           '19.5 Minutes',
                  //           style: AppStyles.s13W500.copyWith(
                  //             color: context.customColor.text1,
                  //           ),
                  //         ),
                  //       ),
                  //       _buildRowPersonalStatistics(
                  //         context: context,
                  //         title: context.tr.accuracyRate,
                  //         value: Flexible(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.end,
                  //             children: [
                  //               Flexible(
                  //                 child: Text(
                  //                   '19',
                  //                   style: AppStyles.s13W500.copyWith(
                  //                     color: context.customColor.text1,
                  //                   ),
                  //                 ),
                  //               ),
                  //               10.horizontalSpace,
                  //               AppSvg(assetName: AppAssets.star, width: 16.r),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       _buildRowPersonalStatistics(
                  //         context: context,
                  //         title: context.tr.wasteRecorded,
                  //         value: Text(
                  //           '8 Cases',
                  //           style: AppStyles.s13W500.copyWith(
                  //             color: context.customColor.text1,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ).sliverBoxAdapter,
                  // 10.verticalSpace.sliverBoxAdapter,
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: context.customColor.reversedTextColor,
                  //     borderRadius: BorderRadius.circular(15.r),
                  //     border: Border.all(color: context.customColor.border),
                  //   ),
                  //   padding: EdgeInsets.all(16.r),
                  //   child: Column(
                  //     spacing: 10.h,
                  //     children: [
                  //       Text(
                  //         context.tr.performanceRating,
                  //         style: AppStyles.s12W500.copyWith(
                  //           color: context.customColor.text3,
                  //         ),
                  //       ),
                  //       Text(
                  //         '95/100',
                  //         style: AppStyles.s20W600.copyWith(
                  //           color: context.customColor.text1,
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: List.generate(
                  //           5,
                  //           (index) => Padding(
                  //             padding: EdgeInsetsDirectional.only(
                  //               end: index != 4 ? 8.w : 0,
                  //             ),
                  //             child: AppSvg(
                  //               assetName: AppAssets.star,
                  //               width: 16.r,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ).sliverBoxAdapter,
                ],
              ),
            ),
          ),
          AppPaddingWidget(
            child: ButtonTextIcon(
              onTap: () {},
              label: context.tr.contactManager,
              icon: AppSvg(
                assetName: AppAssets.call2,
                colorFilter: ColorFilter.mode(
                  context.customColor.text4,
                  BlendMode.srcIn,
                ),
              ),
              textStyle: AppStyles.s14W500.copyWith(
                color: context.customColor.text4,
              ),
              backgroundColor: context.customColor.text2,
              spaceBetweenTextAndIcon: 7.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowWidgetListView({
    required BuildContext context,
    required String icon,
    required String title,
    required String value,
  }) {
    return Row(
      spacing: 8.w,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            spacing: 8.w,
            children: [
              AppSvg(
                assetName: icon,
                width: 14.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyInventiryCart(
    BuildContext context,
    CashierTasksResponseDailyQuick model,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            spacing: 12.w,
            children: [
              AppSvg(
                assetName: AppAssets.timer,
                width: 18.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              Expanded(
                child: Text(
                  context.tr.dailyInventory_d,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              // TODO: Add Status Widget Here Based On API
            ],
          ),
          // _buildRowWidgetListView(
          //   context: context,
          //   icon: AppAssets.personSvg,
          //   title: context.tr.assigned_by,
          //   value: 'Ahmed Mohammed (Branch Manager)',
          // ),
          _buildRowWidgetListView(
            context: context,
            icon: AppAssets.calendar,
            title: context.tr.inventoryDate,
            value:
                DateFormatter.formatDateMDY(
                  DateTime.tryParse(model.inventoryDate ?? ''),
                ) ??
                '-',
          ),
          _buildRowWidgetListView(
            context: context,
            icon: AppAssets.clockSvg,
            title: context.tr.startTime,
            value:
                DateFormatter.formatTimeHM(
                  DateTime.tryParse(model.startTime ?? ''),
                ) ??
                '-',
          ),
          // _buildRowWidgetListView(
          //   context: context,
          //   icon: AppAssets.box,
          //   title: context.tr.products,
          //   value: context.tr.countSpecifiedProducts(5),
          // ),
          Row(
            children: [
              Expanded(
                child: CustomTextButton(
                  text: context.tr.startInventoryNow,
                  onTap: () {
                    NavigationService.I.pushNamed(
                      AppRouteName.dailyPersonalInventory,
                      arguments: DailyInventoryLocalModel(
                        items: model.items,
                        userType: InventoryUserTypeEmployee(),
                      ),
                    );
                  },
                  backgroundColor: context.theme.primaryColor,
                  borderRadius: 1000.r,
                  padding: EdgeInsets.symmetric(vertical: 15.r),
                  textColor: context.customColor.reversedTextColor,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: ButtonTextIcon(
                  label: context.tr.viewReports,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.customColor.text1,
                    size: 16.r,
                  ),
                  onTap: () {
                    AppBottomSheet.show(context, (context) {
                      return AppPaddingWidget(
                        top: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.dailyQuickInventory,
                              style: AppStyles.s20W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              context.tr.selectedProductsForTodaysInventory(5),
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                            10.verticalSpace,
                            Row(
                              children: [
                                Container(
                                  width: 5.w,
                                  height: 46.h,
                                  color: context.theme.primaryColor,
                                ),
                                10.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${context.tr.note}💡',
                                        style: AppStyles.s14W600.copyWith(
                                          color: context.customColor.text1,
                                        ),
                                      ),
                                      5.verticalSpace,
                                      Text(
                                        context
                                            .tr
                                            .productsPreSelectedByManagement,
                                        style: AppStyles.s14W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            14.verticalSpace,
                            const CustomDivider(),
                            14.verticalSpace,
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: model.items.length,
                                itemBuilder: (context, index) {
                                  final item = model.items[index];

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          PurchaseItemImage(
                                            image: item.itemLogo,
                                          ),
                                          12.horizontalSpace,
                                          Text(
                                            item.itemName,
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (index < model.items.length - 1)
                                        6.verticalSpace,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(1000.r),
                  padding: EdgeInsets.symmetric(vertical: 15.r),
                  textColor: context.customColor.text1,
                  spaceBetweenTextAndIcon: 7.w,
                  reversed: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyInventiryCart(
    BuildContext context,
    CashierTasksResponseMonthly model,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            spacing: 12.w,
            children: [
              AppSvg(
                assetName: AppAssets.timer,
                width: 18.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              Expanded(
                child: Text(
                  context.tr.monthlyInventory,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              // TODO: Add Status Widget Here Based On API
            ],
          ),
          _buildRowWidgetListView(
            context: context,
            icon: AppAssets.calendar,
            title: context.tr.inventoryNumber,
            value: model.inventoryNumber,
          ),
          _buildRowWidgetListView(
            context: context,
            icon: AppAssets.calendar,
            title: context.tr.inventoryDate,
            value:
                DateFormatter.formatDateMDY(
                  DateTime.tryParse(model.inventoryDate),
                ) ??
                '-',
          ),
          // _buildRowWidgetListView(
          //   context: context,
          //   icon: AppAssets.box,
          //   title: context.tr.products,
          //   value: context.tr.countSpecifiedProducts(5),
          // ),
          CustomTextButton(
            text: context.tr.startInventoryNow,
            onTap: () {
              NavigationService.I.pushNamed(
                AppRouteName.monthlyInventoryStartScreen,
                arguments: MonthlyInventoryLocalModel(
                  sessionId: model.id,
                  userType: InventoryUserTypeEmployee(),
                ),
              );
            },
            backgroundColor: context.theme.primaryColor,
            borderRadius: 1000.r,
            padding: EdgeInsets.symmetric(vertical: 15.r),
            textColor: context.customColor.reversedTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildWastedAndDamageCart(
    BuildContext context,
    CashierTasksResponseWasteDamage model,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(bottom: 10.r),
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            spacing: 12.w,
            children: [
              AppSvg(
                assetName: AppAssets.trashSvg,
                width: 18.r,
                colorFilter: ColorFilter.mode(
                  context.customColor.text3,
                  BlendMode.srcIn,
                ),
              ),
              Expanded(
                child: Text(
                  context.tr.wasteDamageRegistration,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
              // TODO: Add Status Widget Here Based On API
            ],
          ),
          // _buildRowWidgetListView(
          //   context: context,
          //   icon: AppAssets.personSvg,
          //   title: context.tr.assigned_by,
          //   value: 'Ahmed Mohammed (Branch Manager)',
          // ),
          _buildRowWidgetListView(
            context: context,
            icon: AppAssets.clockSvg,
            title: context.tr.timing,
            value: context.tr.asNeeded,
          ),
          // _buildRowWidgetListView(
          //   context: context,
          //   icon: AppAssets.box,
          //   title: context.tr.products,
          //   value: context.tr.countSpecifiedProducts(5),
          // ),
          CustomTextButton(
            text: context.tr.startNow,
            onTap: () {
              NavigationService.I.push(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            ValidationCubit(requiredFields: {}),
                      ),
                      BlocProvider(
                        create: (context) => getIt<CreateInventoryCubit>(),
                      ),
                    ],
                    child: WastedMandatoryAwarenessScreen(
                      userType: InventoryUserTypeEmployee(),
                    ),
                  ),
                ),
              );
            },
            backgroundColor: context.theme.primaryColor,
            borderRadius: 1000.r,
            padding: EdgeInsets.symmetric(vertical: 15.r),
            textColor: context.customColor.reversedTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRowPersonalStatistics({
    required BuildContext context,
    required String title,
    required Widget value,
  }) {
    return Row(
      spacing: 8.w,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        value,
      ],
    );
  }
}
