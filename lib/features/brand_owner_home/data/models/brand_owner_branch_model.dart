class BrandOwnerBranchModel {
  final List<BrandOwnerBranchItemDashboard> branches;

  const BrandOwnerBranchModel({required this.branches});

  factory BrandOwnerBranchModel.fromJson(Map<String, dynamic> json) {
    return BrandOwnerBranchModel(
      branches: (json['data'] as List<dynamic>? ?? [])
          .map(
            (item) => BrandOwnerBranchItemDashboard.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}

class BrandOwnerBranchItemDashboard {
  final String id;
  final String name;
  final String? imageUrl;
  final String? openingHours;
  final String? googleMapUrl;

  const BrandOwnerBranchItemDashboard({
    required this.id,
    required this.name,
    this.imageUrl,
    this.openingHours,
    this.googleMapUrl,
  });

  factory BrandOwnerBranchItemDashboard.fromJson(Map<String, dynamic> json) {
    return BrandOwnerBranchItemDashboard(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      openingHours: json['opening_hours'] as String?,
      googleMapUrl: json['google_map_url'] as String?,
    );
  }

  static List<BrandOwnerBranchItemDashboard> mock() => const [
    BrandOwnerBranchItemDashboard(
      id: '1',
      name: 'Jahez Store',
      imageUrl: 'https://example.com/branch1.jpg',
      openingHours: 'Mon - Fri / 9Am - 8Pm',
      googleMapUrl: '',
    ),
    BrandOwnerBranchItemDashboard(
      id: '2',
      name: 'Riyadh Park Branch',
      imageUrl: 'https://example.com/branch2.jpg',
      openingHours: 'Sat - Thu / 10Am - 10Pm',
      googleMapUrl: '',
    ),
    BrandOwnerBranchItemDashboard(
      id: '3',
      name: 'Mall of Arabia',
      imageUrl: 'https://example.com/branch3.jpg',
      openingHours: 'Daily / 9Am - 11Pm',
      googleMapUrl: '',
    ),
    BrandOwnerBranchItemDashboard(
      id: '4',
      name: 'Downtown Branch',
      imageUrl: 'https://example.com/branch4.jpg',
      openingHours: 'Mon - Sat / 8Am - 9Pm',
      googleMapUrl: '',
    ),
    BrandOwnerBranchItemDashboard(
      id: '5',
      name: 'Airport Road Branch',
      imageUrl: 'https://example.com/branch5.jpg',
      openingHours: 'Daily / 7Am - 12Am',
      googleMapUrl: '',
    ),
  ];
}
