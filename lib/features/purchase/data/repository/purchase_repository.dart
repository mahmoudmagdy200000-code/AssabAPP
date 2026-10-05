import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/features/purchase/data/data_sources/remote/purchase_remote_data_source.dart';
import 'package:assab/features/purchase/data/models/purchase_branch_items_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/future_api_result.dart';
import '../models/compare_price_response.dart';
import '../models/purchase_branches_response.dart';
import '../models/purchase_create_order_request.dart';
import '../models/purchase_history_response.dart';
import '../models/purchase_product_branch_details_response.dart';
import '../models/purchase_product_officer_details_response.dart';
import '../models/purchase_supplier_product_details_response.dart';
import '../models/purchase_suppliers_response.dart';
import '../models/suppliers_for_filter_purchase_items_response.dart';

@LazySingleton()
class PurchaseRepository with RepositoryMixin {
  final PurchaseRemoteDataSource _purchaseRemoteDataSource;

  PurchaseRepository(this._purchaseRemoteDataSource);

  FutureApiResult<PurchaseBranchItemsResponse> getPurchaseBranchItems({
    required int page,
    String? supplierId,
    String? categoryId,
  }) => execute(() async {
    return _purchaseRemoteDataSource.getPurchaseBranchItems(
      page: page,
      supplierId: supplierId,
      categoryId: categoryId,
    );
  });

  FutureApiResult<PurchaseBranchesResponse> getPurchaseBranches({
    required String itemId,
    required String quantity,
    String? availability,
    String? responseTime,
    String? distance,
  }) => execute(() async {
    return _purchaseRemoteDataSource.getPurchaseBranches(
      itemId: itemId,
      availability: availability,
      responseTime: responseTime,
      distance: distance,
      quantity: quantity,
    );
  });

  FutureApiResult<PurchaseSuppliersResponse> getPurchaseSuppliers({
    required String itemId,
    required String quantity,
    String? availability,
    int? timeDelivery,
  }) => execute(() async {
    return _purchaseRemoteDataSource.getPurchaseSuppliers(
      itemId: itemId,
      quantity: quantity,
      availability: availability,
      timeDelivery: timeDelivery,
    );
  });

  FutureApiResult<PurchaseProductBranchDetailsResponse>
  getPurchaseProductBranchDetails({required String branchId}) => execute(
    () async => _purchaseRemoteDataSource.getPurchaseProductBranchDetails(
      branchId: branchId,
    ),
  );

  FutureApiResult<PurchaseProductOfficerDetailsResponse>
  getPurchaseProductOfficerDetails() => execute(
    () async => _purchaseRemoteDataSource.getPurchaseProductOfficerDetails(),
  );

  FutureApiResult<PurchaseSupplierProductDetailsResponse>
  getPurchaseProductSupplierDetails({required String supplierId}) => execute(
    () async => _purchaseRemoteDataSource.getPurchaseProductSupplierDetails(
      supplierId: supplierId,
    ),
  );

  FutureApiResult<void> createPurchaseOrder({
    required PurchaseCreateOrderRequest request,
  }) => execute(() async {
    return _purchaseRemoteDataSource.createPurchaseOrder(request: request);
  });

  FutureApiResult<void> submitOrderDraft({
    required String id,
    required PurchaseCreateOrderRequest request,
  }) => execute(() async {
    return _purchaseRemoteDataSource.submitOrderDraft(id: id, request: request);
  });

  FutureApiResult<void> deleteOrderDraft({required String id}) =>
      execute(() async => _purchaseRemoteDataSource.deleteOrderDraft(id: id));

  FutureApiResult<SuppliersForFilterPurchaseItemsResponse>
  getSuppliersForFilterPurchaseItems({required int page}) => execute(
    () async => _purchaseRemoteDataSource.getSuppliersForFilterPurchaseItems(
      page: page,
    ),
  );

  FutureApiResult<PurchaseHistoryResponse> getPurchaseHistory({
    required int page,
    String? perspective,
    String? type,
    String? dateRange,
  }) => execute(() async {
    return _purchaseRemoteDataSource.getPurchaseHistory(
      page: page,
      perspective: perspective,
      type: type,
      dateRange: dateRange,
    );
  });

  FutureApiResult<PurchaseComparePriceResponse> comparePurchasePrices({
    required String itemId,
  }) => execute(() async {
    return _purchaseRemoteDataSource.comparePurchasePrices(itemId: itemId);
  });

  FutureApiResult<void> saveComparePrices({required String id}) =>
      execute(() async {
        return _purchaseRemoteDataSource.savePurchaseComparePrices(itemId: id);
      });
}
