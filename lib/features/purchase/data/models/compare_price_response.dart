class PurchaseComparePriceResponse {
  final PurchaseComparePriceData data;

  PurchaseComparePriceResponse({required this.data});

  factory PurchaseComparePriceResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseComparePriceResponse(
      data: PurchaseComparePriceData.fromJson(_readMap(json, 'data')),
    );
  }
}

class PurchaseComparePriceData {
  final String comparisonId;
  final String itemId;
  final String itemName;
  final String itemCode;
  final String itemUnit;
  final String itemLogo;
  final num itemPrice;
  final int quantity;
  final PurchaseComparePriceResponseSources sources;
  final PurchaseComparePriceResponseUseRecommendation useRecommendation;
  final PurchaseComparePriceResponseFactors factors;
  final List<PurchaseComparePriceResponsePriceTrend> priceTrends;

  PurchaseComparePriceData({
    required this.comparisonId,
    required this.itemId,
    required this.itemName,
    required this.itemCode,
    required this.itemUnit,
    required this.itemLogo,
    required this.itemPrice,
    required this.quantity,
    required this.sources,
    required this.useRecommendation,
    required this.factors,
    required this.priceTrends,
  });

  factory PurchaseComparePriceData.fromJson(Map<String, dynamic> json) {
    return PurchaseComparePriceData(
      comparisonId: _readString(json, 'comparisonId', 'comparison_id'),
      itemId: _readString(json, 'itemId', 'item_id'),
      itemName: _readString(json, 'itemName', 'item_name'),
      itemCode: _readString(json, 'itemCode', 'item_code'),
      itemUnit: _readString(json, 'itemUnit', 'item_unit'),
      itemLogo: _readString(json, 'itemLogo', 'item_logo'),
      itemPrice: _readNum(json, 'itemPrice', 'item_price'),
      quantity: _readInt(json, 'quantity'),
      sources: PurchaseComparePriceResponseSources.fromJson(
        _readMap(json, 'sources'),
      ),
      useRecommendation: PurchaseComparePriceResponseUseRecommendation.fromJson(
        _readMap(json, 'useRecommendation', 'use_recommendation'),
      ),
      factors: PurchaseComparePriceResponseFactors.fromJson(
        _readMap(json, 'factors'),
      ),
      priceTrends: _readList(json, 'priceTrends', 'price_trends')
          .map(
            (e) => PurchaseComparePriceResponsePriceTrend.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class PurchaseComparePriceResponseSources {
  final PurchaseComparePriceDetails directSupplier;
  final PurchaseComparePriceDetails viaPurchasingOfficer;
  final PurchaseComparePriceDetails internalTransfer;

  PurchaseComparePriceResponseSources({
    required this.directSupplier,
    required this.viaPurchasingOfficer,
    required this.internalTransfer,
  });

  factory PurchaseComparePriceResponseSources.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseComparePriceResponseSources(
      directSupplier: PurchaseComparePriceDetails.fromJson(
        _readMap(json, 'directSupplier', 'direct_supplier'),
      ),
      viaPurchasingOfficer: PurchaseComparePriceDetails.fromJson(
        _readMap(json, 'viaPurchasingOfficer', 'via_purchasing_officer'),
      ),
      internalTransfer: PurchaseComparePriceDetails.fromJson(
        _readMap(json, 'internalTransfer', 'internal_transfer'),
      ),
    );
  }
}

class PurchaseComparePriceDetails {
  final String price;
  final String deliveryDays;
  final String rating;

  PurchaseComparePriceDetails({
    required this.price,
    required this.deliveryDays,
    required this.rating,
  });

  factory PurchaseComparePriceDetails.fromJson(Map<String, dynamic> json) {
    return PurchaseComparePriceDetails(
      price: _readString(json, 'price'),
      deliveryDays: _readString(json, 'deliveryDays', 'delivery_days'),
      rating: _readString(json, 'rating'),
    );
  }
}

class PurchaseComparePriceResponseUseRecommendation {
  final String sourceType;
  final String sourceId;
  final String sourceName;

  PurchaseComparePriceResponseUseRecommendation({
    required this.sourceType,
    required this.sourceId,
    required this.sourceName,
  });

  factory PurchaseComparePriceResponseUseRecommendation.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseComparePriceResponseUseRecommendation(
      sourceType: _readString(json, 'sourceType', 'source_type'),
      sourceId: _readString(json, 'sourceId', 'source_id'),
      sourceName: _readString(json, 'sourceName', 'source_name'),
    );
  }
}

class PurchaseComparePriceResponseFactors {
  final PurchaseComparePriceResponseFactorsData bestCompliance;
  final PurchaseComparePriceResponseFactorsData fastestDelivery;
  final PurchaseComparePriceResponseFactorsData lowestPrice;

  PurchaseComparePriceResponseFactors({
    required this.bestCompliance,
    required this.fastestDelivery,
    required this.lowestPrice,
  });

  factory PurchaseComparePriceResponseFactors.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseComparePriceResponseFactors(
      bestCompliance: PurchaseComparePriceResponseFactorsData.fromJson(
        _readMap(json, 'bestCompliance', 'best_compliance'),
      ),
      fastestDelivery: PurchaseComparePriceResponseFactorsData.fromJson(
        _readMap(json, 'fastestDelivery', 'fastest_delivery'),
      ),
      lowestPrice: PurchaseComparePriceResponseFactorsData.fromJson(
        _readMap(json, 'lowestPrice', 'lowest_price'),
      ),
    );
  }
}

class PurchaseComparePriceResponseFactorsData {
  final String sourceType;
  final String sourceId;
  final String sourceName;
  final String rate;

