import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_get_modification/supplier_get_modification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/supplier_get_modification/supplier_get_modification_cubit.dart';

class SupplierRequestsModificationDetailsBottomSheet extends StatefulWidget {
  final String orderId;
  final String itemId;

  const SupplierRequestsModificationDetailsBottomSheet({
    super.key,
    required this.orderId,
    required this.itemId,
  });

  @override
  State<SupplierRequestsModificationDetailsBottomSheet> createState() =>
      _SupplierRequestsModificationDetailsBottomSheetState();
}

class _SupplierRequestsModificationDetailsBottomSheetState
    extends State<SupplierRequestsModificationDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();

    _getModificationDetails();
  }

  void _getModificationDetails() {
    context.read<SupplierGetModificationCubit>().getSupplierModification(
      itemId: widget.itemId,
      orderId: widget.orderId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          BlocBuilder<
            SupplierGetModificationCubit,
            SupplierGetModificationState
          >(
            builder: (context, state) {
              if (state is SupplierGetModificationLoading) {
                return const AppLoadingWidget();
              } else if (state is SupplierGetModificationFailure) {
                return AppFailureWidget(
                  failure: state.failure,
                  onRetry: _getModificationDetails,
                  withBorder: false,
                );
              } else if (state is SupplierGetModificationSuccess) {
                return state.data.type.buildModificationDetailsWidget(
                  context,
                  state.data,
                );
              }

              return AppLocalFailure(
                onRetry: _getModificationDetails,
                withBorder: false,
              );
            },
          ),
    );
  }
}
