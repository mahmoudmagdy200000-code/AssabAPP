import 'package:flutter_test/flutter_test.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/available_recipients_response_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/cashier_model.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/handover_user_item.dart';

void main() {
  group('FL-06: AvailableRecipientsResponseModel & HandoverUserItem tests', () {
    test('deserializes JSON response with eligible, disabled, and suggested recipients', () {
      final json = {
        'success': true,
        'message': 'Available recipients retrieved',
        'data': {
          'auto_handover_enabled': true,
          'has_branch_manager': true,
          'recipients': [
            {
              'id': 1,
              'name': 'Ahmed Cashier',
              'type': 'cashier',
              'is_available': true,
              'disabled': false,
              'is_suggested': true,
              'suggestion_reason': 'Next scheduled cashier',
            },
            {
              'id': 2,
              'name': 'Inactive User',
              'type': 'cashier',
              'is_available': false,
              'disabled': true,
              'reason_disabled': 'User is deactivated',
              'is_suggested': false,
            },
            {
              'id': 3,
              'name': 'Other Branch User',
              'type': 'cashier',
              'is_available': false,
              'disabled': true,
              'reason_disabled': 'Belongs to different branch',
              'is_suggested': false,
            }
          ]
        }
      };

      final response = AvailableRecipientsResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, equals('Available recipients retrieved'));
      expect(response.data.autoHandoverEnabled, isTrue);
      expect(response.data.hasBranchManager, isTrue);
      expect(response.data.recipients.length, equals(3));

      final r1 = response.data.recipients[0];
      expect(r1.id, equals('1'));
      expect(r1.name, equals('Ahmed Cashier'));
      expect(r1.disabled, isFalse);
      expect(r1.isSuggested, isTrue);
      expect(r1.suggestionReason, equals('Next scheduled cashier'));

      final r2 = response.data.recipients[1];
      expect(r2.id, equals('2'));
      expect(r2.disabled, isTrue);
      expect(r2.reasonDisabled, equals('User is deactivated'));

      final r3 = response.data.recipients[2];
      expect(r3.id, equals('3'));
      expect(r3.disabled, isTrue);
      expect(r3.reasonDisabled, equals('Belongs to different branch'));
    });

    test('tolerates missing optional fields without throwing FormatException', () {
      final minimalJson = {
        'success': true,
        'data': {
          'recipients': [
            {
              'id': 42,
              'name': 'Minimal Cashier',
            }
          ]
        }
      };

      final response = AvailableRecipientsResponseModel.fromJson(minimalJson);
      expect(response.success, isTrue);
      expect(response.data.recipients.length, equals(1));

      final item = response.data.recipients.first;
      expect(item.id, equals('42'));
      expect(item.name, equals('Minimal Cashier'));
      expect(item.disabled, isFalse);
      expect(item.isSuggested, isFalse);
      expect(item.suggestionReason, isNull);
      expect(item.reasonDisabled, isNull);
    });

    test('HandoverUserItem correctly encapsulates disabled selection state', () {
      final activeItem = HandoverUserItem(
        id: '1',
        name: 'Active Cashier',
        branchName: 'Riyadh Branch',
        status: CashierStatus.active,
        isManager: false,
        disabled: false,
        isSuggested: true,
        suggestionReason: 'Next on duty',
      );

      final disabledItem = HandoverUserItem(
        id: '2',
        name: 'Inactive Cashier',
        branchName: 'Riyadh Branch',
        status: CashierStatus.deactivated,
        isManager: false,
        disabled: true,
        reasonDisabled: 'Deactivated account',
      );

      expect(activeItem.disabled, isFalse);
      expect(activeItem.isSuggested, isTrue);
      expect(disabledItem.disabled, isTrue);
      expect(disabledItem.reasonDisabled, equals('Deactivated account'));
    });
  });
}
