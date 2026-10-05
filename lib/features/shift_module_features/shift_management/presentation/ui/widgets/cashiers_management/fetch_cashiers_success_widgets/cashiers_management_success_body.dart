import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/filters/cashier_filter/cashier_status_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_name_and_branch_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../data/model/cashier_model.dart';
import '../../../../logic/cashier/cashier_management_cubit.dart';
import '../../cashier_shifts_management_widgets/cashier_profile_bottom_sheet.dart';

class CashiersManagementSuccessBody extends StatelessWidget {
  const CashiersManagementSuccessBody({
    super.key,
    required this.cashiers,
    required this.onRefresh,
    required this.scrollController,
  });

  final List<CashierEntity> cashiers;
  final Future<void> Function() onRefresh;
  final ScrollController scrollController;

  void _getCashiers(BuildContext context) {
    context.read<CashierManagementCubit>().getCashiers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: cashiers.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return AppGestureDetectorButton(
            child: Container(
              margin: EdgeInsetsDirectional.only(top: 10.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.customColor.border,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  buildProfileImage(index),

                  10.horizontalSpace,

                  CashierNameAndBranch(
                    Name: cashiers[index].name,
                    BranchName: cashiers[index].branch.name,
                    ShiftCount: cashiers[index].shiftsCount,
                  ),

                  const Spacer(),

                  if (cashiers[index].status != CashierStatus.pending)
                    Container(
                      margin: EdgeInsetsDirectional.only(end: 10.w),
                      child: AppSvg(
                        assetName: AppAssets.arrowRight,
                        colorFilter: ColorFilter.mode(
                          context.customColor.text1,
                          BlendMode.srcIn,
                        ),
                        width: 10.w,
                        height: 10.h,
                      ),
                    ),
                ],
              ),
            ),
            onTap: () async {
              if (cashiers[index].status != CashierStatus.pending) {
                await NavigationService.I.pushNamed(
                  AppRouteName.cashierShiftsScreen,

                  arguments: {
                    'param1': cashiers[index].id,
                    'param2': cashiers[index],
                  },
                );

                if (context.mounted) {
                  _getCashiers(context);
                }
              } else {
                await AppBottomSheet.showModal(
                  context,
                  isScrollControlled: true,
                  (context) {
                    return BlocProvider(
                      create: (context) => ValidationCubit(
                        requiredFields: {'email', 'cashierName'},
                      ),
                      child: CashierProfileBottomSheet(
                        createdByName:
                            cashiers[index].createdByName ?? context.tr.no_name,
                        formattedCreatedAt:
                            cashiers[index].formattedCreatedAt ?? '00:00',
                        cashierId: cashiers[index].id,
                      ),
                    );
                  },
                );

                if (context.mounted) {
                  _getCashiers(context);
                }
              }
            },
          );
        },
      ),
    );
  }

  Stack buildProfileImage(int index) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: 60.w,
          height: 65.h,
          child:
              (cashiers[index].image != null &&
                  cashiers[index].image!.isNotEmpty)
              ? Image.network(
                  cashiers[index].image!,
                  errorBuilder: (context, error, stackTrace) {
                    return const AppSvg(assetName: AppAssets.noProfile);
                  },
                )
              : const AppSvg(assetName: AppAssets.noProfile),
        ),

        Container(
          color: cashiers[index].status.cardColor,

          alignment: Alignment.center,
          padding: EdgeInsets.all(3.w),
          child: Text(
            cashiers[index].status.label,
            style: AppStyles.s12W500.copyWith(
              color: cashiers[index].status.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
