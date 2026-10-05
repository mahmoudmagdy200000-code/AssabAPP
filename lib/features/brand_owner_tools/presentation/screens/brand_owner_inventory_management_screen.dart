import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../cubit/brand_owner_daily_inventory_requests/brand_owner_daily_inventory_requests_cubit.dart';
import '../cubit/brand_owner_wast_and_damage_requests/brand_owner_wast_and_damage_requests_cubit.dart';
import 'brand_owner_inventory_management_daily_view.dart';
import 'brand_owner_inventory_management_wast_and_damage_view.dart';

class BrandOwnerInventoryManagementScreen extends StatelessWidget {
  const BrandOwnerInventoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<BrandOwnerDailyInventoryRequestsCubit>()..load(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<BrandOwnerWastAndDamageRequestsCubit>()..load(),
        ),
      ],
      child: Scaffold(
        backgroundColor: context.customColor.text2,
        body: Column(
          children: [
            AppPaddingWidget(
              top: 30.r,
              child: Row(
                children: [
                  const AppBackButton(),
                  10.horizontalSpace,
                  Flexible(
                    child: Text(
                      context.tr.inventoryManagement,
                      style: AppStyles.s16W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      spacing: 8.w,
                      children: List.generate(2, (index) {
                        final titles = [
                          context.tr.dailyInventory_d,
                          context.tr.wasteAndDamage,
                        ];

                        return Expanded(
                          child: BlocSelector<PagingCubit, PagingState, bool>(
                            selector: (state) {
                              return state.currentIndex == index;
                            },
                            builder: (context, state) {
                              return CustomTextButton(
                                text: titles[index],
                                textColor: state
                                    ? context.theme.primaryColor
                                    : context.customColor.text3,
                                borderColor: state
                                    ? context.theme.primaryColor
                                    : context.customColor.border,
                                borderRadius: 1000.r,
                                onTap: () {
                                  context.read<PagingCubit>().goToStep(index);
                                },
                              );
                            },
                          ),
                        );
                      }),
                    ),
                    10.verticalSpace,
                    Expanded(
                      child: BlocSelector<PagingCubit, PagingState, int>(
                        selector: (state) {
                          return state.currentIndex;
                        },
                        builder: (context, index) {
                          return IndexedStack(
                            index: index,
                            children: const [
                              BrandOwnerInventoryManagementDailyView(),
                              BrandOwnerInventoryManagementWastAndDamageView(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
