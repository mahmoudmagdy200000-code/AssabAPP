import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../domain/strategies/expenses_strategy.dart';
import '../cubit/create_expense_previous_request/create_expense_previous_request_cubit.dart';

class ReusePastRequestBottomSheetWidget extends StatefulWidget {
  final ExpensesStrategy expensesStrategy;

  const ReusePastRequestBottomSheetWidget({
    super.key,
    required this.expensesStrategy,
  });

  @override
  State<ReusePastRequestBottomSheetWidget> createState() =>
      _ReusePastRequestBottomSheetWidgetState();
}

class _ReusePastRequestBottomSheetWidgetState
    extends State<ReusePastRequestBottomSheetWidget> {
  late final ScrollController _scrollController;
  late final ValueNotifier<int?> _selectedInvoice;

  @override
  void initState() {
    _scrollController = ScrollController();
    _selectedInvoice = ValueNotifier<int?>(null);
    _getPastRequests();
    _scrollController.addListener(_scrollControllerListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollControllerListener);

    _selectedInvoice.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollControllerListener() {
    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200.r) {
      if (widget.expensesStrategy.pastRequestsHasMore(context)) {
        _getPastRequests(loadMore: true);
      }
    }
  }

  void _getPastRequests({bool loadMore = false}) {
    widget.expensesStrategy.getPastRequests(context, loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.pastRequest,
            style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
          ),
          12.verticalSpace,
          Text(
            context.tr.pastRequestDesc,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          14.verticalSpace,
          const CustomDivider(),
          20.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppSvg(assetName: AppAssets.search),
              10.horizontalSpace,
              Expanded(
                child: CustomTextField(
                  hintText: context.tr.searchForPreApprovalRequests,
                  onChanged: (value) {
                    widget.expensesStrategy.searchPastRequests(context, value);
                  },
                ),
              ),
            ],
          ),
          14.verticalSpace,
          const CustomDivider(),
          14.verticalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.text2,
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.all(10.r),
              child: widget.expensesStrategy.reusePastRequestWidget(
                _scrollController,
                _selectedInvoice,
              ),
            ),
          ),
          14.verticalSpace,
          ValueListenableBuilder(
            valueListenable: _selectedInvoice,
            builder: (context, value, child) {
              return BlocConsumer<
                CreateExpensePreviousRequestCubit,
                CreateExpensePreviousRequestState
              >(
                listener: (context, state) {
                  if (state is CreateExpensePreviousRequestFailure) {
                    AppDialog.showErrorDialog(
                      context: context,
                      failure: state.failure,
                    );
                  } else if (state is CreateExpensePreviousRequestSuccess) {
                    NavigationService.I.pop();
                    NavigationService.I.pop();
                  }
                },
                builder: (context, state) {
                  if (state is CreateExpensePreviousRequestLoading) {
                    return const AppButtonLoading();
                  }

                  return AppButton(
                    onClick: () {
                      widget.expensesStrategy.createPastRequests(context);
                    },
                    enabled: value != null,
                    text: context.tr.confirmSelection,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
