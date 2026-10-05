import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../generated/l10n.dart';

class BrandOwnerFinancialReportingChooseDateMonthModel {
  final String title;
  final int value;

  BrandOwnerFinancialReportingChooseDateMonthModel({
    required this.title,
    required this.value,
  });

  @override
  int get hashCode => title.hashCode ^ value.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BrandOwnerFinancialReportingChooseDateMonthModel &&
        other.title == title &&
        other.value == value;
  }
}

class BrandOwnerFinancialReportingChooseDateBottomSheet extends StatefulWidget {
  final void Function(
    BrandOwnerFinancialReportingChooseDateMonthModel selectedMonth,
    int selectedYear,
  )
  onApply;
  final void Function()? onReset;

  const BrandOwnerFinancialReportingChooseDateBottomSheet({
    super.key,
    required this.onApply,
    this.onReset,
  });

  @override
  State<BrandOwnerFinancialReportingChooseDateBottomSheet> createState() =>
      _BrandOwnerFinancialReportingChooseDateBottomSheetState();
}

class _BrandOwnerFinancialReportingChooseDateBottomSheetState
    extends State<BrandOwnerFinancialReportingChooseDateBottomSheet> {
  late final ScrollController _monthScrollController;
  late final ScrollController _yearScrollController;

  BrandOwnerFinancialReportingChooseDateMonthModel? _selectedMonth;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();

    _monthScrollController = ScrollController(
      initialScrollOffset: (_months.length / 2 * 50).toDouble(),
    );
    _yearScrollController = ScrollController(
      initialScrollOffset: (_years.length / 2 * 50).toDouble(),
    );
  }

  @override
  void dispose() {
    _monthScrollController.dispose();
    _yearScrollController.dispose();
    super.dispose();
  }

  List<BrandOwnerFinancialReportingChooseDateMonthModel> get _months => [
    BrandOwnerFinancialReportingChooseDateMonthModel(
      title: 'January',
      value: 1,
    ),
    BrandOwnerFinancialReportingChooseDateMonthModel(
      title: 'February',
      value: 2,
    ),
    BrandOwnerFinancialReportingChooseDateMonthModel(title: 'March', value: 3),
    BrandOwnerFinancialReportingChooseDateMonthModel(title: 'April', value: 4),
    BrandOwnerFinancialReportingChooseDateMonthModel(title: 'May', value: 5),
    BrandOwnerFinancialReportingChooseDateMonthModel(title: 'June', value: 6),
    BrandOwnerFinancialReportingChooseDateMonthModel(title: 'July', value: 7),
    BrandOwnerFinancialReportingChooseDateMonthModel(title: 'August', value: 8),
    BrandOwnerFinancialReportingChooseDateMonthModel(
      title: 'September',
      value: 9,
    ),
    BrandOwnerFinancialReportingChooseDateMonthModel(
      title: 'October',
      value: 10,
    ),
    BrandOwnerFinancialReportingChooseDateMonthModel(
      title: 'November',
      value: 11,
    ),
    BrandOwnerFinancialReportingChooseDateMonthModel(
      title: 'December',
      value: 12,
    ),
  ];

  List<int> get _years => List.generate(
    15,
    (index) => DateTime.now().year - index,
  ).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    S.of(context).chooseReportDate,
                    style: AppStyles.s16W500.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  5.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: context.customColor.border),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.r),
                    height: 400.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              trackBorderColor: const WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                              radius: Radius.circular(1000.r),
                              thickness: WidgetStatePropertyAll(10.r),
                              trackVisibility: const WidgetStatePropertyAll(
                                true,
                              ),
                              thumbVisibility: const WidgetStatePropertyAll(
                                true,
                              ),
                              trackColor: WidgetStatePropertyAll(
                                context.customColor.text2,
                              ),
                              interactive: true,
                              thumbColor: WidgetStatePropertyAll(
                                context.customColor.text1,
                              ),
                            ),
                            child: Scrollbar(
                              controller: _monthScrollController,
                              child: ListView.builder(
                                controller: _monthScrollController,
                                itemCount: _months.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final isSelected =
                                      _selectedMonth == _months[index];

                                  return AppGestureDetectorButton(
                                    onTap: () {
                                      setState(() {
                                        _selectedMonth = _months[index];
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: index != 0
                                            ? Border(
                                                top: BorderSide(
                                                  color: context
                                                      .customColor
                                                      .border,
                                                ),
                                              )
                                            : null,
                                      ),
                                      padding: EdgeInsets.all(10.r),
                                      child: Text(
                                        _months[index].title,
                                        style: AppStyles.s13W500.copyWith(
                                          color: isSelected
                                              ? context.theme.primaryColor
                                              : context.customColor.text1,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              trackBorderColor: const WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                              radius: Radius.circular(1000.r),
                              thickness: WidgetStatePropertyAll(10.r),
                              trackVisibility: const WidgetStatePropertyAll(
                                true,
                              ),
                              thumbVisibility: const WidgetStatePropertyAll(
                                true,
                              ),
                              trackColor: WidgetStatePropertyAll(
                                context.customColor.text2,
                              ),
                              interactive: true,
                              thumbColor: WidgetStatePropertyAll(
                                context.customColor.text1,
                              ),
                            ),
                            child: Scrollbar(
                              controller: _yearScrollController,
                              child: ListView.builder(
                                controller: _yearScrollController,
                                itemCount: _years.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  final isSelected =
                                      _selectedYear == _years[index];

                                  return AppGestureDetectorButton(
                                    onTap: () {
                                      setState(() {
                                        _selectedYear = _years[index];
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: index != 0
                                            ? Border(
                                                top: BorderSide(
                                                  color: context
                                                      .customColor
                                                      .border,
                                                ),
                                              )
                                            : null,
                                      ),
                                      padding: EdgeInsets.all(10.r),
                                      child: Text(
                                        _years[index].toString(),
                                        style: AppStyles.s13W500.copyWith(
                                          color: isSelected
                                              ? context.theme.primaryColor
                                              : context.customColor.text1,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: S.of(context).resetFilter,
                    onTap: () {
                      setState(() {
                        _selectedMonth = null;
                        _selectedYear = null;
                      });

                      if (widget.onReset != null) {
                        widget.onReset!();
                      }

                      NavigationService.I.pop();
                    },
                    padding: EdgeInsets.symmetric(vertical: 14.r),
                    borderRadius: 12.r,
                    textColor: context.customColor.text1,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: AppButton(
                    text: S.of(context).applyFilter,
                    onClick: () {
                      if (_selectedMonth != null && _selectedYear != null) {
                        widget.onApply(_selectedMonth!, _selectedYear!);
                        NavigationService.I.pop();
                      }
                    },
                    padding: EdgeInsets.symmetric(vertical: 14.r),
                    borderRadius: BorderRadius.circular(12.r),
                    borderColor: Colors.transparent,
                    enabled: _selectedMonth != null && _selectedYear != null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
