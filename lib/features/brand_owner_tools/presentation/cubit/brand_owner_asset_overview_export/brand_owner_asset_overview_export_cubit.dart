import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/brand_owner_asset_overview_model.dart';
import '../../../domain/use_cases/export_brand_owner_asset_overview_report_use_case.dart';
import 'brand_owner_asset_overview_export_state.dart';

@injectable
class BrandOwnerAssetOverviewExportCubit
    extends SafeCubit<BrandOwnerAssetOverviewExportState> {
  final ExportBrandOwnerAssetOverviewReportUseCase _exportUseCase;

  BrandOwnerAssetOverviewExportCubit(this._exportUseCase)
    : super(const BrandOwnerAssetOverviewExportInitial());

  Future<void> export({
    required String branchId,
    required String format,
  }) async {
    emit(const BrandOwnerAssetOverviewExportLoading());

    final result = await _exportUseCase(
      request: BrandOwnerAssetOverviewExportRequestModel(
        branchId: branchId,
        format: format,
      ),
    );

    handle(
      result,
      success: (response) =>
          emit(BrandOwnerAssetOverviewExportSuccess(response)),
      failure: (failure) =>
          emit(BrandOwnerAssetOverviewExportFailure(failure)),
    );
  }
}
