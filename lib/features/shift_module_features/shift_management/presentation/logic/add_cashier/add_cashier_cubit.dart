import 'dart:math';

import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/add_cashier_models/add_cashier_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/branch_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/available_shifts_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_info_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/helpers/paginator.dart';
import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/model/branch_response_model.dart';
import '../../../data/model/shift/shift_details/shift_info_details_model.dart';

part 'add_cashier_state.dart';

@injectable
class AddCashierCubit extends SafeCubit<AddCashierState> {
  final ShiftManagementRepositoryImp _repository;

  Paginator<BranchModel, BranchesResponseModel>? _branchesPaginator;
  Paginator<ShiftInfoDetailsModel, AvailableShiftResponseModel>?
  _shiftsPaginator;

  AddCashierCubit(this._repository) : super(AddCashierInitial());

  List<ShiftInfoDetailsEntity>? workShifts;

  String? fullName;
  String? email;
  String? storeBranch;
  String? selectedBranchId;
  ShiftInfoDetailsEntity? shift;

  void setCubitValues({
    String? fullName,
    String? email,
    String? storeBranch,
    String? selectedBranchId,
    ShiftInfoDetailsEntity? shift,
  }) {
    this.fullName = fullName;
    this.email = email;
    this.storeBranch = storeBranch;
    this.selectedBranchId = selectedBranchId;
    this.shift = shift;
    emit(AddCashierValuesUpdated());
  }

  final List<BranchEntity> _branches = [];

  List<BranchEntity> get branches => _branches;

  Future<void> addCashier() async {
    emit(AddCashierLoading());

    final random = Random();
    final digits = List.generate(9, (_) => random.nextInt(10));

    final result = await _repository.addCashier(
      addCashierRequestModel: AddCashierRequestModel(
        name: fullName!,
        branchId: selectedBranchId!,
        email: email!,
        phone: digits.join(),
        shiftIds: [shift!.id],
      ),
    );

    handle(
      result,
      failure: (failure) {
        return emit(AddCashierFailure(failure));
      },
      success: (val) {
        return emit(AddCashierSuccess());
      },
    );
  }

  Future<void> validateEmail({
    required String email,
    required BuildContext context,
  }) async {
    emit(AddCashierLoading());

    final result = await _repository.validateEmail(email: email.trim());

    handle(
      result,
      failure: (failure) {
        return emit(AddCashierFailure(failure));
      },
      success: (response) {
        if (response.isRegistered) {
          emit(
            CheckEmailInvalid(
              ValidationFailure(
                error: DioErrorModel(
                  message: context.tr.emailIsAlreadyRegistered,
                ),
                icon: Icons.error_outline,
                stackTrace: StackTrace.current,
                statusCode: 400,
              ),
            ),
          );
        } else {
          emit(CheckEmailValid());
        }
      },
    );
  }
}
