class StartMonthlyInventoryRequest {
  final String inventoryDate;
  final List<String?> staff;

  StartMonthlyInventoryRequest({
    required this.inventoryDate,
    required this.staff,
  });

  Map<String, dynamic> toJson() {
    return {
      'inventory_date': inventoryDate,
      if (staff.isNotEmpty) 'staff': staff,
    };
  }
}
