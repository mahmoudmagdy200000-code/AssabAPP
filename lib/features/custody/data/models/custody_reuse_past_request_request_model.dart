import 'package:dio/dio.dart';

class CustodyReusePastRequestRequestModel {
  final String pastRequestId;

  CustodyReusePastRequestRequestModel({required this.pastRequestId});

  FormData toFormData() {
    return FormData.fromMap({'reuseRequestId': pastRequestId});
  }
}
