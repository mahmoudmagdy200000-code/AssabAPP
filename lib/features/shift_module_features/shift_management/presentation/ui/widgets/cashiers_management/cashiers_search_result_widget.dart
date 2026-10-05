import 'package:assab/features/shift_module_features/shift_management/domain/entity/enums/date_filter_options.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/cashier/cashier_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../logic/cashier/cashier_filter/cashier_filter_cubit.dart';
import 'cashiers_bottom_section_widget.dart';
import 'cashiers_search_app_bar.dart';

class CashiersSearchResultWidget extends StatefulWidget {
  const CashiersSearchResultWidget({super.key});

  @override
  State<CashiersSearchResultWidget> createState() =>
      _CashiersSearchResultWidgetState();
}

class _CashiersSearchResultWidgetState
    extends State<CashiersSearchResultWidget> {
  late final ScrollController _scrollController;

  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _fetchNextPage();
    }
  }

  void _fetchNextPage() {
    _isFetching = true;
    final cubit = context.read<CashierFilterCubit>();
    context.read<CashierManagementCubit>().getCashiers(
      dateOption: cubit.state.dateFilter?.dateOption.apiKey,
      status: cubit.state.statusFilter?.apiValue,
      loadMore: true,
    );

    _isFetching = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Container(
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          children: [
            const CashiersSearchAppBar(),
            10.verticalSpace,
            Expanded(
              child: CashiersBottomSectionWidget(
                isFromFilter: true,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
