import 'package:assab/features/shift_module_features/shift_management/data/model/get_all_cashiers_and_managers_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FL-05: BranchManager with null phone and null createdAt deserializes correctly', () {
    final json = {
      'success': true,
      'message': 'OK',
      'data': {
        'branch_managers': [
          {
            'id': 'mgr-uuid-1',
            'name': 'Branch Manager 1',
            'email': 'manager@test.com',
            'phone': null, // NULL phone from DB migration
            'image': null,
            'branch': {
              'id': 'b-1',
              'name': 'Main Branch',
              'location': 'Riyadh',
              'image': null,
            },
            'status': {'value': 'active'},
            'is_active': true,
            'is_first_login': false,
            'email_verified': null,
            'phone_verified': null,
            'created_at': null,
          }
        ],
        'cashiers': [],
      },
      'meta': {
        'total': 1,
        'per_page': 10,
        'current_page': 1,
        'last_page': 1,
      },
    };

    final response = GetAllCashiersAndManagersResponse.fromJson(json);
    expect(response.success, isTrue);
    expect(response.data.branchManagers.length, equals(1));
    final mgr = response.data.branchManagers.first;
    expect(mgr.name, equals('Branch Manager 1'));
    expect(mgr.phone, isNull);
    expect(mgr.createdAt, isNull);
    expect(mgr.emailVerified, isFalse);
    expect(mgr.phoneVerified, isFalse);
  });
}
