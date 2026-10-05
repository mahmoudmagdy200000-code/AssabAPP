import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/features/receive_goods/presentation/screens/receive_order_inspection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../../../../core/cubits/dynamic_steps/dynamic_steps_state.dart';
import '../widgets/receive_order_screen_top_section.dart';
import 'receive_order_document_type_view.dart';
import 'receive_order_summary_view.dart';

class ReceiveOrderScreen extends StatefulWidget {
  final String orderId;

  const ReceiveOrderScreen({super.key, required this.orderId});

  @override
  State<ReceiveOrderScreen> createState() => _ReceiveOrderScreenState();
}

class _ReceiveOrderScreenState extends State<ReceiveOrderScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBaseSteps();
    });
  }

  void _initializeBaseSteps() {
    final dynamicStepsCubit = context.read<DynamicStepsCubit>();

    dynamicStepsCubit.buildSteps(
      [
        () => ReceiveOrderInspectionView(orderId: widget.orderId),
        () => BlocProvider(
          create: (context) => getIt<ChooseItemCubit>(),
          child: const ReceiveOrderDocumentTypeView(),
        ),
        () => ReceiveOrderSummaryView(orderId: widget.orderId),
      ],
      [context.tr.inspection, context.tr.documentType, context.tr.summary],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              children: [
                const AppBackButton(),
                12.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.orderFromSourcename(context.tr.directSupplier),
                      style: AppStyles.s16W600.copyWith(
                        color: context.customColor.reversedTextColor,
                      ),
                    ),
                    BlocSelector<ValidationCubit, ValidationState, String?>(
                      selector: (state) => state.fieldsValue['supplierName'],
                      builder: (context, state) {
                        return Text(
                          context.tr.receiveSuppliername(state ?? ''),
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: BlocBuilder<DynamicStepsCubit, DynamicStepsState>(
                builder: (context, dynamicState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final pagingCubit = context.read<PagingCubit>();
                    if (pagingCubit.state.totalSteps !=
                        dynamicState.totalSteps) {
                      pagingCubit.updateTotalSteps(dynamicState.totalSteps);
                    }
                  });

                  return BlocSelector<PagingCubit, PagingState, int>(
                    selector: (state) => state.currentIndex,
                    builder: (context, currentIndex) {
                      final titles = dynamicState.titles;
                      final views = dynamicState.builders
                          .map((builder) => builder())
                          .toList();

                      if (views.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReceiveOrderScreenTopSection(titles: titles),
                          12.verticalSpace,
                          Expanded(
                            child: IndexedStack(
                              index: currentIndex.clamp(0, views.length - 1),
                              children: views,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
