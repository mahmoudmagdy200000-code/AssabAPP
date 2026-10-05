import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/data_management/date_management/date_management_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../custody/presentation/cubit/get_personal_balance/get_personal_balance_cubit.dart';
import '../cubit/get_cashier_info/get_cashier_info_cubit.dart';
import '../screens/cashier_account_statement_screen.dart';
import '../screens/cashier_list_screen.dart';
import 'cashier_grid_view_item.dart';

class CashierHomeBottomSection extends StatelessWidget {
  const CashierHomeBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Tools & Records (2)',
                  style: AppStyles.s16W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.r,
              crossAxisSpacing: 10.r,
              childAspectRatio: 1.1,
            ),
            padding: EdgeInsets.zero,
            children: [
              CashierGridViewItem(
                colorHex: 0xfff2fcfc,
                title: context.tr.cashiersList,
                iconAssetName: AppAssets.cashiersList,
                // subtitle: '16',
                onTap: () {
                  final pagingCubit = context.read<PagingCubit>();

                  AppBottomSheet.customPageRoute(
                    context,
                    (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: pagingCubit),
                        BlocProvider(
                          create: (context) =>
                              getIt<GetCashierInfoCubit>()..getCashierInfo(),
                        ),
                      ],
                      child: const CashierListScreen(),
                    ),
                  );
                },
              ),
              CashierGridViewItem(
                colorHex: 0xfffef8f4,
                title: context.tr.accountStatement,
                iconAssetName: AppAssets.accountStatement,
                // subtitle: '16',
                onTap: () {
                  NavigationService.I.push(
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) =>
                                getIt<GetPersonalBalanceCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => getIt<DateManagementCubit>(),
                          ),
                        ],
                        child: const CashierAccountStatementScreen(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
