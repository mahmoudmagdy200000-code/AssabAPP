// import '../../../domain/entity/shift/reassignment_entity.dart';
// import '../../../domain/entity/shift/shift_cashier_entity.dart';
// import '../../../domain/entity/shift/shift_entity.dart';
// import '../../model/shift/shift_details/shift_details_model.dart';
//
// extension ShiftDetailsResponseMapper on ShiftDetailsResponseModel {
//   ShiftEntity toEntity() {
//     return ShiftEntity(
//       id: id,
//       shiftDate: shiftDate,
//       shift: ShiftDetailsEntity(
//         startTime: shift.startTime,
//         endTime: shift.endTime,
//       ),
//       openingBalance: openingBalance,
//       closingBalance: closingBalance,
//       vatAmount: vatAmount,
//       cashCollected: cashCollected,
//       status: status,
//       cashier: ShiftCashierEntity(
//         id: cashier.id.toString(),
//         name: cashier.name,
//       ),
//       nextCashier: nextCashier != null
//           ? ShiftCashierEntity(
//         id: nextCashier!.id.toString(),
//         name: nextCashier!.name,
//       )
//           : null,
//       reassignment: reassignment != null
//           ? ReassignmentEntity(
//         reassignedFrom: ShiftCashierEntity(
//           id: reassignment!.reassignedFrom.id.toString(),
//           name: reassignment!.reassignedFrom.name,
//         ),
//         reassignedBy: ShiftCashierEntity(
//           id: reassignment!.reassignedBy.id.toString(),
//           name: reassignment!.reassignedBy.name,
//         ),
//         reassignedTo: ShiftCashierEntity(
//           id: reassignment!.reassignedTo.id.toString(),
//           name: reassignment!.reassignedTo.name,
//         ),
//       )
//           : null,
//     );
//   }
// }
