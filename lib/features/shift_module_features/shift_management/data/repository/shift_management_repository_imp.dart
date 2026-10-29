import 'package:assab/features/shift_module_features/shift_management/data/mapper/cashier_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/check_email_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/mapper/shift/shift_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/add_cashier_models/add_cashier_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/branch_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/end_shift_models/manager_end_shift_request_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/manager_shift_management_models/final_daily_close/final_daily_close_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/aggregators_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/reassign_shift/reassign_shift_with_handover.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/cashier_handover_details_entity/cashier_handover_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/current_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/end_shift_response_entites/manager_shift_update_data_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_status_details_entities/handover_status_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/variance_details/handover_variance_details_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../core/errors/repository_mixin.dart';
import '../../../../../core/utils/future_api_result.dart';
import '../../domain/entity/check_email_entity.dart';
import '../../domain/entity/manager_shift/end_shift_response_entites/manager_shift_end_data_entity.dart';
import '../../domain/entity/shift/shift_entity.dart';
import '../../domain/enums/user_type.dart';
import '../../presentation/mappers/manager_shift_mapper/end_shift_response_entites_mappers/manager_shift_end_data_mapper.dart';
import '../data_source/shift_management_remote_data_source.dart';
import '../mapper/manager_shift/cashier_handover_details_mapper.dart';
import '../mapper/manager_shift/current_shift_mapper.dart';
import '../mapper/manager_shift/manager_shift_update_data_mapper.dart';
import '../mapper/shift/handover_status_details_mappers/handover_status_details_mapper.dart';
import '../mapper/shift/variance_details/handover_variance_details_mapper.dart';
import '../model/add_cashier_models/update_cashier_request.dart';
import '../model/available_recipients_response_model.dart';
import '../model/cashiers_response_model.dart';
import '../model/get_all_cashiers_and_managers_response_model.dart';
import '../model/manager_shift_management_models/end_shift_models/update_manager_handover_request_model.dart';
import '../model/shift/available_cashiers_response_model.dart';
import '../model/shift/available_shifts_model.dart';
import '../model/shift/end_shift_request_with_variance.dart';
import '../model/shift/hand_over_request.dart';
import '../model/shift/handover_approve_body_request.dart';
import '../model/shift/reassign_shift/reassign_shift_request_model.dart';
import '../model/shift/shift_response_model.dart';

import '../../domain/repository/shift_management_repository.dart';
import '../model/shift/end_shift_aggregator_model.dart';

@LazySingleton()
class ShiftManagementRepositoryImp with RepositoryMixin implements ShiftManagementRepository {
  final ShiftManagementRemoteDataSource _remoteDataSource;

  ShiftManagementRepositoryImp(this._remoteDataSource);

