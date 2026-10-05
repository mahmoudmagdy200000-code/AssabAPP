import 'package:assab/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/extensions/number_extensions.dart';
import '../cubit/fixed_assets_search/fixed_assets_search_cubit.dart';
import '../widgets/fixed_assets_search_header_widget.dart';
import '../widgets/fixed_assets_search_bar_widget.dart';
import '../widgets/fixed_assets_search_filters_widget.dart';
import '../widgets/fixed_assets_quick_update_filters_widget.dart';
import '../widgets/fixed_assets_search_footer_widget.dart';

class FixedAssetsSearchScreen extends StatelessWidget {
  const FixedAssetsSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ValidationCubit(
            requiredFields: {
              'zoneId',
              'zoneName',
              'typeId',
              'typeName',
              'responsibleId',
              'responsibleName',
              'date',
              'searchType',
              'quickSearchType',
            },
          ),
        ),
        BlocProvider(create: (context) => getIt<FixedAssetsSearchCubit>()),
      ],
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const FixedAssetsSearchHeaderWidget(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const FixedAssetsSearchBarWidget(),
                      SizedBox(height: 12.h),
                      const FixedAssetsSearchFiltersWidget(),
                      SizedBox(height: 12.h),
                      const FixedAssetsQuickUpdateFiltersWidget(),
                      // SizedBox(height: 12.h),
                      // const FixedAssetsLastSearchesWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const FixedAssetsSearchFooterWidget(),
      ),
    );
  }
}
