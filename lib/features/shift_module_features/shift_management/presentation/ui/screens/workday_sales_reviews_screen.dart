import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WorkdaySalesReviewsScreen extends StatefulWidget {
  const WorkdaySalesReviewsScreen({super.key, required this.dio});

  final Dio dio;

  @override
  State<WorkdaySalesReviewsScreen> createState() =>
      _WorkdaySalesReviewsScreenState();
}

class _WorkdaySalesReviewsScreenState extends State<WorkdaySalesReviewsScreen> {
  static const _path = 'branch-manager/workday/sales-reviews';
  late Future<List<Map<String, dynamic>>> _reports;
  bool _sending = false;

  String _t(String ar, String en) =>
      Localizations.localeOf(context).languageCode == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _reports = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final response = await widget.dio.get<Map<String, dynamic>>(_path);
    return (response.data!['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<void> _refresh() async {
    setState(() => _reports = _load());
    await _reports.then<void>((_) {}, onError: (Object _) {});
  }

  Future<void> _send(
    String day,
    String title,
    Map<String, String> command,
  ) async {
    if (_sending) return;
    setState(() => _sending = true);
    final controller = TextEditingController();
    try {
      final message = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            maxLength: 1000,
            maxLines: 4,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(_t('إلغاء', 'Cancel')),
            ),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (_, value, _) => FilledButton(
                onPressed: value.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(dialogContext, value.text.trim()),
                child: Text(_t('إرسال', 'Send')),
              ),
            ),
          ],
        ),
      );
      if (message == null || !mounted) return;
      await widget.dio.post<void>(
        '$_path/$day',
        data: {...command, 'message': message},
      );
      if (mounted) await _refresh();
    } on DioException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _t(
              'تعذّر تأكيد الإرسال. تحقق من الحالة بعد التحديث.',
              'Could not confirm sending. Check the refreshed status.',
            ),
          ),
        ),
      );
      await _refresh();
    } finally {
      controller.dispose();
      if (mounted) setState(() => _sending = false);
    }
  }

  Widget _report(Map<String, dynamic> report) {
    final day = report['workdayId'] as String;
    final questions = (report['questions'] as List)
        .cast<Map<String, dynamic>>();
    final returnCycle = report['returnCycle'] as String?;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${report['publicId']} · ${report['date'] ?? ''}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (returnCycle != null) ...[
              const SizedBox(height: 8),
              Text(_t('سبب الإرجاع', 'Return reason')),
              Text(report['returnReason'] as String? ?? ''),
              OutlinedButton(
                onPressed: _sending
                    ? null
                    : () => _send(
                        day,
                        _t(
                          'ملاحظة التصحيح وإعادة الإرسال',
                          'Correction note and resubmission',
                        ),
                        {'action': 'resubmit', 'returnCycle': returnCycle},
                      ),
                child: Text(_t('إعادة إرسال التقرير', 'Resubmit report')),
              ),
            ],
            for (final question in questions) ...[
              const Divider(),
              Text(
                question['shiftLabel'] as String,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(question['message'] as String),
              if (question['reply'] case final String reply)
                Text('${_t('الرد', 'Reply')} · $reply')
              else
                TextButton(
                  onPressed: _sending
                      ? null
                      : () => _send(
                          day,
                          _t('رد على التوضيح', 'Reply to clarification'),
                          {
                            'action': 'reply',
                            'questionId': question['id'] as String,
                          },
                        ),
                  child: Text(_t('إرسال رد', 'Send reply')),
                ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_t('مراجعة تقارير المبيعات', 'Sales report review')),
    ),
    body: FutureBuilder(
      future: _reports,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: _refresh,
              child: Text(
                _t(
                  'تعذّر تحميل التقارير · إعادة المحاولة',
                  'Could not load reports · Retry',
                ),
              ),
            ),
          );
        }
        final reports = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: reports.isEmpty
                ? [
                    Text(
                      _t(
                        'لا توجد تقارير بانتظار رد أو تصحيح',
                        'No reports awaiting a reply or correction',
                      ),
                    ),
                  ]
                : reports.map(_report).toList(),
          ),
        );
      },
    ),
  );
}
