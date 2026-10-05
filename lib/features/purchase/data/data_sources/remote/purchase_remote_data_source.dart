import 'package:assab/core/network/api_endpoints.dart';
import 'package:assab/features/purchase/data/models/purchase_create_order_request.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/compare_price_response.dart';
import '../../models/purchase_branch_items_response.dart';
import '../../models/purchase_branches_response.dart';
import '../../models/purchase_history_response.dart';
import '../../models/purchase_product_branch_details_response.dart';
import '../../models/purchase_product_officer_details_response.dart';
import '../../models/purchase_supplier_product_details_response.dart';
import '../../models/purchase_suppliers_response.dart';
import '../../models/suppliers_for_filter_purchase_items_response.dart';

part 'purchase_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class PurchaseRemoteDataSource {
  factory PurchaseRemoteDataSource(Dio dio, {String baseUrl}) =
      _PurchaseRemoteDataSource;

  @GET(ApiEndpoint.purchaseBranchItems)
  Future<PurchaseBranchItemsResponse> getPurchaseBranchItems({
    @Query('page') required int page,
    @Query('supplier_id') required String? supplierId,
    @Query('category') required String? categoryId,
  });

  @GET(ApiEndpoint.purchaseBranches)
  Future<PurchaseBranchesResponse> getPurchaseBranches({
    @Query('item_id') required String itemId,
    @Query('quantity') required String quantity,
    @Query('min_availability') required String? availability,
    @Query('response_time') required String? responseTime,
    @Query('max_distance_km') required String? distance,
  });

  @GET(ApiEndpoint.purchaseDirectSupplierItems)
  Future<PurchaseSuppliersResponse> getPurchaseSuppliers({
    @Query('item_id') required String itemId,
    @Query('quantity') required String quantity,
    @Query('min_availability') required String? availability,
    @Query('max_delivery_hours') required int? timeDelivery,
  });

  @GET(ApiEndpoint.purchaseTransferItems)
  Future<PurchaseProductBranchDetailsResponse> getPurchaseProductBranchDetails({
    @Query('branch_id') required String branchId,
  });

  @GET(ApiEndpoint.purchasePurchasingOfficerItems)
  Future<PurchaseProductOfficerDetailsResponse>
  getPurchaseProductOfficerDetails();

  @GET(ApiEndpoint.purchaseSupplierItems)
  Future<PurchaseSupplierProductDetailsResponse>
  getPurchaseProductSupplierDetails({
    @Query('supplier_id') required String supplierId,
  });

  @POST(ApiEndpoint.purchaseCreateOrder)
  Future<void> createPurchaseOrder({
    @Body() required PurchaseCreateOrderRequest request,
  });

  @POST(ApiEndpoint.purchaseSubmitOrderDraft)
  Future<void> submitOrderDraft({
    @Path('id') required String id,
    @Body() required PurchaseCreateOrderRequest request,
  });

  @DELETE(ApiEndpoint.purchaseDeleteOrderDraft)
  Future<void> deleteOrderDraft({@Path('id') required String id});

  @GET(ApiEndpoint.purchaseSuppliersForFilterPurchaseItems)
  Future<SuppliersForFilterPurchaseItemsResponse>
  getSuppliersForFilterPurchaseItems({@Query('page') required int page});

  @GET(ApiEndpoint.purchaseHistory)
  Future<PurchaseHistoryResponse> getPurchaseHistory({
    @Query('page') required int page,
    @Query('perspective') required String? perspective,
    @Query('type') required String? type,
    @Query('date_range') required String? dateRange,
  });

  @POST(ApiEndpoint.purchaseComparePrices)
  Future<PurchaseComparePriceResponse> comparePurchasePrices({
    @Query('item_id') required String itemId,
  });

  @POST(ApiEndpoint.purchaseComparePricesSave)
  Future<void> savePurchaseComparePrices({
    @Query('item_id') required String itemId,
  });
}
