import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../data/models/compare_price_response.dart';

class ComparePricesTable extends StatelessWidget {
  final PurchaseComparePriceResponseSources sources;

  const ComparePricesTable({super.key, required this.sources});

  List<({String title, PurchaseComparePriceDetails details})> get _sourceRows {
    return [
      (title: 'direct', details: sources.directSupplier),
      (title: 'purchasingOfficer', details: sources.viaPurchasingOfficer),
      (title: 'branchTransfer', details: sources.internalTransfer),
    ];
  }

  String _getSourceTitle(BuildContext context, String key) {
    switch (key) {
      case 'direct':
        return context.tr.direct;
      case 'purchasingOfficer':
        return context.tr.purchasingOfficer;
      case 'branchTransfer':
        return context.tr.branchTransfer;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: context.customColor.border.withValues(alpha: 0.4),
        width: 1,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: context.customColor.text2),
          children: [
            _buildCell(context, '', isHeader: true),
            _buildCell(context, context.tr.price, isHeader: true),
            _buildCell(context, context.tr.delivery, isHeader: true),
            _buildCell(context, context.tr.rating, isHeader: true),
          ],
        ),
        ..._sourceRows.map(
          (row) => _buildSourceRow(context, row.title, row.details),
        ),
      ],
    );
  }

  Widget _buildCell(
    BuildContext context,
    String text, {
    bool isHeader = false,
    TextAlign textAlign = TextAlign.center,
    Widget? customChild,
    TextStyle? textStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 8.r),
      child: Row(
        mainAxisAlignment: textAlign == TextAlign.center
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ?customChild,
          Flexible(
            child: Text(
              text,
              textAlign: textAlign,
              softWrap: true,
              overflow: TextOverflow.visible,
              style:
                  textStyle ??
                  (isHeader
                      ? AppStyles.s13W400.copyWith(
                          color: context.customColor.text3,
                        )
                      : AppStyles.s13WB.copyWith(
                          color: context.customColor.text1,
                        )),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildSourceRow(
    BuildContext context,
    String titleKey,
    PurchaseComparePriceDetails details,
  ) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.transparent),
      children: [
        _buildCell(
          context,
          '${_getSourceTitle(context, titleKey)}:',
          textAlign: TextAlign.start,
          textStyle: AppStyles.s13W400.copyWith(
            color: context.customColor.text3,
          ),
        ),
        _buildCell(
          context,
          details.price ?? '0',
          customChild: const SaudiRiyalSvgWidget(),
        ),
        _buildCell(
          context,
          '${double.tryParse(details.deliveryDays ?? '0')?.toInt() ?? 0} ${context.tr.days}',
        ),
        _buildCell(context, details.rating ?? '0'),
      ],
    );
  }
}
