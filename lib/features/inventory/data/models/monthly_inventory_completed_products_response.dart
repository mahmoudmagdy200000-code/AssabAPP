import 'monthly_inventory_pending_products_response.dart';

class MonthlyInventoryCompletedProductsResponse {
  final int elapsedSeconds;
  final String elapsedFormatted;
  final int completed;
  final int total;
  final List<MonthlyInventoryPendingProduct> completedProducts;

  MonthlyInventoryCompletedProductsResponse({
    required this.elapsedSeconds,
    required this.elapsedFormatted,
    required this.completed,
    required this.total,
    required this.completedProducts,
  });

  factory MonthlyInventoryCompletedProductsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'];

    return MonthlyInventoryCompletedProductsResponse(
      elapsedSeconds: data['elapsed_seconds'],
      elapsedFormatted: data['elapsed_formatted'],
      completed: data['completed'],
      total: data['total'],
      completedProducts: (data['completed_products'] as List<dynamic>? ?? [])
          .map((e) => MonthlyInventoryPendingProduct.fromJson(e))
          .toList(),
    );
  }

  MonthlyInventoryCompletedProductsResponse copyWith({
    int? elapsedSeconds,
    String? elapsedFormatted,
    int? completed,
    int? total,
    List<MonthlyInventoryPendingProduct>? completedProducts,
  }) {
    return MonthlyInventoryCompletedProductsResponse(
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      elapsedFormatted: elapsedFormatted ?? this.elapsedFormatted,
      completed: completed ?? this.completed,
      total: total ?? this.total,
      completedProducts: completedProducts ?? this.completedProducts,
    );
  }
}
