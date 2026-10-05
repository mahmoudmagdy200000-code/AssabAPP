import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/features/inventory/presentation/cubit/get_inventory_employee/get_inventory_employee_cubit.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../data/models/monthly_inventory_local_model.dart';
import '../../data/models/start_monthly_inventory_request.dart';
import '../../domain/strategies/inventory_user_type.dart';
import '../cubit/start_monthly_inventory/start_monthly_inventory_cubit.dart';
import '../cubit/start_monthly_inventory/start_monthly_inventory_state.dart';
import '../widgets/monthly_inventory_inventory_info_section.dart';
import 'monthly_availble_staff_list_bottom_sheet_widget.dart';

class MonthlyInventoryScreen extends StatelessWidget {
  const MonthlyInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.monthlyRegularInventorySetup,
            subtitle: context.tr.simplifiedMonthlyInventorySetup,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const MonthlyInventoryInventoryInfoSection(),
                          12.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppSvg(
                                      assetName: AppAssets.cashiersList,
                                      width: 20.r,
                                      colorFilter: ColorFilter.mode(
                                        context.customColor.text3,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    8.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            context.tr.inventoryTeam,
                                            style: AppStyles.s14W600.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          Text(
                                            context
                                                .tr
                                                .addStaffForThisMonthsInventoryCount,
                                            style: AppStyles.s13W400.copyWith(
                                              color: context.customColor.text3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                8.verticalSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  padding: EdgeInsets.all(16.r),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const AppSvg(
                                            assetName: AppAssets.crownSvg,
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              context.tr.teamLeader,
                                              style: AppStyles.s14W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      8.verticalSpace,
                                      const CustomDivider(),
                                      8.verticalSpace,
                                      Row(
                                        children: [
                                          ProfileImageWidget(
                                            width: 35.h,
                                            height: 35.h,
                                          ),
                                          10.horizontalSpace,
                                          Text(
                                            '${getIt<SharedPreferencesHelper>().getString('u_name')} ${context.tr.you}',
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                8.verticalSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  padding: EdgeInsets.all(16.r),
                                  child: Column(
                                    children: [
                                      AppGestureDetectorButton(
                                        onTap: () {
                                          final choosItemCubit = context
                                              .read<ChooseItemCubit>();
                                          final validationCubit = context
                                              .read<ValidationCubit>();

                                          AppBottomSheet.customPageRoute(
                                            context,
                                            (context) => MultiBlocProvider(
                                              providers: [
                                                BlocProvider(
                                                  create: (context) =>
                                                      getIt<
                                                        GetInventoryEmployeeCubit
                                                      >(),
                                                ),
                                                BlocProvider.value(
                                                  value: choosItemCubit,
                                                ),
                                                BlocProvider.value(
                                                  value: validationCubit,
                                                ),
                                              ],
                                              child:
                                                  const MonthlyAvailbleStaffListBottomSheetWidget(),
                                            ),
                                          );
                                        },
                                        child: ContainerCustomTextField(
                                          label: context.tr.firstStaff,
                                          isLabelOptional: true,
                                          isLabelRequired: false,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    BlocSelector<
                                                      ValidationCubit,
                                                      ValidationState,
                                                      String?
                                                    >(
                                                      selector: (state) => state
                                                          .fieldsValue['staffName'],
                                                      builder: (context, state) {
                                                        return Text(
                                                          state ??
                                                              context.tr.choose,
                                                          style: AppStyles
                                                              .s12W400
                                                              .copyWith(
                                                                color:
                                                                    state ==
                                                                        null
                                                                    ? context
                                                                          .customColor
                                                                          .text3
                                                                    : context
                                                                          .customColor
                                                                          .text1,
                                                                fontWeight:
                                                                    state ==
                                                                        null
                                                                    ? FontWeight
                                                                          .w400
                                                                    : FontWeight
                                                                          .w500,
                                                              ),
                                                        );
                                                      },
                                                    ),
                                              ),
                                              5.verticalSpace,
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 18.r,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 8.verticalSpace,
                                // Container(
                                //   width: double.infinity,
                                //   decoration: BoxDecoration(
                                //     color:
                                //         context.customColor.reversedTextColor,
                                //     borderRadius: BorderRadius.circular(12.r),
                                //   ),
                                //   padding: EdgeInsets.all(16.r),
                                //   child: Column(
                                //     children: [
                                //       Text(
                                //         context
                                //             .tr
                                //             .smartSuggestionLastInventoryTeam,
                                //         style: AppStyles.s14W600.copyWith(
                                //           color: context.customColor.text1,
                                //         ),
                                //         textAlign: TextAlign.center,
                                //       ),
                                //       8.verticalSpace,
                                //       const CustomDivider(),
                                //       8.verticalSpace,
                                //       Row(
                                //         children: [
                                //           ProfileImageWidget(
                                //             width: 32.r,
                                //             height: 32.r,
                                //           ),
                                //           10.horizontalSpace,
                                //           Text(
                                //             context.tr.staffName,
                                //             style: AppStyles.s14W500.copyWith(
                                //               color: context.customColor.text1,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       10.verticalSpace,
                                //       CustomTextButton(
                                //         text: context.tr.useSameTeam,
                                //         onTap: () {},
                                //         backgroundColor:
                                //             context.customColor.dark,
                                //         textColor: context
                                //             .customColor
                                //             .reversedTextColor,
                                //         borderRadius: 1000.r,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  BlocConsumer<
                    StartMonthlyInventoryCubit,
                    StartMonthlyInventoryState
                  >(
                    listener: (context, state) {
                      if (state is StartMonthlyInventorySuccess) {
                        NavigationService.I.replaceWithNamed(
                          AppRouteName.monthlyInventoryStartScreen,
                          arguments: MonthlyInventoryLocalModel(
                            sessionId: state.response.sessionId,
                            userType: InventoryUserTypeBranchManager(),
                          ),
                        );
                      } else if (state is StartMonthlyInventoryFailure) {
                        AppDialog.showErrorDialog(
                          context: context,
                          failure: state.failure,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is StartMonthlyInventoryLoading) {
                        return const AppLoadingWidget();
                      }

                      return CustomTextButton(
                        text: context.tr.startInventory,
                        onTap: () {
                          context
                              .read<StartMonthlyInventoryCubit>()
                              .startMonthlyInventory(
                                request: StartMonthlyInventoryRequest(
                                  inventoryDate: DateTime.now()
                                      .toIso8601String(),
                                  staff: [
                                    context
                                        .read<ValidationCubit>()
                                        .state
                                        .fieldsValue['staffId'],
                                  ],
                                ),
                              );
                        },
                        backgroundColor: context.theme.primaryColor,
                        textColor: context.customColor.reversedTextColor,
                        padding: EdgeInsets.symmetric(vertical: 18.r),
                        borderRadius: 20.r,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
