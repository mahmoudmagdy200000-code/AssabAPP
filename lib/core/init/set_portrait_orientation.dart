import 'package:flutter/services.dart';

Future<void> setPortraitOrientation() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
