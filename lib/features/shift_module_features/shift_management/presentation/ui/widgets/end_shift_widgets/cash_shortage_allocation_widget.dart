import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:flutter/material.dart';

class CashShortageAllocationWidget extends StatefulWidget {
  final double shortageAmount;
  final List<CashShortageAllocation> initialAllocations;
  final ValueChanged<List<CashShortageAllocation>> onAllocationsChanged;
  final String? initialReason;
  final ValueChanged<String?>? onReasonChanged;

  const CashShortageAllocationWidget({
    super.key,
    required this.shortageAmount,
    this.initialAllocations = const [],
    required this.onAllocationsChanged,
    this.initialReason,
    this.onReasonChanged,
  });

  @override
  State<CashShortageAllocationWidget> createState() =>
      _CashShortageAllocationWidgetState();
}

class _CashShortageAllocationWidgetState
    extends State<CashShortageAllocationWidget> {
  late List<CashShortageAllocation> _allocations;
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _reasonController;
  String _selectedType = 'cashier';

  @override
  void initState() {
    super.initState();
    _allocations = List.from(widget.initialAllocations);
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _reasonController = TextEditingController(text: widget.initialReason ?? '');
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  double get _allocatedTotal =>
      _allocations.fold<double>(0.0, (sum, a) => sum + a.amount);

  double get _remainingAmount {
    final rem = widget.shortageAmount - _allocatedTotal;
    return rem.abs() < 0.001 ? 0.0 : rem;
  }

  bool get isComplete => _remainingAmount.abs() < 0.01 && _allocations.isNotEmpty;

  void _addAllocation() {
    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال معرّف المسؤول')),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال مبلغ صحيح أكبر من الصفر')),
      );
      return;
    }

    if (amount > _remainingAmount + 0.001) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('مبلغ التوزيع يتجاوز المتبقي من العجز')),
      );
      return;
    }

    // Check duplicate actor
    final duplicate = _allocations.any(
      (a) => a.responsibleType == _selectedType && a.responsibleId == id,
    );
    if (duplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إضافة هذا المسؤول مسبقاً')),
      );
      return;
    }

    setState(() {
      _allocations.add(
        CashShortageAllocation(
          responsibleType: _selectedType,
          responsibleId: id,
          amount: amount,
          name: name.isNotEmpty ? name : null,
        ),
      );
      _idController.clear();
      _nameController.clear();
      _amountController.clear();
    });

    widget.onAllocationsChanged(_allocations);
  }

  void _removeAllocation(int index) {
    setState(() {
      _allocations.removeAt(index);
    });
    widget.onAllocationsChanged(_allocations);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shortageAmount <= 0) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(20),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.green.withAlpha(80)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green),
            10.horizontalSpace,
            Expanded(
              child: Text(
                'لا يوجد عجز نقدي يستدعي توزيع المسؤولية.',
                style: AppStyles.s14W500.copyWith(color: Colors.green[800]),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isComplete ? Colors.green : Colors.amber.shade700,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('توزيع العجز النقدي', style: AppStyles.s16W500),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isComplete
                      ? Colors.green.withAlpha(25)
                      : Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  isComplete ? 'مكتمل' : 'مطلوب التوزيع بالكامل',
                  style: AppStyles.s12W500.copyWith(
                    color: isComplete ? Colors.green[800] : Colors.red[800],
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'إجمالي العجز',
                  value: '${widget.shortageAmount.toStringAsFixed(2)} ر.س',
                  color: Colors.red[700]!,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: _buildMetricCard(
                  title: 'الموزّع',
                  value: '${_allocatedTotal.toStringAsFixed(2)} ر.س',
                  color: Colors.blue[700]!,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: _buildMetricCard(
                  title: 'المتبقي',
                  value: '${_remainingAmount.toStringAsFixed(2)} ر.س',
                  color: _remainingAmount == 0 ? Colors.green : Colors.orange[800]!,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,

          // List of current allocations
          if (_allocations.isNotEmpty) ...[
            Text('المسؤوليات المحددة:', style: AppStyles.s14W500),
            6.verticalSpace,
            ...List.generate(_allocations.length, (index) {
              final alloc = _allocations[index];
              return Container(
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withAlpha(15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_typeLabel(alloc.responsibleType)}: ${alloc.name ?? alloc.responsibleId} (${alloc.amount.toStringAsFixed(2)} ر.س)',
                        style: AppStyles.s13W400,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18, color: Colors.red),
                      onPressed: () => _removeAllocation(index),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              );
            }),
            10.verticalSpace,
          ],

          // Add allocation form if not complete
          if (!isComplete) ...[
            Text('إضافة مسؤول عن جزء من العجز:', style: AppStyles.s13W500),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'cashier', child: Text('كاشير')),
                      DropdownMenuItem(value: 'branch_manager', child: Text('مدير فرع')),
                      DropdownMenuItem(value: 'employee', child: Text('موظف')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: CustomTextField(
                    controller: _idController,
                    hintText: 'معرف المسؤول (ID)',
                    keyboardType: TextInputType.text,
                    maxLength: 64,
                  ),
                ),
              ],
            ),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _nameController,
                    hintText: 'الاسم (اختياري للعرض)',
                    keyboardType: TextInputType.name,
                    maxLength: 64,
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: CustomTextField(
                    controller: _amountController,
                    hintText: 'المبلغ (ر.س)',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    maxLength: 20,
                  ),
                ),
                8.horizontalSpace,
                ElevatedButton(
                  onPressed: _addAllocation,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: const Text('إضافة'),
                ),
              ],
            ),
          ],

          10.verticalSpace,
          // Reason input
          CustomTextField(
            controller: _reasonController,
            hintText: 'سبب العجز / ملاحظات التوزيع (اختياري)',
            maxLength: 500,
            onChanged: (val) {
              widget.onReasonChanged?.call(val.trim().isEmpty ? null : val.trim());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.s11W400.copyWith(color: context.customColor.text3)),
          4.verticalSpace,
          Text(value, style: AppStyles.s13W500.copyWith(color: color)),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'branch_manager':
        return 'مدير الفرع';
      case 'employee':
        return 'موظف';
      case 'cashier':
      default:
        return 'كاشير';
    }
  }
}
