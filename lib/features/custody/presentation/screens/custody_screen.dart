import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/get_branch_balance/get_branch_balance_cubit.dart';
import '../cubit/get_personal_balance/get_personal_balance_cubit.dart';
import '../widgets/custody_app_bar.dart';
import '../widgets/custody_branch_custody_balance_view.dart';
import '../widgets/custody_more_options_bottom_sheet_widget.dart';
import '../widgets/custody_personal_custody_balance_view.dart';
import '../widgets/custody_top_section.dart';

class CustodyScreen extends StatelessWidget {
  const CustodyScreen({super.key});

  List<Widget> get _pages => [
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
      ],
      child: const CustodyBranchCustodyBalanceView(),
    ),
    const CustodyPersonalCustodyBalanceView(),
  ];

  void _onClickMoreOptions(BuildContext context) {
    AppBottomSheet.pageRoute(
      context,
      (context) => const CustodyMoreOptionsBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (context.read<PagingCubit>().state.currentIndex == 0) {
            context.read<GetBranchBalanceCubit>().getBranchBalance();
          } else {
            context.read<GetPersonalBalanceCubit>().getPersonalBalance();
          }
        },
        child: CustomScrollView(
          slivers: [
            Container(
              color: context.customColor.text2.withValues(alpha: 0.4),
              child: Row(
                children: [
                  Expanded(
                    child: CustodyAppBar(
                      title: context.tr.custodyManagement,
                      titleColor: context.customColor.text1,
                      subtitle: context.tr.manageRequestsAndViewHistory,
                      iconColor: context.customColor.text1,
                    ),
                  ),
                  10.horizontalSpace,
                  Padding(
                    padding: EdgeInsets.only(right: 20.r),
                    child: AppSvgButton(
                      assetName: AppAssets.more,
                      onTap: () => _onClickMoreOptions(context),
                      padding: EdgeInsets.all(15.r),
                      iconColor: context.customColor.text1,
                    ),
                  ),
                ],
              ),
            ).sliverBoxAdapter,
            DecoratedSliver(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                ),
              ),
              sliver: CustodyTopSection(
                onPageChanged: (value) {
                  context.read<PagingCubit>().goToStep(value);
                },
              ).sliverBoxAdapter,
            ),
            BlocBuilder<PagingCubit, PagingState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _pages[state.currentIndex],
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                );
              },
            ).sliverBoxAdapter,
          ],
        ),
      ),
    );
  }
}
