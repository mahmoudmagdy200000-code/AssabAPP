import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/get_cashier_info/get_cashier_info_cubit.dart';
import '../cubit/get_cashier_info/get_cashier_info_state.dart';

class CashierListScreen extends StatelessWidget {
  const CashierListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              spacing: 12.w,
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
                        context.tr.cashierListTitle,
                        style: AppStyles.s16W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        context.tr.seeWorkdaysAndStages,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonTextIcon(
                  onTap: () {
                    NavigationService.I.pop();

                    context.read<PagingCubit>().goToStep(1);
                  },
                  label: context.tr.myShifts,
                  icon: AppSvg(
                    assetName: AppAssets.arrowRight,
                    colorFilter: ColorFilter.mode(
                      context.theme.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(1000.r),
                  backgroundColor: Colors.transparent,
                  reversed: true,
                  spaceBetweenTextAndIcon: 7.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 16.r,
                  ),
                ),
              ],
            ),
          ),
          CustomDivider(thickness: 10.h),
          Container(
            decoration: BoxDecoration(
              color: context.customColor.text2,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(16.r),
            margin: EdgeInsets.all(12.r),
            child: Column(
              children: [
                Text(
                  context.tr.cashierListDescription,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text4,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.customColor.reversedTextColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(20.r),
                  child: BlocBuilder<GetCashierInfoCubit, GetCashierInfoState>(
                    builder: (context, state) {
                      if (state is GetCashierInfoLoading) {
                        return const AppLoadingWidget();
                      } else if (state is GetCashierInfoFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          onRetry: () {
                            context
                                .read<GetCashierInfoCubit>()
                                .getCashierInfo();
                          },
                          withBorder: false,
                        );
                      } else if (state is GetCashierInfoSuccess) {
                        final cashierInfo = state.response;

                        return Column(
                          children: [
                            ProfileImageWidget(
                              image: cashierInfo.image,
                              width: 100.h,
                              height: 100.h,
                            ),
                            10.verticalSpace,
                            Text(
                              cashierInfo.name,
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildCashierRow(
                              context: context,
                              text: cashierInfo.statusLabel,
                              customValue: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: context.customColor.text2,
                                      borderRadius: BorderRadius.circular(
                                        1000.r,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.r,
                                      vertical: 6.r,
                                    ),
                                    child: Text(
                                      cashierInfo.activity,
                                      style: AppStyles.s10W500.copyWith(
                                        color: context.customColor.text4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildCashierRow(
                              context: context,
                              text: context.tr.roleLabel,
                              value: cashierInfo.role,
                            ),
                            10.verticalSpace,
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.all(12.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.tr.shiftDetails,
                                    style: AppStyles.s14W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  _buildCashierRow(
                                    context: context,
                                    text: context.tr.storeBranchLabel,
                                    value:
                                        cashierInfo.shiftDetails?.storeBranch ??
                                        '-',
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  _buildCashierRow(
                                    context: context,
                                    text: context.tr.workdaysLabel,
                                    value:
                                        cashierInfo.shiftDetails?.workdays ??
                                        '-',
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  _buildCashierRow(
                                    context: context,
                                    text: context.tr.shiftLabel,
                                    value:
                                        '${cashierInfo.shiftDetails?.shiftName ?? '-'} ${DateFormatter.formatTimeHM(DateTime.tryParse(cashierInfo.shiftDetails?.startTime ?? '')) ?? '-'} - ${DateFormatter.formatTimeHM(DateTime.tryParse(cashierInfo.shiftDetails?.endTime ?? '')) ?? '-'}',
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  _buildCashierRow(
                                    context: context,
                                    text: context.tr.handsOverToLabel,
                                    value:
                                        cashierInfo
                                            .shiftDetails
                                            ?.handsOverTo
                                            .role ??
                                        '-',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return AppLocalFailure(
                        onRetry: () {
                          context.read<GetCashierInfoCubit>().getCashierInfo();
                        },
                        withBorder: false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashierRow({
    required BuildContext context,
    required String text,
    String? value,
    Widget? customValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            text,
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.verticalSpace,
        Flexible(
          child:
              customValue ??
              Text(
                value ?? '',
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text1,
                ),
              ),
        ),
      ],
    );
  }
}
