import 'package:assab/features/cashier_home/data/models/cashier_branch_info_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('preserves populated branch details returned by the API', () {
    final response = CashierBranchInfoResponse.fromJson({
      'data': {
        'id': 'branch-1',
        'name': 'Branch [HARNESS]',
        'image': 'https://example.test/branch.png',
        'location': 'Riyadh',
        'lat': 24,
        'lng': 46.7,
        'opening_hours': '08:00 AM',
        'closing_hours': '11:00 PM',
        'google_maps_url': 'https://example.test/map',
        'branch_manager': {
          'id': 'manager-1',
          'name': 'Manager [HARNESS]',
          'image': null,
        },
      },
    });

    expect(response.lat, 24.0);
    expect(response.lng, 46.7);
    expect(response.branchManager?.name, 'Manager [HARNESS]');
  });

  test('accepts nullable branch detail fields returned by the API', () {
    final response = CashierBranchInfoResponse.fromJson({
      'data': {
        'id': 'branch-1',
        'name': 'Branch [HARNESS]',
        'image': null,
        'location': null,
        'lat': null,
        'lng': null,
        'opening_hours': null,
        'closing_hours': null,
        'google_maps_url': null,
        'branch_manager': null,
      },
    });

    expect(response.name, 'Branch [HARNESS]');
    expect(response.image, isNull);
    expect(response.branchManager, isNull);
  });

  test('accepts a bare branch object without inventing a manager', () {
    final response = CashierBranchInfoResponse.fromJson({
      'id': 'branch-2',
      'name': 'Branch 2',
      'branch_manager': null,
    });

    expect(response.id, 'branch-2');
    expect(response.branchManager, isNull);
    expect(response.lat, isNull);
    expect(response.openingHours, isNull);
  });

  test('handles missing and unexpected optional values without crashing', () {
    final response = CashierBranchInfoResponse.fromJson({
      'data': {
        'id': null,
        'name': null,
        'lat': 'invalid',
        'image': 123,
        'branch_manager': 'invalid',
      },
    });

    expect(response.id, isEmpty);
    expect(response.name, '-');
    expect(response.lat, isNull);
    expect(response.image, isNull);
    expect(response.branchManager, isNull);
  });

  test('omits an incomplete manager instead of inventing an ID', () {
    final response = CashierBranchInfoResponse.fromJson({
      'data': {
        'id': 'branch-3',
        'name': 'Branch 3',
        'branch_manager': {'name': 'Manager', 'image': 4},
      },
    });

    expect(response.branchManager, isNull);
  });
}
