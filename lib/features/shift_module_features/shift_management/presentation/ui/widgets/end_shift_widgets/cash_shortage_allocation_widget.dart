import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
import 'package:flutter/material.dart';

class CashShortageAllocationWidget extends StatefulWidget {
  final double shortageAmount;
  final List<CashShortageAllocation> initialAllocations;
  final ValueChanged<List<CashShortageAllocation>> onAllocationsChanged;
  final String? initialReason;
  final ValueChanged<String?>? onReasonChanged;
  final List<ShortageAllocationCandidate> candidates;
  final bool isLoadingCandidates;
  final String? candidatesError;
  final VoidCallback? onRetryCandidates;

  const CashShortageAllocationWidget({
    super.key,
    required this.shortageAmount,
    this.initialAllocations = const [],
    required this.onAllocationsChanged,
    this.initialReason,
    this.onReasonChanged,
    this.candidates = const [],
    this.isLoadingCandidates = false,
    this.candidatesError,
    this.onRetryCandidates,
  });

  @override
  State<CashShortageAllocationWidget> createState() =>
      _CashShortageAllocationWidgetState();
}

class _CashShortageAllocationWidgetState
    extends State<CashShortageAllocationWidget> {
  late List<CashShortageAllocation> _allocations;
  late final TextEditingController _amountController;
  late final TextEditingController _reasonController;
  String _selectedType = 'cashier';
  ShortageAllocationCandidate? _selectedCandidate;

  @override
  void initState() {
    super.initState();
    _allocations = List.from(widget.initialAllocations);
    _amountController = TextEditingController();
    _reasonController = TextEditingController(text: widget.initialReason ?? '');
  }

  @override
  void didUpdateWidget(covariant CashShortageAllocationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.candidates != oldWidget.candidates) {
      if (_selectedCandidate != null &&
          !widget.candidates.any(
            (c) =>
                c.id == _selectedCandidate!.id &&
                c.type == _selectedCandidate!.type,
          )) {
        setState(() {
          _selectedCandidate = null;
        });
      }
      if (_allocations.isNotEmpty && widget.candidates.isNotEmpty) {
        final pruned = _allocations.where((alloc) {
          return widget.candidates.any(
            (c) =>
                c.type == alloc.responsibleType && c.id == alloc.responsibleId,
          );
        }).toList();
        if (pruned.length != _allocations.length) {
          setState(() {
            _allocations = pruned;
          });
          widget.onAllocationsChanged(_allocations);
        }
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  int get _shortageHalalas => (widget.shortageAmount * 100).round();
  int get _allocatedHalalas =>
      _allocations.fold<int>(0, (sum, a) => sum + (a.amount * 100).round());
  int get _remainingHalalas => _shortageHalalas - _allocatedHalalas;

  double get _allocatedTotal => _allocatedHalalas / 100.0;
  double get _remainingAmount =>
      _remainingHalalas <= 0 ? 0.0 : (_remainingHalalas / 100.0);

  bool get isComplete => _remainingHalalas == 0 && _allocations.isNotEmpty;

  List<ShortageAllocationCandidate> get _filteredCandidates {
    return widget.candidates
        .where((c) => c.type == _selectedType && c.isValid)
        .toList();
  }

  void _addAllocation() {
    final tr = context.tr;
    if (_selectedCandidate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.pleaseSelectResponsible)));
      return;
    }

    final id = _selectedCandidate!.id;
    final name = _selectedCandidate!.name;
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.pleaseEnterValidAmount)));
      return;
    }

    final amountHalalas = (amount * 100).round();
    if (amountHalalas > _remainingHalalas) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.allocationExceedsRemaining)));
      return;
    }

    // Check duplicate actor
    final duplicate = _allocations.any(
      (a) => a.responsibleType == _selectedType && a.responsibleId == id,
    );
    if (duplicate) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.duplicateResponsibleAdded)));
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
      _selectedCandidate = null;
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
    final tr = context.tr;
    final currency = tr.sar;

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
                tr.noShortageRequiringAllocation,
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              Text(
                tr.cashShortageAllocation,
                style: AppStyles.s16W500,
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
                  isComplete ? tr.completed : tr.fullAllocationRequired,
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
                  title: tr.totalShortage,
                  value:
                      '${widget.shortageAmount.toStringAsFixed(2)} $currency',
                  color: Colors.red[700]!,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: _buildMetricCard(
                  title: tr.allocatedAmount,
                  value: '${_allocatedTotal.toStringAsFixed(2)} $currency',
                  color: Colors.blue[700]!,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: _buildMetricCard(
                  title: tr.remainingAmount,
                  value: '${_remainingAmount.toStringAsFixed(2)} $currency',
                  color: _remainingHalalas == 0
                      ? Colors.green
                      : Colors.orange[800]!,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          const CustomDivider(),
          10.verticalSpace,

          // List of current allocations
          if (_allocations.isNotEmpty) ...[
            Text(tr.specifiedResponsibilities, style: AppStyles.s14W500),
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
                        '${_typeLabel(alloc.responsibleType)}: ${alloc.name ?? alloc.responsibleId} (${alloc.amount.toStringAsFixed(2)} $currency)',
                        style: AppStyles.s13W400,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.red,
                      ),
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
            Text(tr.addResponsibleForShortage, style: AppStyles.s13W500),
            8.verticalSpace,
            DropdownButtonFormField<String>(
              key: ValueKey('type_$_selectedType'),
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: tr.responsibleType,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'cashier', child: Text(tr.cashier)),
                DropdownMenuItem(
                  value: 'branch_manager',
                  child: Text(tr.branchManager),
                ),
                DropdownMenuItem(value: 'employee', child: Text(tr.employee)),
              ],
              onChanged: (val) {
                if (val != null && val != _selectedType) {
                  setState(() {
                    _selectedType = val;
                    _selectedCandidate = null;
                  });
                }
              },
            ),
            8.verticalSpace,
            _buildCandidateSelector(),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _amountController,
                    hintText: tr.allocatedAmountSar,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    maxLength: 20,
                  ),
                ),
                8.horizontalSpace,
                ElevatedButton(
                  onPressed: _addAllocation,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(tr.add),
                ),
              ],
            ),
          ],

          10.verticalSpace,
          // Reason input
          CustomTextField(
            controller: _reasonController,
            hintText: tr.shortageReasonOptional,
            maxLength: 500,
            onChanged: (val) {
              widget.onReasonChanged?.call(
                val.trim().isEmpty ? null : val.trim(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateSelector() {
    final tr = context.tr;

    if (widget.isLoadingCandidates) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.blue.withAlpha(15),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.blue.withAlpha(40)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            10.horizontalSpace,
            Text(
              tr.loadingEligibleCandidates,
              style: AppStyles.s12W400.copyWith(color: Colors.blue[900]),
            ),
          ],
        ),
      );
    }

    if (widget.candidatesError != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(15),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.red.withAlpha(50)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            8.horizontalSpace,
            Expanded(
              child: Text(
                widget.candidatesError ?? tr.failedToLoadCandidates,
                style: AppStyles.s12W400.copyWith(color: Colors.red[800]),
              ),
            ),
            if (widget.onRetryCandidates != null)
              TextButton(
                onPressed: widget.onRetryCandidates,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                ),
                child: Text(tr.retry),
              ),
          ],
        ),
      );
    }

    final filtered = _filteredCandidates;
    if (filtered.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(15),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.orange.withAlpha(60)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange[800], size: 18),
            8.horizontalSpace,
            Expanded(
              child: Text(
                tr.noCandidatesAvailableForRole,
                style: AppStyles.s12W400.copyWith(color: Colors.orange[900]),
              ),
            ),
          ],
        ),
      );
    }

    final currentVal = filtered.contains(_selectedCandidate)
        ? _selectedCandidate
        : null;

    return DropdownButtonFormField<ShortageAllocationCandidate>(
      key: ValueKey('candidate_${_selectedType}_${_selectedCandidate?.id}'),
      initialValue: currentVal,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: tr.selectResponsibleNameAndId,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      items: filtered.map((candidate) {
        final label = '${candidate.name} (ID: ${candidate.id})';
        return DropdownMenuItem<ShortageAllocationCandidate>(
          value: candidate,
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.s13W400,
          ),
        );
      }).toList(),
      onChanged: (candidate) {
        setState(() {
          _selectedCandidate = candidate;
        });
      },
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
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.s11W400.copyWith(color: context.customColor.text3),
          ),
          4.verticalSpace,
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.s13W500.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    final tr = context.tr;
    switch (type) {
      case 'branch_manager':
        return tr.branchManager;
      case 'employee':
        return tr.employee;
      case 'cashier':
      default:
        return tr.cashier;
    }
  }
}
