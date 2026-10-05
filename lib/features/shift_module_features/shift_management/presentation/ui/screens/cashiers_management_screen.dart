import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashiers_management/cashiers_bottom_section_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/search/search_cubit.dart';
import '../../../domain/entity/cashier_entity.dart';
import '../../logic/cashier/cashier_management_cubit.dart';
import '../widgets/shift_management_app_bar.dart';

class CashiersManagementScreen extends StatefulWidget {
  const CashiersManagementScreen({super.key});

  @override
  State<CashiersManagementScreen> createState() =>
      _CashiersManagementScreenState();
}

class _CashiersManagementScreenState extends State<CashiersManagementScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
    searchController = TextEditingController();

    context.read<CashierManagementCubit>().getCashiers();
  }

  void _onScroll() {
    final cubit = context.read<CashierManagementCubit>();

    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 400.h) {
      if (cubit.hasMore) {
        context.read<CashierManagementCubit>().getCashiers(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          ShiftManagementAppBar(
            searchController: searchController,
            onSearch: (value) {
              context.read<SearchCubit<CashierEntity>>().search(
                value,
                (cashier, q) =>
                    cashier.name.toLowerCase().contains(q.toLowerCase()),
              );
            },
          ),

          Expanded(
            child: CashiersBottomSectionWidget(
              scrollController: _scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
