import '../../domain/entity/check_email_entity.dart';
import '../model/add_cashier_models/check_email_response_model.dart';

extension CheckEmailMapper on CheckEmailResponseModel {
  CheckEmailDataEntity toEntity() {
    return CheckEmailDataEntity(
      email: data.email,
      isRegistered: data.registered,
      message: data.message,
    );
  }
}
