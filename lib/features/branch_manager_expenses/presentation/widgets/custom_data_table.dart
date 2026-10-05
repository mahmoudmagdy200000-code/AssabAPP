import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final List<String> headers;
  final List<String> keysOrder;
  final bool firstColumnWider;
  final double firstColumnFlex;

  const CustomDataTable({
    super.key,
    required this.items,
    required this.headers,
    required this.keysOrder,
    this.firstColumnWider = true,
    this.firstColumnFlex = 2,
  });

  @override
  Widget build(BuildContext context) {
    final Map<int, TableColumnWidth> columnWidths = {};
    for (int i = 0; i < headers.length; i++) {
      columnWidths[i] = i == 0 && firstColumnWider
          ? FlexColumnWidth(firstColumnFlex)
          : const FlexColumnWidth(1);
    }

    return Table(
      border: TableBorder.all(
        color: context.customColor.border.withValues(alpha: 0.4),
        width: 1,
      ),
      columnWidths: columnWidths,
      children: [_buildHeaderRow(context), ..._buildDataRows(context)],
    );
  }

  TableRow _buildHeaderRow(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(color: context.customColor.text2),
      children: headers
          .map((header) => _buildCell(context, header, isHeader: true))
          .toList(),
    );
  }

  List<TableRow> _buildDataRows(BuildContext context) {
    return items.map((item) {
      return TableRow(
        decoration: const BoxDecoration(color: Colors.transparent),
        children: keysOrder.map((key) {
          final value = item[key]?.toString() ?? '';
          return _buildCell(context, value);
        }).toList(),
      );
    }).toList();
  }

  Widget _buildCell(
    BuildContext context,
    String text, {
    bool isHeader = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 8.r),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: isHeader
            ? AppStyles.s14W600.copyWith(color: context.customColor.text1)
            : AppStyles.s14W400.copyWith(color: context.customColor.text3),
      ),
    );
  }
}
