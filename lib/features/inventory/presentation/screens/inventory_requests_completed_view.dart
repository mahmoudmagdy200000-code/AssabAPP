// import 'package:flutter/material.dart';

// import '../../domain/strategies/inventory_requests_strategy.dart';

// class InventoryRequestsCompletedView extends StatefulWidget {
//   final InventoryRequestsStrategy strategy;

//   const InventoryRequestsCompletedView({super.key, required this.strategy});

//   @override
//   State<InventoryRequestsCompletedView> createState() =>
//       _InventoryRequestsCompletedViewState();
// }

// class _InventoryRequestsCompletedViewState
//     extends State<InventoryRequestsCompletedView> {
//   @override
//   void initState() {
//     super.initState();

//     _getRequests();
//   }

//   Future<void> _getRequests() async {
//     await widget.strategy.getCompletedRequests(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async => await _getRequests(),
//       child: CustomScrollView(
//         slivers: [widget.strategy.buildCompletedRequestsList(context)],
//       ),
//     );
//   }
// }
