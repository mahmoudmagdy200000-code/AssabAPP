import 'package:assab/features/cashier_my_shifts/domain/entities/cashier_my_shift_entity.dart';
import 'package:assab/features/cashier_my_shifts/domain/enums/my_shifts_status.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../cashier_home/presentation/widgets/cashier_empty_widget.dart';
import '../strategies/cashier_my_shifts_cards_strategy/cashier_my_shifts_card_strategy_resolver.dart';

// class CashierMyShiftsListView extends StatelessWidget {
//   final List<CashierShiftEntity> shifts;
//   final Future<void> Function() onRefresh;
//   final MyShiftStatusType shiftsType;
//
//   const CashierMyShiftsListView({
//     super.key,
//     required this.shifts,
//     required this.onRefresh,
//     required this.shiftsType
//   });

class CashierMyShiftsListView extends StatefulWidget {
  final List<CashierShiftEntity> shifts;
  final Future<void> Function() onRefresh;
  final MyShiftStatusType shiftsType;
  final VoidCallback? onLoadMore;

  const CashierMyShiftsListView({
    super.key,
    required this.shifts,
    required this.onRefresh,
    required this.shiftsType,
    this.onLoadMore,
  });

  @override
  State<CashierMyShiftsListView> createState() =>
      _CashierMyShiftsListViewState();
}

class _CashierMyShiftsListViewState extends State<CashierMyShiftsListView> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        widget.onLoadMore?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: widget.shifts.isEmpty ? 1 : widget.shifts.length,
        itemBuilder: (context, index) {
          if (widget.shifts.isEmpty) {
            return Column(
              children: [
                CashierEmptyWidget(
                  title: context.tr.noAssignedShifts,
                  desc: context.tr.noAssignedShiftsDesc,
                  image: AppAssets.calendarPng,
                ),
              ],
            );
          } else {
            final shift = widget.shifts[index];
            final strategy = CashierMyShiftsCardStrategyResolver.resolve(
              widget.shiftsType,
            );
            return strategy.buildCard(shift);
          }
        },
      ),
    );
  }
}
