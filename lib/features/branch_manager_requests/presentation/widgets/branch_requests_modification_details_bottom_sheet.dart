import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/branch_get_modification/branch_get_modification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/branch_get_modification/branch_get_modification_cubit.dart';

class BranchRequestsModificationDetailsBottomSheet extends StatefulWidget {
  final String orderId;
  final String itemId;
  final String cancelItemId;

  const BranchRequestsModificationDetailsBottomSheet({
    super.key,
    required this.orderId,
    required this.itemId,
    required this.cancelItemId,
  });

  @override
  State<BranchRequestsModificationDetailsBottomSheet> createState() =>
      _BranchRequestsModificationDetailsBottomSheetState();
}

class _BranchRequestsModificationDetailsBottomSheetState
    extends State<BranchRequestsModificationDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();

    _getModificationDetails();
  }

  void _getModificationDetails() {
    context.read<BranchGetModificationCubit>().getBranchModification(
      itemId: widget.itemId,
      orderId: widget.orderId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BranchGetModificationCubit, BranchGetModificationState>(
        builder: (context, state) {
          if (state is BranchGetModificationLoading) {
            return const AppLoadingWidget();
          } else if (state is BranchGetModificationFailure) {
            return AppFailureWidget(
              failure: state.failure,
              withBorder: false,
              onRetry: _getModificationDetails,
            );
          } else if (state is BranchGetModificationSuccess) {
            return Column(
              children: [
                Expanded(
                  child: state.data.type.buildModificationDetailsWidget(
                    context,
                    state.data,
                  ),
                ),
                state.data.status.buildButtonsSectionInModificationDetails(
                  context,
                  orderId: widget.orderId,
                  cancelItemId: widget.cancelItemId,
                ),
              ],
            );
          }

          return AppLocalFailure(
            withBorder: false,
            onRetry: _getModificationDetails,
          );
        },
      ),
    );
  }
}
