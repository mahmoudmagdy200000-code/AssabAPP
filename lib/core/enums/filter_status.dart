import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';

enum FilterStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  non('');

  final String _key;

  const FilterStatus(this._key);

  String get key => _key;

  String getDisplayName(BuildContext context) {
    switch (this) {
      case FilterStatus.pending:
        return context.tr.pending;
      case FilterStatus.approved:
        return context.tr.approved;
      case FilterStatus.rejected:
        return context.tr.rejected;
      case FilterStatus.non:
        return '';
    }
  }
}
