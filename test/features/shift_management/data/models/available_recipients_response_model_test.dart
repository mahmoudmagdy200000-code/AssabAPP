import 'package:flutter_test/flutter_test.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/available_recipients_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/cashier_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/handover_user_item.dart';

void main() {
  group('FL-06: AvailableRecipientsResponseModel Fail-Closed & Eligibility Tests', () {
    test('deserializes explicitly eligible recipient correctly', () {
      final json = {
        'id': '10',
        'name': 'Ahmed Cashier',
        'type': 'cashier',
        'is_available': true,
        'disabled': false,
        'is_suggested': true,
        'suggestion_reason': 'Next scheduled cashier',
      };

      final model = RecipientItemModel.fromJson(json);

      expect(model.id, equals('10'));
      expect(model.name, equals('Ahmed Cashier'));
      expect(model.isAvailable, isTrue);
      expect(model.disabled, isFalse);
      expect(model.reasonDisabled, isNull);
      expect(model.isSuggested, isTrue);
    });

    test('FAIL-CLOSED: Missing is_available marks recipient disabled (not selectable)', () {
      final json = {
        'id': '11',
        'name': 'Unknown Status Cashier',
        'type': 'cashier',
        // is_available is omitted
      };

      final model = RecipientItemModel.fromJson(json);

      expect(model.isAvailable, isFalse, reason: 'Fail-closed: missing availability must not be assumed eligible');
      expect(model.disabled, isTrue);
      expect(model.reasonDisabled, contains('unavailable'));
    });

    test('FAIL-CLOSED: Missing disabled field does not fail open without explicit is_available', () {
      final json = {
        'id': '12',
        'name': 'Candidate Cashier',
        'type': 'cashier',
        'is_available': false,
        // disabled is omitted
      };

      final model = RecipientItemModel.fromJson(json);

      expect(model.isAvailable, isFalse);
      expect(model.disabled, isTrue);
    });

    test('FAIL-CLOSED: Invalid or empty ID marks recipient disabled', () {
      final invalidIds = ['', '0', 'null'];

      for (final id in invalidIds) {
        final json = {
          'id': id,
          'name': 'Corrupt Cashier',
          'type': 'cashier',
          'is_available': true,
        };

        final model = RecipientItemModel.fromJson(json);

        expect(model.isAvailable, isFalse);
        expect(model.disabled, isTrue);
        expect(model.reasonDisabled, contains('Invalid recipient ID'));
      }
    });

    test('FAIL-CLOSED: Malformed or unrecognized recipient type marks recipient disabled', () {
      final json = {
        'id': '15',
        'name': 'Super Admin',
        'type': 'external_guest', // unapproved role
        'is_available': true,
      };

      final model = RecipientItemModel.fromJson(json);

      expect(model.isAvailable, isFalse);
      expect(model.disabled, isTrue);
      expect(model.reasonDisabled, contains('Unknown recipient type'));
    });

    test('Full payload deserialization parses collection with fail-closed protections', () {
      final payload = {
        'success': true,
        'message': 'Recipients list',
        'data': {
          'auto_handover_enabled': true,
          'has_branch_manager': false,
          'recipients': [
            {
              'id': 1,
              'name': 'Eligible Cashier',
              'type': 'cashier',
              'is_available': true,
              'disabled': false,
            },
            {
              'id': 2,
              'name': 'Missing Availability Cashier',
              'type': 'cashier',
            },
            {
              'id': null,
              'name': 'Null ID Cashier',
              'type': 'cashier',
              'is_available': true,
            }
          ]
        }
      };

      final response = AvailableRecipientsResponseModel.fromJson(payload);
      expect(response.success, isTrue);
      expect(response.data.recipients.length, equals(3));

      // First is eligible
      expect(response.data.recipients[0].disabled, isFalse);
      expect(response.data.recipients[0].isAvailable, isTrue);

      // Second fails closed due to missing availability
      expect(response.data.recipients[1].disabled, isTrue);
      expect(response.data.recipients[1].isAvailable, isFalse);

      // Third fails closed due to null ID
      expect(response.data.recipients[2].disabled, isTrue);
      expect(response.data.recipients[2].isAvailable, isFalse);
    });

    test('HandoverUserItem preserves disabled barrier preventing selection', () {
      final disabledItem = HandoverUserItem(
        id: '2',
        name: 'Deactivated User',
        branchName: 'Main Branch',
        status: CashierStatus.deactivated,
        isManager: false,
        disabled: true,
        reasonDisabled: 'Account suspended',
      );

      expect(disabledItem.disabled, isTrue);
      expect(disabledItem.reasonDisabled, equals('Account suspended'));
    });
  });
}
