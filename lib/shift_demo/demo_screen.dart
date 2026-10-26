import 'package:flutter/material.dart';
import 'demo_controller.dart';

class ShiftDemoApp extends StatefulWidget {
  const ShiftDemoApp({
    super.key,
    required this.controller,
    required this.server,
  });
  final DemoController controller;
  final String server;
  @override
  State<ShiftDemoApp> createState() => _ShiftDemoAppState();
}

class _ShiftDemoAppState extends State<ShiftDemoApp> {
  final identifier = TextEditingController();
  final password = TextEditingController();
  final allocations =
      <
        ({String type, TextEditingController id, TextEditingController amount})
      >[];
  @override
  void dispose() {
    identifier.dispose();
    password.dispose();
    for (final row in allocations) {
      row.id.dispose();
      row.amount.dispose();
    }
    widget.controller.dispose();
    super.dispose();
  }

  void syncAllocations() => widget.controller.allocate(
    allocations
        .map((r) => DemoAllocation(r.type, r.id.text, r.amount.text))
        .toList(),
  );

  Widget field(
    String label, {
    TextEditingController? controller,
    String? initial,
    bool obscure = false,
    bool numeric = false,
    ValueChanged<String>? changed,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      controller: controller,
      initialValue: initial,
      obscureText: obscure,
      enabled: !widget.controller.busy,
      keyboardType: numeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: changed,
    ),
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorSchemeSeed: const Color(0xff204d47),
      useMaterial3: true,
    ),
    home: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('عصب · ديمو دورة الكاشير')),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              final c = widget.controller;
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text('اتصال فعلي: ${widget.server}'),
                  const Text(
                    'ديمو محدود · إغلاق بدون تسليم · الحسابات من السيرفر',
                  ),
                  if (c.busy) const LinearProgressIndicator(),
                  if (c.error != null)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        c.error!,
                        key: const Key('error'),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (!c.loggedIn) ...[
                    field(
                      'البريد الإلكتروني أو الهاتف',
                      controller: identifier,
                    ),
                    field('كلمة المرور', controller: password, obscure: true),
                    FilledButton(
                      onPressed: c.busy
                          ? null
                          : () async {
                              await c.login(identifier.text, password.text);
                              password.clear();
                            },
                      child: const Text('دخول الكاشير'),
                    ),
                  ] else ...[
                    Text('مرحبًا ${c.name ?? ''}'),
                    OutlinedButton(
                      onPressed: c.busy ? null : c.refreshShifts,
                      child: const Text('تحديث الورديات قيد العمل'),
                    ),
                    if (c.shifts.isEmpty)
                      const Text(
                        'لا توجد وردية قيد العمل. يلزم تجهيز حساب ووردية تجريبية معتمدين قبل العرض.',
                      ),
                    for (final shift in c.shifts)
                      Card(
                        child: ListTile(
                          title: Text(
                            '${shift['date']} · ${shift['assigned_to'] ?? ''}',
                          ),
                          subtitle: Text('${shift['id']} · ${shift['status']}'),
                          enabled: !c.busy,
                          onTap: () => c.select(shift['id'].toString()),
                        ),
                      ),
                    if (c.shift != null) ...[
                      const Divider(),
                      Text('الوردية: ${c.shift!['id']}'),
                      Text(
                        'الحالة من السيرفر: ${c.shift!['status']}',
                        key: const Key('shift-status'),
                      ),
                      OutlinedButton(
                        onPressed: c.busy
                            ? null
                            : () => c.select(c.shift!['id'].toString()),
                        child: const Text('تحديث حالة الوردية'),
                      ),
                      if (c.shift!['status'] == 'in_progress') ...[
                        field(
                          'إجمالي المبيعات شامل الضريبة',
                          initial: c.totalSales,
                          numeric: true,
                          changed: (s) => c.edit(sales: s),
                        ),
                        field(
                          'مدفوعات البطاقة',
                          initial: c.cards,
                          numeric: true,
                          changed: (s) => c.edit(card: s),
                        ),
                        const Text(
                          'هذا الديمو لا يدعم مبيعات منصات التوصيل. استخدم وردية تجريبية بلا مبيعات منصات.',
                        ),
                        field(
                          'النقد الفعلي المعدود',
                          initial: c.counted,
                          numeric: true,
                          changed: (s) => c.edit(cash: s),
                        ),
                        field(
                          'نقد وارد غير محسوم ضمن العد (إن وجد)',
                          initial: c.pending,
                          numeric: true,
                          changed: (s) => c.edit(incoming: s),
                        ),
                        FilledButton(
                          onPressed: c.busy
                              ? null
                              : () async {
                                  for (final row in allocations) {
                                    row.id.dispose();
                                    row.amount.dispose();
                                  }
                                  allocations.clear();
                                  await c.reconcile();
                                },
                          child: const Text('معاينة التسوية من السيرفر'),
                        ),
                        if (c.preview != null) ...[
                          const SizedBox(height: 12),
                          for (final entry in <String, String>{
                            'confirmed_opening_cash': 'الافتتاحي المؤكد',
                            'counted_cash': 'العد الفعلي',
                            'expected_cash': 'النقد المتوقع',
                            'pending_incoming_cash': 'الوارد غير المحسوم',
                            'cash_variance': 'الفرق بإشارته',
                            'cash_variance_type': 'نوع الفرق',
                          }.entries)
                            Text(
                              '${entry.value}: ${c.preview!.reconciliation[entry.key]}',
                            ),
                          if (c.preview!.allocationRequired) ...[
                            Text(
                              'العجز المطلوب توزيعه: ${decimal(c.preview!.shortage)}',
                            ),
                            const Text(
                              'اختر موظفين محددين من نفس الفرع باستخدام معرفاتهم المعتمدة؛ السيرفر يتحقق من الأهلية.',
                            ),
                            for (int i = 0; i < allocations.length; i++) ...[
                              DropdownButtonFormField<String>(
                                initialValue: allocations[i].type,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'cashier',
                                    child: Text('كاشير'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'branch_manager',
                                    child: Text('مدير فرع'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'employee',
                                    child: Text('موظف'),
                                  ),
                                ],
                                onChanged: c.busy
                                    ? null
                                    : (v) {
                                        final r = allocations[i];
                                        allocations[i] = (
                                          type: v!,
                                          id: r.id,
                                          amount: r.amount,
                                        );
                                        syncAllocations();
                                      },
                              ),
                              field(
                                'معرف الموظف ${i + 1}',
                                controller: allocations[i].id,
                                changed: (_) => syncAllocations(),
                              ),
                              field(
                                'مبلغ التحميل ${i + 1}',
                                controller: allocations[i].amount,
                                numeric: true,
                                changed: (_) => syncAllocations(),
                              ),
                              TextButton(
                                onPressed: c.busy
                                    ? null
                                    : () {
                                        final r = allocations.removeAt(i);
                                        r.id.dispose();
                                        r.amount.dispose();
                                        syncAllocations();
                                      },
                                child: const Text('حذف'),
                              ),
                            ],
                            OutlinedButton(
                              onPressed: c.busy
                                  ? null
                                  : () {
                                      allocations.add((
                                        type: 'cashier',
                                        id: TextEditingController(
                                          text: c.cashierId,
                                        ),
                                        amount: TextEditingController(),
                                      ));
                                      syncAllocations();
                                    },
                              child: const Text('إضافة مسؤول عن العجز'),
                            ),
                          ],
                          FilledButton(
                            key: const Key('close-shift'),
                            onPressed: c.canClose
                                ? () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text(
                                          'تأكيد إغلاق الوردية',
                                        ),
                                        content: const Text(
                                          'سيتم إرسال الإغلاق الفعلي إلى السيرفر بدون تسليم.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, false),
                                            child: const Text('رجوع'),
                                          ),
                                          FilledButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: const Text('إغلاق'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) await c.closeShift();
                                  }
                                : null,
                            child: const Text('إغلاق بدون تسليم'),
                          ),
                        ],
                      ],
                      if (c.result != null)
                        Text(c.result!, key: const Key('close-result')),
                    ],
                  ],
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
