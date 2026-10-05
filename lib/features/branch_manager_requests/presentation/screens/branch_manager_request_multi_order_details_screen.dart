import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/branch_manager_request_multi_order_details_top_section.dart';

class BranchManagerRequestMultiOrderDetailsScreen extends StatelessWidget {
  const BranchManagerRequestMultiOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          // const BranchManagerRequestDetailsAppBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  const BranchManagerRequestMultiOrderDetailsTopSection(),
                  const CustomDivider(),
                  Expanded(
                    child: BlocProvider(
                      create: (context) => PagingCubit(totalSteps: 3),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