  FutureApiResult<CashiersResponseModel> getCashiers({
    String? status,
    String? search,
    String? dateOption,
    int? page,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.getCashiers(
        page: page,
        status: status,
        dateOption: dateOption,
        search: search,
      );

      // final cashiers = response.data.map((m) => m.toEntity()).toList();

      return response;
    });
  }

  FutureApiResult<GetAllCashiersAndManagersResponse> getAllCashiersAndManagers({
    int? page,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.getAllCashiersAndManagers(
        page: page,
      );

      return response;
    });
  }

  FutureApiResult addCashier({
    required AddCashierRequestModel addCashierRequestModel,
  }) async {
    return execute(() async {
      await _remoteDataSource.addCashier(body: addCashierRequestModel.toJson());

      return true;
    });
  }

  FutureApiResult endShift({
    required String shiftId,
    required EndShiftRequest endShiftRequest,
  }) async {
    return execute(() async {
      await _remoteDataSource.endShift(
        shiftId: shiftId,
        formData: await endShiftRequest.toFormData(),
      );

      return true;
    });
  }

  FutureApiResult<AvailableShiftResponseModel> getAvailableShifts({
    required int page,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.getAvailableShifts(page: page);

      return response;
    });
  }

  FutureApiResult<AggregatorsResponseModel> getAggregators({
    required int page,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.getAggregators(page: page);

      return response;
    });
  }

  FutureApiResult<BranchesResponseModel> getBranches({
    required int page,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.getBranches(page: page);

      return response;
    });
  }

  FutureApiResult<AvailableCashiersResponse> getAvailableCashiersForShift({
    required String shiftId,
    required String shiftDate,
    required int page,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.getAvailableCashiersForShift(
        shiftId: shiftId.toString(),
        shiftDate: shiftDate,
        page: page,
      );

      return response;
    });
  }

  // FutureApiResult<List<ShiftEntity>> getAllCashierShifts(String cashierId) async {
  //   return execute(() async {
  //     final response = await _remoteDataSource.getAllCashierShifts(
  //       cashierId: cashierId,
  //     );
  //     final shifts = response.data.map((m) => m.toEntity()).toList();
  //     return shifts;
  //   } catch (e, st) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e, st));
  //   }
  // }
  //
  // FutureApiResult<List<ShiftEntity>> getPendingShifts(String cashierId) async {
  //   try {
  //     final response = await _remoteDataSource.getPendingShifts(
  //       cashierId: cashierId,
  //     );
  //     final shifts = response.data.map((m) => m.toEntity()).toList();
  //     return shifts;
  //   } catch (e, st) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e, st));
  //   }
  // }
  //
  // FutureApiResult<List<ShiftEntity>> getInProgressShifts(String cashierId) async {
  //   try {
  //     final response = await _remoteDataSource.getInProgressShifts(
  //       cashierId: cashierId,
  //     );
  //     final shifts = response.data.map((m) => m.toEntity()).toList();
  //     return shifts;
  //   } catch (e, st) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e, st));
  //   }
  // }
  //
  // FutureApiResult<List<ShiftEntity>> getCompletedShifts(String cashierId) async {
  //   try {
  //     final response = await _remoteDataSource.getCompletedShifts(
  //       cashierId: cashierId,
  //     );
  //     final shifts = response.data.map((m) => m.toEntity()).toList();
  //     return shifts;
  //   } catch (e, st) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e, st));
  //   }
  // }

  FutureApiResult<ShiftResponseModel> getAllCashierShifts(
    String cashierId,
    int page, {
    String? dateFilter,
    ShiftStatus? statusFilter,
    String? managerId,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.getAllCashierShifts(
        cashierId: cashierId,
        page: page,
        managerId: managerId,
        dateOption: dateFilter,
        status: statusFilter?.type.name,
      );

      return response;
    });
  }

  FutureApiResult<ShiftResponseModel> getPendingShifts(
    String cashierId,
    int page,
  ) async {
    return execute(() async {
      final response = await _remoteDataSource.getPendingShifts(
        cashierId: cashierId,
        page: page,
      );

      return response;
    });
  }

  FutureApiResult<ShiftResponseModel> getInProgressShifts(
    String cashierId,
    int page,
  ) async {
    return execute(() async {
      final response = await _remoteDataSource.getInProgressShifts(
        cashierId: cashierId,
        page: page,
      );

      return response;
    });
  }

  FutureApiResult<ShiftResponseModel> getCompletedShifts(
    String cashierId,
    int page,
  ) async {
    return execute(() async {
      final response = await _remoteDataSource.getCompletedShifts(
        cashierId: cashierId,
        page: page,
      );

      return response;
    });
  }

  FutureApiResult<ShiftEntity> getShiftDetails(String shiftId) async {
    return execute(() async {
      final response = await _remoteDataSource.getShiftDetails(
        shiftId: shiftId,
      );

      final shift = response.data.toEntity();
      return shift;
    });
  }

  FutureApiResult<HandoverStatusDetailsEntity> getHandoverRejectionDetails(
    String shiftId,
  ) async {
    return execute(() async {
      final response = await _remoteDataSource.getHandoverRejectionDetails(
        shiftId: shiftId,
      );
      final shift = response.data.toEntity();
      return shift;
    });
  }

  Future reassignShift(
    String id,
    ReassignShiftRequestModel reassignShiftRequestModel,
  ) async {
    return execute(() async {
      await _remoteDataSource.reassignShift(id, reassignShiftRequestModel);

      return true;
    });
  }

  Future reassignShiftWithHandOver(
    String id,
    ReassignShiftRequestWithHandOverRequest reassignShiftRequestModel,
  ) async {
    return execute(() async {
      await _remoteDataSource.reassignShiftWithHandOver(
        shiftId: id,
        data: await reassignShiftRequestModel.toFormData(),
      );

      return true;
    });
  }

  Future endShiftWithHandOver(
    String id,
    EndShiftRequestWithHandOver endShiftRequestWithVariance,
  ) async {
    return execute(() async {
      await _remoteDataSource.endShiftWithHandOver(
        shiftId: id,
        data: await endShiftRequestWithVariance.toFormData(),
      );

      return true;
    });
  }

  FutureApiResult<CurrentShiftEntity> getCurrentShift() async {
    return execute(() async {
      final response = await _remoteDataSource.getCurrentShift();
      final shift = response.data.toEntity();
      return shift;
    });
  }

  FutureApiResult startManagerShift() async {
    return execute(() async {
      await _remoteDataSource.startManagerShift();
      return true;
    });
  }

  FutureApiResult<ManagerShiftEndDataEntity> endManagerShift({
    required EndManagerShiftRequestModel request,
    String? idempotencyKey,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.endManagerShift(
        endManagerShiftRequestModel: request,
        idempotencyKey: idempotencyKey,
      );

      final ManagerShiftEndDataEntity entity = response.data.toEntity();

      return entity;
    });
  }

  FutureApiResult<ManagerShiftUpdateDataEntity> updateManagerHandoverShift({
    required UpdateManagerHandoverRequestModel request,
    String? idempotencyKey,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.updateManagerHandoverShift(
        updateManagerShiftRequestModel: request,
        idempotencyKey: idempotencyKey,
      );

      final ManagerShiftUpdateDataEntity entity = response.data.toEntity();

      return entity;
    });
  }

  FutureApiResult approveHandover({
    required String shiftId,
    String? confirmedAmount,
    String? managerComment,
    String? transferAttemptId,
  }) async {
    return execute(() async {
      await _remoteDataSource.approveHandover(
        shiftId: shiftId,
        handoverApproveAndRejectBodyRequest: HandoverApproveAndRejectBodyRequest(
          confirmedAmount: confirmedAmount,
          managerComment: managerComment,
          transferAttemptId: transferAttemptId,
        ),
      );
      return true;
    });
  }

  FutureApiResult acceptCashierHandover({
    required String shiftId,
    required String confirmedAmount,
    String? receivingShiftId,
    String? transferAttemptId,
    String? comment,
  }) async {
    return execute(() async {
      await _remoteDataSource.acceptCashierHandover(
        shiftId: shiftId,
        body: HandoverApproveAndRejectBodyRequest(
          confirmedAmount: confirmedAmount,
          receivingShiftId: receivingShiftId,
          transferAttemptId: transferAttemptId,
          comment: comment,
        ),
      );
      return true;
    });
  }

  FutureApiResult rejectCashierHandover({
    required String shiftId,
    String? rejectionReason,
    String? correctionReason,
    String? confirmedAmount,
    String? transferAttemptId,
    String? managerComment,
  }) async {
    return execute(() async {
      await _remoteDataSource.rejectCashierHandover(
        shiftId: shiftId,
        body: HandoverApproveAndRejectBodyRequest(
          rejectionReason: rejectionReason,
          correctionReason: correctionReason,
          confirmedAmount: confirmedAmount,
          transferAttemptId: transferAttemptId,
          managerComment: managerComment,
        ),
      );
      return true;
    });
  }

  FutureApiResult rejectHandover({
    required String shiftId,
    String? managerComment,
  }) async {
    return execute(() async {
      await _remoteDataSource.rejectHandover(
        shiftId: shiftId,
        handoverApproveAndRejectBodyRequest: managerComment != null
            ? HandoverApproveAndRejectBodyRequest(
                rejectionReason: managerComment,
              )
            : null,
      );
      return true;
    });
  }

  FutureApiResult requestHandoverCorrection({
    required String shiftId,
    String? managerComment,
  }) async {
    return execute(() async {
      await _remoteDataSource.requestHandoverCorrection(
        shiftId: shiftId,
        handoverApproveAndRejectBodyRequest: managerComment != null
            ? HandoverApproveAndRejectBodyRequest(
                managerComment: managerComment,
              )
            : null,
      );
      return true;
    });
  }

  FutureApiResult<CashierHandoverDetailsEntity> getHandoverDetails({
    required String handoverId,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.getHandoverDetails(
        handoverId: handoverId,
      );
      final handover = response.data.handover.toEntity();
      return handover;
    });
  }

  FutureApiResult startCashierShift(String shiftId) async {
    return execute(() async {
      await _remoteDataSource.startCashierShift(shiftId: shiftId);
      return true;
    });
  }

  FutureApiResult startShiftByManager(String shiftId) async {
    return execute(() async {
      await _remoteDataSource.startShiftByManager(shiftId: shiftId);
      return true;
    });
  }

  FutureApiResult handOver({
    required String shiftId,
    required String cashierId,
    required bool isManager,
    required double handOverAmount,
    String? note,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.handOver(
        shiftId: shiftId,
        handOverRequest: HandOverRequest(
          handoverType: isManager
              ? UserType.manager.value
              : UserType.cashier.value,
          nextCashierId: isManager ? null : cashierId,
          branchManagerId: isManager ? cashierId : null,
          handOverAmount: handOverAmount,
          handoverNotes: note,
        ),
      );
      return response;
    });
  }

  FutureApiResult<AvailableRecipientsResponseModel> getAvailableRecipients(
    String shiftId,
  ) async {
    return execute(() async {
      return await _remoteDataSource.getAvailableRecipients(shiftId: shiftId);
    });
  }

  FutureApiResult<HandoverVarianceDetailsEntity?> getVarianceDetails(
    String shiftId,
  ) async {
    return execute(() async {
      final response = await _remoteDataSource.getVarianceDetails(
        shiftId: shiftId,
      );

      return response.data.variance?.toEntity();
    });
  }

  FutureApiResult<FinalDailyCloseData> getDailyClose() async {
    return execute(() async {
      final response = await _remoteDataSource.getDailyClose();

      return response.data;
    });
  }

  FutureApiResult<CheckEmailDataEntity> validateEmail({
    required String email,
  }) async {
    return execute(() async {
      final response = await _remoteDataSource.checkCashierEmail(email: email);

      return response.toEntity();
    });
  }

  FutureApiResult updateCashier({
    required String cashierId,
    required UpdateCashierRequest request,
  }) async {
    return execute(() async {
      await _remoteDataSource.updateCashier(
        cashierId: cashierId,
        body: request.toForm(),
      );
      return true;
    });
  }

  FutureApiResult<CashierEntity> getCashierDetails({
    required String cashierId,
  }) async {
    return execute(() async {
      final result = await _remoteDataSource.getCashierDetails(
        cashierId: cashierId,
      );
      return result.data.cashier.toEntity();
    });
  }

  @override
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    List<EndShiftAggregatorModel>? aggregators,
  }) async {
    return execute(() async {
      final body = <String, dynamic>{
        'total_sales': totalSales.toStringAsFixed(2),
        'counted_cash': countedCash.toStringAsFixed(2),
        if (cardPayments != null)
          'card_payments': cardPayments.toStringAsFixed(2),
        if (aggregators != null && aggregators.isNotEmpty)
          'aggregators': aggregators
              .map(
                (a) => {
                  'aggregator_id': a.aggregatorId,
                  'amount': a.amount.toStringAsFixed(2),
                },
              )
              .toList(),
      };

      final response = await _remoteDataSource.previewCashReconciliation(
        shiftId: shiftId,
        body: body,
      );

      if (response is Map<String, dynamic>) {
        return response;
      } else if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return <String, dynamic>{};
    });
  }
}
