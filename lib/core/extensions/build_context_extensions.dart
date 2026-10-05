import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../theme/custom_colors.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  S get tr => S.of(this);

  Object? get arguments => ModalRoute.of(this)!.settings.arguments;

  CustomColors get customColor => Theme.of(this).extension<CustomColors>()!;
}
