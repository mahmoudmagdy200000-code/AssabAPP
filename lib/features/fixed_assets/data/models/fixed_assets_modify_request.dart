import 'dart:io';
import 'package:dio/dio.dart';

class FixedAssetsModifyRequest {
  final String assetId;
  final String newStatus;
  final String reason;
  final File attachment;
  final List<String> doneActions;
  final String nextAction;
  final String approvalRequestOwnerNote;

  FixedAssetsModifyRequest({
    required this.assetId,
    required this.newStatus,
    required this.reason,
    required this.attachment,
    required this.doneActions,
    required this.nextAction,
    required this.approvalRequestOwnerNote,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('asset_id', assetId),
      MapEntry('new_status', newStatus),
      MapEntry('reason', reason),
      MapEntry('next_action', nextAction),
      MapEntry('approval_request_owner_note', approvalRequestOwnerNote),
    ]);

    for (final action in doneActions) {
      formData.fields.add(MapEntry('done_actions[]', action));
    }

    formData.files.add(
      MapEntry(
        'attachment',
        await MultipartFile.fromFile(
          attachment.path,
          filename: attachment.path.split('/').last,
        ),
      ),
    );

    return formData;
  }
}
