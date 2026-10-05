import 'package:flutter/material.dart';

import '../../../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../../../../core/widgets/custom_text_field.dart';
import '../final_daily_close_table_cell_widget.dart';

//
// class FinalDailyCloseCenterTableCellWidget extends StatefulWidget {
//   const FinalDailyCloseCenterTableCellWidget({
//     super.key,
//     required this.isEnabled,
//     required this.text,
//     this.onChanged,
//   });
//
//   final bool isEnabled;
//   final String text;
//   final Function(String)? onChanged;
//
//
//   @override
//   State<FinalDailyCloseCenterTableCellWidget> createState() =>
//       _FinalDailyCloseCenterTableCellWidgetState();
// }
//
// class _FinalDailyCloseCenterTableCellWidgetState
//     extends State<FinalDailyCloseCenterTableCellWidget> {
//
//   @override
//   Widget build(BuildContext context) {
//     return FinalDailyCloseTableCellWidget(
//
//       endBorderSide: BorderSide(
//           color: context.customColor.border,
//           width: 1.w
//       ),
//       bottomBorderSide: BorderSide(
//           color: context.customColor.border,
//           width: 1.w
//       ),
//       startBorderSide: BorderSide(
//           color: context.customColor.border,
//           width: 1.w
//       ),
//       topBorderSide: BorderSide(
//           color: context.customColor.border,
//           width: 1.w
//       ),
//       child: CustomTextField(
//         textAlign: TextAlign.center,
//         isEnabled: widget.isEnabled,
//         controller: TextEditingController(text: widget.text),
//         onChanged: widget.onChanged,
//         keyboardType: TextInputType.number,
//
//
//       ),
//     );
//   }
// }

class FinalDailyCloseCenterTableCellWidget extends StatefulWidget {
  final double value;
  final bool isEnabled;
  final ValueChanged<double> onChanged;

  const FinalDailyCloseCenterTableCellWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isEnabled,
  });

  @override
  State<FinalDailyCloseCenterTableCellWidget> createState() =>
      _FinalDailyCloseCenterTableCellWidgetState();
}

class _FinalDailyCloseCenterTableCellWidgetState
    extends State<FinalDailyCloseCenterTableCellWidget>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(
    covariant FinalDailyCloseCenterTableCellWidget oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    // Only update text if the value really changed and user isn't typing
    if (oldWidget.value != widget.value) {
      final oldSelection = _controller.selection;
      _controller.text = widget.value.toString();

      // Restore cursor position if possible
      final newPosition = oldSelection.baseOffset.clamp(
        0,
        _controller.text.length,
      );
      _controller.selection = TextSelection.collapsed(offset: newPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FinalDailyCloseTableCellWidget(
      endBorderSide: BorderSide(color: context.customColor.border, width: 1.w),
      bottomBorderSide: BorderSide(
        color: context.customColor.border,
        width: 1.w,
      ),
      startBorderSide: BorderSide(
        color: context.customColor.border,
        width: 1.w,
      ),
      topBorderSide: BorderSide(color: context.customColor.border, width: 1.w),
      child: CustomTextField(
        textAlign: TextAlign.center,
        isEnabled: widget.isEnabled,
        controller: _controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          widget.onChanged(double.tryParse(value) ?? 0);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
