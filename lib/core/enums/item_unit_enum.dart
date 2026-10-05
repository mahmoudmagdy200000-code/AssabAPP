enum ItemUnitEnum {
  kg('kg'),
  sk('sk'),
  piece('piece'),
  liter('liter'),
  bottle('bottle'),
  pg('pg');

  final String value;

  const ItemUnitEnum(this.value);

  // static ItemUnitEnum fromString(String value) {
  //   return ItemUnitEnum.values.firstWhere(
  //     (e) => e.value == value,
  //     orElse: () => ItemUnitEnum.kg,
  //   );
  // }

  static String fromString(String value) {
    return value;
  }

  // static ItemUnitStrategy getStrategy(ItemUnitEnum unit) {
  //   switch (unit) {
  //     case ItemUnitEnum.kg:
  //       return KilogramUnitStrategy();
  //     case ItemUnitEnum.sk:
  //       return StackUnitStrategy();
  //     case ItemUnitEnum.piece:
  //       return PieceUnitStrategy();
  //     case ItemUnitEnum.liter:
  //       return LiterUnitStrategy();
  //     case ItemUnitEnum.bottle:
  //       return BottleUnitStrategy();
  //     case ItemUnitEnum.pg:
  //       return PgUnitStrategy();
  //   }
  // }

  static String getStrategy(String unit) {
    return unit;
  }
}
