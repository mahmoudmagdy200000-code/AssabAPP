import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/cupertino.dart';

abstract class ItemUnitStrategy {
  String formatUnit(BuildContext context);
}

class KilogramUnitStrategy implements ItemUnitStrategy {
  @override
  String formatUnit(BuildContext context) {
    return context.tr.kg;
  }
}

class StackUnitStrategy implements ItemUnitStrategy {
  @override
  String formatUnit(BuildContext context) {
    return context.tr.sk;
  }
}

class PieceUnitStrategy implements ItemUnitStrategy {
  @override
  String formatUnit(BuildContext context) {
    return context.tr.piece;
  }
}

class LiterUnitStrategy implements ItemUnitStrategy {
  @override
  String formatUnit(BuildContext context) {
    return context.tr.liter;
  }
}

class BottleUnitStrategy implements ItemUnitStrategy {
  @override
  String formatUnit(BuildContext context) {
    return context.tr.bottle;
  }
}

class PgUnitStrategy implements ItemUnitStrategy {
  @override
  String formatUnit(BuildContext context) {
    return context.tr.pg;
  }
}
