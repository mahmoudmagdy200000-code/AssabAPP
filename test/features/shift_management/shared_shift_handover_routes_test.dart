import 'package:assab/features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/hand_over_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const shiftId = 'assigned-shift';
  const sharedShiftPath = '/api/v1/branch-manager/shifts/$shiftId';

  for (final role in ['branch_manager', 'cashier']) {
    test(
      '$role can list recipients and start handover on the shared shift routes',
      () async {
        final requests = <RequestOptions>[];
        final dio = Dio(
          BaseOptions(
            baseUrl: 'https://example.test/api/v1/',
            headers: {'Authorization': 'Bearer test-$role'},
          ),
        );
        addTearDown(dio.close);
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              requests.add(options);
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'message': 'OK',
                    'data': {
                      'recipients': [
                        {
                          'id': 'next-cashier',
                          'name': 'Next cashier',
                          'type': 'cashier',
                          'is_available': true,
                        },
                      ],
                    },
                  },
                ),
              );
            },
          ),
        );
        final source = ShiftManagementRemoteDataSource(dio);

        final recipients = await source.getAvailableRecipients(
          shiftId: shiftId,
        );
        expect(recipients.data.recipients.single.id, 'next-cashier');

        await source.handOver(
          shiftId: shiftId,
          handOverRequest: HandOverRequest(
            handoverType: 'cashier',
            nextCashierId: 'next-cashier',
            handOverAmount: 95,
          ),
        );

        expect(requests.map((request) => request.uri.path), [
          '$sharedShiftPath/available-recipients',
          '$sharedShiftPath/start-handover',
        ]);
        expect(requests.map((request) => request.method), ['GET', 'POST']);
        expect(
          requests.map((request) => request.headers['Authorization']),
          everyElement('Bearer test-$role'),
        );
        expect(
          requests.last.data,
          containsPair('next_cashier_id', 'next-cashier'),
        );
      },
    );
  }
}
