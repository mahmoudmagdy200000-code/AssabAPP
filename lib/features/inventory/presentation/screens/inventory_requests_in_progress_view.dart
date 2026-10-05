// import 'package:flutter/material.dart';

// import '../../domain/strategies/inventory_requests_strategy.dart';

// class InventoryRequestsInProgressView extends StatefulWidget {
//   final InventoryRequestsStrategy strategy;

//   const InventoryRequestsInProgressView({super.key, required this.strategy});

//   @override
//   State<InventoryRequestsInProgressView> createState() =>
//       _InventoryRequestsInProgressViewState();
// }

// class _InventoryRequestsInProgressViewState
//     extends State<InventoryRequestsInProgressView> {
//   @override
//   void initState() {
//     super.initState();

//     _getRequests();
//   }

//   Future<void> _getRequests() async {
//     await widget.strategy.getPendingRequests(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async => await _getRequests(),
//       child: CustomScrollView(
//         slivers: [
//           widget.strategy.buildDailyInventoryTopSection(context),
//           widget.strategy.buildPendingRequestsList(context),
//         ],
//       ),
//     );
//   }
// }
