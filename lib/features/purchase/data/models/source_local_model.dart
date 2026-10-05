import '../../../../core/enums/purchase_sources_types.dart';

class SourceLocalModel {
  final Set<String> mainIds;
  final String sourceId;
  final String sourceName;
  final List<String> choosedItemSourceIds;
  final PurchaseSourcesTypes type;
  final List<String> requestedQty;

  const SourceLocalModel({
    required this.mainIds,
    required this.sourceId,
    required this.sourceName,
    required this.choosedItemSourceIds,
    required this.type,
    required this.requestedQty,
  });

  SourceLocalModel copyWith({
    Set<String>? mainIds,
    String? sourceId,
    String? sourceName,
    List<String>? choosedItemSourceIds,
    PurchaseSourcesTypes? type,
    List<String>? requestedQty,
  }) {
    return SourceLocalModel(
      mainIds: mainIds ?? this.mainIds,
      sourceId: sourceId ?? this.sourceId,
      sourceName: sourceName ?? this.sourceName,
      choosedItemSourceIds: choosedItemSourceIds ?? this.choosedItemSourceIds,
      type: type ?? this.type,
      requestedQty: requestedQty ?? this.requestedQty,
    );
  }
}
