import 'package:flutter/cupertino.dart';

import '../../../../../core/extensions/build_context_extensions.dart';
import '../../domain/enums/user_type.dart';

extension AssignedByTypeUiMapper on UserType {
  String label(BuildContext context) {
    switch (this) {
      case UserType.manager:
        return context.tr.branchManager;

      case UserType.cashier:
        return context.tr.cashier;
    }
  }
}
