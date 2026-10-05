import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../widgets/cashier_my_shifts_app_bar.dart';
import 'cashier_ledger_view.dart';
import 'cashier_shifts_view.dart';

class CashierMyShiftsScreen extends StatelessWidget {
  const CashierMyShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLedger = context.watch<PagingCubit>().state.currentIndex == 1;

    return Scaffold(
      backgroundColor: isLedger
          ? context.theme.primaryColor
          : context.customColor.text2,
      body: Column(
        children: [
          const CashierMyShiftsAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: BlocSelector<PagingCubit, PagingState, int>(
                  selector: (state) => state.currentIndex,
                  builder: (context, state) {
                    switch (state) {
                      case 0:
                        return BlocProvider(
                          create: (context) =>
                              getIt<CashierMyShiftsCubit>()..fetchAllShifts(),
                          child: const CashierShiftsView(),
                        );
                      case 1:
                        return const CashierLedgerView();
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
