import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../cubit/get_monthly_completed_products/get_monthly_completed_products_cubit.dart';
import '../cubit/get_monthly_completed_products/get_monthly_completed_products_state.dart';

class MonthlyInventoryProgress extends StatefulWidget {
  const MonthlyInventoryProgress({super.key});

  @override
  State<MonthlyInventoryProgress> createState() =>
      _MonthlyInventoryProgressState();
}

class _MonthlyInventoryProgressState extends State<MonthlyInventoryProgress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.personalInventory,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
          5.verticalSpace,
          BlocSelector<
            GetMonthlyCompletedProductsCubit,
            GetMonthlyCompletedProductsState,
            GetMonthlyCompletedProductsSuccess?
          >(
            selector: (state) {
              return state is GetMonthlyCompletedProductsSuccess ? state : null;
            },
            builder: (context, state) {
              final data = state?.response;

              final completed = data?.completed ?? 0;
              final total = data?.total ?? 0;

              final progress = total == 0
                  ? 0.0
                  : (completed / total).clamp(0.0, 1.0);

              return Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(1000.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.r, vertical: 5.r),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 20.h,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Center(
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: context.customColor.text3.withValues(
                                    alpha: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(1000.r),
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: progress,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(1000.r),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment((progress * 2) - 1, 0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.r,
                                  vertical: 4.r,
                                ),
                                decoration: BoxDecoration(
                                  color: context.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(1000.r),
                                ),
                                child: AppSvg(
                                  assetName: AppAssets.box,
                                  width: 8.r,
                                  colorFilter: ColorFilter.mode(
                                    context.customColor.reversedTextColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Text(
                      '${data?.completed}',
                      style: AppStyles.s12W500.copyWith(
                        color: context.theme.primaryColor,
                      ),
                    ),
                    Text(
                      '/${data?.total ?? 0}',
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
