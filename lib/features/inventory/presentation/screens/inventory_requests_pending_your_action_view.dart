// import 'package:flutter/material.dart';

// import '../../domain/strategies/inventory_requests_strategy.dart';

// class InventoryRequestsPendingYourActionView extends StatefulWidget {
//   final InventoryRequestsStrategy strategy;

//   const InventoryRequestsPendingYourActionView({
//     super.key,
//     required this.strategy,
//   });

//   @override
//   State<InventoryRequestsPendingYourActionView> createState() =>
//       _InventoryRequestsPendingYourActionViewState();
// }

// class _InventoryRequestsPendingYourActionViewState
//     extends State<InventoryRequestsPendingYourActionView> {
//   @override
//   void initState() {
//     super.initState();

//     _getRequests();
//   }

//   Future<void> _getRequests() async {
//     await widget.strategy.getPendingYourActionRequests(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async => await _getRequests(),
//       child: CustomScrollView(
//         slivers: [widget.strategy.buildPendingYourActionRequestsList(context)],
//       ),
//     );
//   }
// }
