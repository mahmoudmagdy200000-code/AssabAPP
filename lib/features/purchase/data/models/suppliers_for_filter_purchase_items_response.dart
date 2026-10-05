import '../../../../shared/models/meta_model/meta_model.dart';

class SuppliersForFilterPurchaseItemsResponse {
  final List<SuppliersForFilterPurchaseItemsResponseData> data;
  final MetaModel meta;

  SuppliersForFilterPurchaseItemsResponse({
    required this.data,
    required this.meta,
  });

  factory SuppliersForFilterPurchaseItemsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return SuppliersForFilterPurchaseItemsResponse(
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => SuppliersForFilterPurchaseItemsResponseData.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

class SuppliersForFilterPurchaseItemsResponseData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;

  SuppliersForFilterPurchaseItemsResponseData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  factory SuppliersForFilterPurchaseItemsResponseData.fromJson(
    Map<String, dynamic> json,
  ) {
    return SuppliersForFilterPurchaseItemsResponseData(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      image: json['image'] as String?,
    );
  }
}
