// import 'package:flutter/material.dart';

// import '../../domain/strategies/inventory_requests_strategy.dart';

// class InventoryRequestsPendingYourConfirmationView extends StatefulWidget {
//   final InventoryRequestsStrategy strategy;

//   const InventoryRequestsPendingYourConfirmationView({
//     super.key,
//     required this.strategy,
//   });

//   @override
//   State<InventoryRequestsPendingYourConfirmationView> createState() =>
//       _InventoryRequestsPendingYourConfirmationViewState();
// }

// class _InventoryRequestsPendingYourConfirmationViewState
//     extends State<InventoryRequestsPendingYourConfirmationView> {
//   @override
//   void initState() {
//     super.initState();

//     _getRequests();
//   }

//   Future<void> _getRequests() async {
//     await widget.strategy.getPendingYourConfirmationRequests(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async => await _getRequests(),
//       child: CustomScrollView(
//         slivers: [
//           widget.strategy.buildPendingYourConfirmationRequestsList(context),
//         ],
//       ),
//     );
//   }
// }
