// import 'package:assab/core/enums/shift_status/shift_status_type.dart';
// import 'package:assab/core/extensions/build_context_extensions.dart';
// import 'package:assab/core/extensions/number_extensions.dart';
// import 'package:assab/core/routing/app_route_name.dart';
// import 'package:assab/core/styles/app_styles.dart';
// import 'package:assab/core/widgets/app_button.dart';
// import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/reassignment_entity.dart';
// import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
// import 'package:assab/generated/l10n.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../../../../../core/styles/app_colors.dart';
// import '../../../../../../../core/services/navigation/navigation_service.dart';
//
//
// extension ShiftStatusUiMapper on ShiftStatusType {
//   String get label {
//     switch (this) {
//       case ShiftStatusType.pending:
//         return S.current.not_started;
//       case ShiftStatusType.completed:
//         return S.current.completed_name;
//       case ShiftStatusType.inProgress:
//         return S.current.in_progress_name;
//       case ShiftStatusType.reassigned:
//         return S.current.shiftReassigned;
//       default:
//         return '';
//     }
//   }
//
//   Color cardColor(BuildContext context) {
//     switch (this) {
//       case ShiftStatusType.pending:
//         return context.theme.scaffoldBackgroundColor;
//       case ShiftStatusType.completed:
//         return context.theme.scaffoldBackgroundColor;
//       case ShiftStatusType.inProgress:
//         return context.theme.scaffoldBackgroundColor;
//       case ShiftStatusType.reassigned:
//         return context.theme.scaffoldBackgroundColor;
//       default:
//         return context.theme.scaffoldBackgroundColor;
//     }
//   }
//
//   Color textColor(BuildContext context) {
//     switch (this) {
//       case ShiftStatusType.pending:
//         return context.customColor.text1;
//       case ShiftStatusType.completed:
//         return AppColors.darkGreen;
//       case ShiftStatusType.inProgress:
//         return AppColors.cyan;
//       case ShiftStatusType.reassigned:
//         return AppColors.dark2Yellow;
//       default:
//         return context.theme.scaffoldBackgroundColor;
//     }
//   }
//
//   Widget shiftDetailsAppButton(
//       BuildContext context, {
//         ShiftEntity? shift,
//         required String shiftId,
//         bool hasStarted = false,
//         ReassignmentEntity? reassignmentEntity,
//         ShiftCashierEntity? cashierEntity,
//       }) {
//     switch (this) {
//       case ShiftStatusType.pending:
//         return AppButton(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//           borderRadius: BorderRadius.circular(25.r),
//           // isTransparent: true,
//           textColor: context.customColor.text2,
//           enabled: true,
//           background: AppColors.primaryLight,
//           onClick: () {
//
//             NavigationService.I.replaceWithNamed(AppRouteName.reassignShiftWithoutHandoverScreen, arguments: {
//               'shift': shift,
//               'previousCashier': shift!.cashier,
//               'nextCashier': shift.nextCashier,
//             },
//             );
//
//           },
//           text: context.tr.reassign_shift,
//         );
//
//       case ShiftStatusType.completed:
//         return AppButton(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//           borderRadius: BorderRadius.circular(25.r),
//           textColor: context.customColor.text2,
//           enabled: false,
//           onClick: () {},
//           text: context.tr.shiftCompleted,
//         );
//
//       case ShiftStatusType.inProgress:
//         return AppButton(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//           borderRadius: BorderRadius.circular(25.r),
//           isTransparent: true,
//           textColor: AppColors.red,
//           enabled: true,
//           onClick: () {},
//           text: context.tr.end_shift,
//         );
//
//       case ShiftStatusType.reassigned:
//         return Container(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//           decoration: BoxDecoration(
//             color: AppColors.darkOrange.withAlpha(1),
//             borderRadius: BorderRadius.circular(25.r),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.info_outline_rounded,
//                 color: AppColors.darkOrange,
//                 size: 15.w,
//               ),
//               10.horizontalSpace,
//
//               SizedBox(
//                 width: 240.w,
//                 child: Text(
//                   reassignmentEntity!.reassignedBy.id == cashierEntity!.id
//                       ? context.tr.reassigned_by_u
//                       : context.tr.reassigned_by_another_cashier(
//                     reassignmentEntity.reassignedBy.name,
//                   ),
//                   maxLines: 2,
//                   textAlign: TextAlign.center,
//                   style: AppStyles.s13W400.copyWith(
//                     color: context.customColor.text4,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       default:
//         return AppButton(onClick: () {}, text: 'see_details');
//     }
//   }
// }
