import 'package:assab/core/enums/auth_type.dart';

class VerifyOtpArguments {
  final AuthType type;
  final String identifier;

  VerifyOtpArguments({required this.type, required this.identifier});
}
