import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../custody/presentation/cubit/create_handover_to_cashier/create_handover_to_cashier_cubit.dart';
import '../../../custody/presentation/screens/custody_handover_to_cashier_screen.dart';

class CashierAccountStatementMoreOptionsBottomSheetWidget
    extends StatelessWidget {
  const CashierAccountStatementMoreOptionsBottomSheetWidget({super.key});

  void _onTapOption(BuildContext context, Widget screen) {
    NavigationService.I.pop();
    AppBottomSheet.customPageRoute(context, (context) => screen);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 10.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildText(context, context.tr.quickActions),
          14.verticalSpace,
          _buildOptionItem(
            context: context,
            assetName: AppAssets.returnsManagement,
            text: context.tr.handoverToCashier,
            desc: context.tr.transferFundsToACashierToBeRecordedAsAn,
            onTap: () {
              _onTapOption(
                context,
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ValidationCubit(
                        requiredFields: {
                          'handoverRecipientId',
                          'handoverRecipientName',
                          'recipientType',
                          'handoverAmount',
                          'handoverDate',
                          'preferredReceiptMethod',
                        },
                        optionalFields: {'additionalNote'},
                      ),
                    ),
                    BlocProvider(
                      create: (context) =>
                          getIt<CreateHandoverToCashierCubit>(),
                    ),
                    BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
                    // BlocProvider(
                    //   create: (context) =>
                    //       getIt<CustodyGetPersonalBalanceOnlyCubit>(),
                    // ),
                  ],
                  child: const CustodyHandoverToCashierScreen(),
                ),
              );
            },
          ),
          12.verticalSpace,
          _buildOptionItem(
            context: context,
            assetName: AppAssets.upload,
            text: context.tr.downloadStatement,
            desc: context
                .tr
                .exportYourAccountStatementInYourPreferredFileFormatAndTimeframe,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildText(BuildContext context, String text) {
    return Text(
      text,
      style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
    );
  }

  Widget _buildOptionItem({
    required BuildContext context,
    required String assetName,
    required String text,
    required String desc,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 16.r),
        child: Row(
          children: [
            AppSvg(
              assetName: assetName,
              width: 20.w,
              height: 20.w,
              colorFilter: ColorFilter.mode(
                context.theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    desc,
                    style: AppStyles.s12W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ],
              ),
            ),
            16.horizontalSpace,
            AppSvg(
              assetName: AppAssets.arrowRight,
              width: 20.w,
              colorFilter: ColorFilter.mode(
                context.customColor.text1,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
