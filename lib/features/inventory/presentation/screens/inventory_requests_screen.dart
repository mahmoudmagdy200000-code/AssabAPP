import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../domain/strategies/inventory_requests_strategy.dart';
import '../cubit/get_inventory_requests/get_inventory_requests_cubit.dart';

class InventoryRequestsScreen extends StatelessWidget {
  const InventoryRequestsScreen({super.key, required this.strategy});

  final InventoryRequestsStrategy strategy;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GetInventoryRequestsCubit>(),
      child: _InventoryRequestsScreen(strategy: strategy),
    );
  }
}

class _InventoryRequestsScreen extends StatefulWidget {
  final InventoryRequestsStrategy strategy;

  const _InventoryRequestsScreen({super.key, required this.strategy});

  @override
  State<_InventoryRequestsScreen> createState() =>
      _InventoryRequestsScreenState();
}

class _InventoryRequestsScreenState extends State<_InventoryRequestsScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    widget.strategy.getRequests(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            _buildTitleCard(context),
            10.verticalSpace,
            Row(
              spacing: 10.w,
              children: List.generate(3, (index) {
                final isSelected = index == _selectedTabIndex;

                final texts = [
                  context.tr.all,
                  context.tr.inProgress,
                  context.tr.completed,
                ];

                return Expanded(
                  child: CustomTextButton(
                    text: texts[index],
                    onTap: () {
                      setState(() => _selectedTabIndex = index);
                    },
                    backgroundColor: Colors.transparent,
                    textColor: isSelected
                        ? context.theme.primaryColor
                        : context.customColor.text3,
                    borderRadius: 1000.r,
                    borderColor: isSelected
                        ? context.theme.primaryColor
                        : context.customColor.border,
                  ),
                );
              }),
            ),
            10.verticalSpace,
            Expanded(
              child: Column(
                children: [
                  widget.strategy.buildDailyInventoryTopSection(context),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => widget.strategy.getRequests(context),
                      child: widget.strategy.buildRequestsList(
                        context,
                        selectedTabIndex: _selectedTabIndex,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleCard(BuildContext context) {
    return Row(
      children: [
        const AppBackButton(),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.strategy.title(context, count: '0'),
                style: AppStyles.s16W600.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              6.verticalSpace,
              Text(
                context.tr.manageAllYourPendingDraftRecords,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