  PurchaseComparePriceResponseFactorsData({
    required this.sourceType,
    required this.sourceId,
    required this.sourceName,
    required this.rate,
  });

  factory PurchaseComparePriceResponseFactorsData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseComparePriceResponseFactorsData(
      sourceType: _readString(json, 'sourceType', 'source_type'),
      sourceId: _readString(json, 'sourceId', 'source_id'),
      sourceName: _readString(json, 'sourceName', 'source_name'),
      rate: _readString(json, 'rate'),
    );
  }
}

class PurchaseComparePriceResponsePriceTrend {
  final String date;
  final num value;

  PurchaseComparePriceResponsePriceTrend({
    required this.date,
    required this.value,
  });

  factory PurchaseComparePriceResponsePriceTrend.fromJson(
    Map<String, dynamic> json,
  ) {
    return PurchaseComparePriceResponsePriceTrend(
      date: _readString(json, 'date'),
      value: _readNum(json, 'value'),
    );
  }
}

String _readString(Map<String, dynamic> json, String key1, [String? key2]) {
  final value = json[key1] ?? (key2 != null ? json[key2] : null);

  if (value == null || value.toString().trim().isEmpty) {
    return '-';
  }

  return value.toString();
}

num _readNum(Map<String, dynamic> json, String key1, [String? key2]) {
  final value = json[key1] ?? (key2 != null ? json[key2] : null);

  if (value == null) {
    return 0;
  }

  if (value is num) {
    return value;
  }

  return num.tryParse(value.toString()) ?? 0;
}

int _readInt(Map<String, dynamic> json, String key1, [String? key2]) {
  final value = json[key1] ?? (key2 != null ? json[key2] : null);

  if (value == null) {
    return 0;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString()) ?? 0;
}

Map<String, dynamic> _readMap(
  Map<String, dynamic> json,
  String key1, [
  String? key2,
]) {
  final value = json[key1] ?? (key2 != null ? json[key2] : null);

  if (value is Map<String, dynamic>) {
    return value;
  }

  return {};
}

List<dynamic> _readList(
  Map<String, dynamic> json,
  String key1, [
  String? key2,
]) {
  final value = json[key1] ?? (key2 != null ? json[key2] : null);

  if (value is List) {
    return value;
  }

  return [];
}
