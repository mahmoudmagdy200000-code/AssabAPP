import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../core/routing/app_route_name.dart';
import '../../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../../core/widgets/app_svg.dart';
import '../../../../logic/cashier/cashier_management_cubit.dart';

class EmptyCashiersWithoutFilterWidget extends StatelessWidget {
  const EmptyCashiersWithoutFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        40.verticalSpace,

        AppSvg(assetName: AppAssets.noCashiers, height: 80.h),

        20.verticalSpace,

        Text(context.tr.no_cashiers, style: context.theme.textTheme.bodyMedium),

        15.verticalSpace,

        SizedBox(
          width: 260.w,
          child: Text(
            context.tr.no_cashiers_desc,
            style: context.theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),

        70.verticalSpace,
        AppButton(
          width: 130.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          borderRadius: BorderRadius.circular(12.r),
          onClick: () {
            Navigator.pushNamed(
              context,
              AppRouteName.addCashierScreen,
              arguments: context.read<CashierManagementCubit>(),
            );
          },
          enabled: true,
          text: context.tr.addCashier,
        ),
      ],
    );
  }
}
