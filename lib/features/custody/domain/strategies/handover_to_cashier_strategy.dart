import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../presentation/widgets/custody_handover_to_cashier_handover_date_section.dart';
import '../../presentation/widgets/custody_handover_to_cashier_handover_method_section.dart';

abstract class HandoverToCashierStrategy {
  Widget buildHandOverMethodWidget(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildHandOverDateWidget(BuildContext context) {
    return const SizedBox.shrink();
  }

  void addDynamicFields(BuildContext context) {}

  void removeDynamicFields(BuildContext context) {}
}

class BranchCustodyBalanceHandoverToCashierStrategy
    extends HandoverToCashierStrategy {}

class StoreOwnerHandoverToCashierStrategy extends HandoverToCashierStrategy {
  @override
  void addDynamicFields(BuildContext context) {
    super.addDynamicFields(context);

    final validationCubit = context.read<ValidationCubit>();

    validationCubit.addDynamicFields({'handoverMethod', 'handoverDate'});
  }

  @override
  void removeDynamicFields(BuildContext context) {
    super.removeDynamicFields(context);

    final validationCubit = context.read<ValidationCubit>();

    validationCubit.removeDynamicFields({'handoverMethod', 'handoverDate'});
  }

  @override
  Widget buildHandOverMethodWidget(BuildContext context) {
    return const CustodyHandoverToCashierHandoverMethodSection();
  }

  @override
  Widget buildHandOverDateWidget(BuildContext context) {
    return const CustodyHandoverToCashierHandoverDateSection();
  }
}

class BranchManagerHandoverToCashierStrategy extends HandoverToCashierStrategy {
  @override
  void addDynamicFields(BuildContext context) {
    super.addDynamicFields(context);

    final validationCubit = context.read<ValidationCubit>();

    validationCubit.addDynamicFields({'handoverMethod', 'handoverDate'});
  }

  @override
  void removeDynamicFields(BuildContext context) {
    super.removeDynamicFields(context);

    final validationCubit = context.read<ValidationCubit>();

    validationCubit.removeDynamicFields({'handoverMethod', 'handoverDate'});
  }

  @override
  Widget buildHandOverMethodWidget(BuildContext context) {
    return const CustodyHandoverToCashierHandoverMethodSection();
  }

  @override
  Widget buildHandOverDateWidget(BuildContext context) {
    return const CustodyHandoverToCashierHandoverDateSection();
  }
}
