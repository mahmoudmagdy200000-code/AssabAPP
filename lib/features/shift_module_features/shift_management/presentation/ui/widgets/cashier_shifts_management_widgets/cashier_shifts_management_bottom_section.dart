import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_tab_views/completed_shifts_view.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_tab_views/in_progress_shifts_view.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_tab_views/pending_shifts_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../../core/cubits/paging_cubit/paging_state.dart';

class CashierShiftsManagementBottomSection extends StatelessWidget {
  const CashierShiftsManagementBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocSelector<PagingCubit, PagingState, int>(
        selector: (state) => state.currentIndex,
        builder: (context, index) {
          return IndexedStack(
            index: index,
            children: const [
              CashierPendingShiftsView(),
              CashierInProgressShiftsView(),
              CashierCompletedShiftsView(),
            ],
          );
        },
      ),
    );
  }
}

// class CashierShiftsManagementBottomSection extends StatefulWidget {
//   const CashierShiftsManagementBottomSection({super.key,
//     this.isFromFilter = false,
//     this.managerId,
//     this.dateFilter,
//     this.filterStatus
//   });
//
//   final bool isFromFilter;
//   final String? managerId;
//   final String? dateFilter;
//   final ShiftStatus? filterStatus;
//
//
//   @override
//   State<CashierShiftsManagementBottomSection> createState() =>
//       _CashierShiftsManagementBottomSectionState();
// }
//
// class _CashierShiftsManagementBottomSectionState
//     extends State<CashierShiftsManagementBottomSection> {
//   late final ScrollController _scrollController;
//
//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     if(!widget.isFromFilter){
//       _getPendingShifts();
//     }
//     _scrollController.addListener(_scrollControllerListener);
//     super.initState();
//   }
//
//   bool _isFetching = false;
//
//   void _scrollControllerListener() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       final cubit = context.read<CashierShiftsManagementCubit>();
//       if (!cubit.hasMore || _isFetching) return;
//
//       _isFetching = true;
//       if(widget.isFromFilter){
//         cubit.fetchShiftsWithFilters(
//             loadMore:true,
//           dateFilter: widget.dateFilter,
//           statusFilter: widget.filterStatus,
//           managerIdFilter: widget.managerId,
//         );
//       }else{
//
//         cubit.status?.get(context, loadMore: true);
//
//       }
//
//       _isFetching = false;
//     }
//   }
//
//   void _getPendingShifts() {
//     context.read<CashierShiftsManagementCubit>().getPendingShifts();
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollControllerListener);
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CashierShiftsManagementCubit, CashierShiftsManagementState>(
//       builder: (context, state) {
//         if (state is ShiftManagementBranchLoading) {
//           return const Expanded(child: AppLoadingWidget());
//         }
//
//         if (state is ShiftManagementBranchFailure) {
//           return Expanded(
//             child: AppFailureWidget(
//               failure: state.failure,
//               onRetry:() {
//
//                 if(widget.isFromFilter){
//                   context
//                       .read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(
//                     loadMore:true,
//                     dateFilter: widget.dateFilter,
//                     statusFilter: widget.filterStatus,
//                     managerIdFilter: widget.managerId,
//                   );
//                 }else{
//                 context
//                     .read<CashierShiftsManagementCubit>()
//                     .status!
//                     .get(context);
//                 }
//               },
//             ),
//           );
//         }
//
//         if (state is ShiftManagementBranchEmpty) {
//           return Expanded(
//             child: RefreshIndicator(
//               onRefresh: () async {
//                 if (widget.isFromFilter) {
//                   context.read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(
//                     loadMore: true,
//                     dateFilter: widget.dateFilter,
//                     statusFilter: widget.filterStatus,
//                     managerIdFilter: widget.managerId,
//                   );
//                 } else {
//                   context
//                       .read<CashierShiftsManagementCubit>()
//                       .status!
//                       .get(context);
//                 }
//               },
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: SizedBox(
//                   height: AppResponsive.screenHeight,
//                   child: ShiftsEmptyWidget(
//                     status: state.status!,
//                     nextShift: state.nextShift,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//
//         if (state is ShiftManagementBranchLoaded) {
//
//           if (context.read<CashierShiftsManagementCubit>().shifts.isEmpty) {
//             return Expanded(
//               child: RefreshIndicator(
//                 onRefresh: () async {
//                   if (widget.isFromFilter) {
//                     context.read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(
//                       loadMore: true,
//                       dateFilter: widget.dateFilter,
//                       statusFilter: widget.filterStatus,
//                       managerIdFilter: widget.managerId,
//                     );
//                   } else {
//                     context
//                         .read<CashierShiftsManagementCubit>()
//                         .status!
//                         .get(context);
//                   }
//                 },
//                 child: SingleChildScrollView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   child: SizedBox(
//                     height: AppResponsive.screenHeight,
//                     child: ShiftsEmptyWidget(
//                       status: state.status!,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//         }
//
//           return Expanded(
//             child: ShiftsListView(
//               shifts: context.read<CashierShiftsManagementCubit>().shifts,
//               controller: _scrollController,
//               shiftStatusSelectedOption: context.read<CashierShiftsManagementCubit>().status!,
//               onRefresh: ()async{
//                 if(widget.isFromFilter){
//                   context.read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(
//                     loadMore:false,
//                     dateFilter: widget.dateFilter,
//                     statusFilter: widget.filterStatus,
//                     managerIdFilter: widget.managerId,
//                   );
//                 }else{
//                   context.read<CashierShiftsManagementCubit>().status!.get(context);
//                 }
//               },
//             ),
//           );
//       },
//     );
//   }
// }
