// class ExpensesRegistry {
//   static final Map<String, ExpensesStrategy Function()> _strategies = {};

//   static void register(String type, ExpensesStrategy Function() creator) {
//     _strategies[type] = creator;
//   }

//   static ExpensesStrategy fromType(String type) {
//     final creator = _strategies[type];

//     if (creator == null) {
//       throw Exception('Unknown expense type: $type');
//     }

//     return creator();
//   }
// }
