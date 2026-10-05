class AggregatorEntity {
  final String id;
  final String name;
  final String code;
  final String logo;
  final String description;
  final double commissionRate;
  final String commissionPercentage;
  final AggregatorStatusEntity status;
  final String integrationType;
  final bool hasIntegration;
  final int branchesCount;
  final int enabledBranchesCount;
  final String createdAt;
  final double? totalAmount;
  final String? notes;

  const AggregatorEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.logo,
    required this.description,
    required this.commissionRate,
    required this.commissionPercentage,
    required this.status,
    required this.integrationType,
    required this.hasIntegration,
    required this.branchesCount,
    required this.enabledBranchesCount,
    required this.createdAt,
    this.totalAmount,
    this.notes,
  });

  AggregatorEntity copyWith({
    String? id,
    String? name,
    String? code,
    String? logo,
    String? description,
    double? commissionRate,
    String? commissionPercentage,
    AggregatorStatusEntity? status,
    String? integrationType,
    bool? hasIntegration,
    int? branchesCount,
    int? enabledBranchesCount,
    String? createdAt,
    double? totalAmount,
    String? notes,
  }) {
    return AggregatorEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      commissionRate: commissionRate ?? this.commissionRate,
      commissionPercentage: commissionPercentage ?? this.commissionPercentage,
      status: status ?? this.status,
      integrationType: integrationType ?? this.integrationType,
      hasIntegration: hasIntegration ?? this.hasIntegration,
      branchesCount: branchesCount ?? this.branchesCount,
      enabledBranchesCount: enabledBranchesCount ?? this.enabledBranchesCount,
      createdAt: createdAt ?? this.createdAt,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
    );
  }
}

class AggregatorStatusEntity {
  final bool value;
  final String label;
  final String color;

  const AggregatorStatusEntity({
    required this.value,
    required this.label,
    required this.color,
  });
}

// domain/entities/aggregators_response_entity.dart
class AggregatorsResponseEntity {
  final bool success;
  final String message;
  final List<AggregatorEntity> data;
  final LinksEntity links;
  final MetaEntity meta;

  const AggregatorsResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.links,
    required this.meta,
  });
}

class LinksEntity {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const LinksEntity({this.first, this.last, this.prev, this.next});
}

class MetaEntity {
  final int currentPage;
  final int from;
  final int lastPage;
  final List<MetaLinkEntity> links;
  final String path;
  final int perPage;
  final int to;
  final int total;

  const MetaEntity({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });
}

class MetaLinkEntity {
  final String? url;
  final String label;
  final bool active;

  const MetaLinkEntity({this.url, required this.label, required this.active});
}
