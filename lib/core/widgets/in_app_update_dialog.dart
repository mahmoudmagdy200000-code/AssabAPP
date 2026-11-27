import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/in_app_update_service.dart';

bool _updatePromptOpen = false;

Future<InAppUpdateRelease?> checkForAppUpdates({
  required BuildContext context,
  required InAppUpdateService service,
  bool showPrompt = true,
  bool includeDeferred = false,
}) async {
  final release = await service.checkForUpdate(ignoreDeferred: includeDeferred);
  if (release == null || !showPrompt || !context.mounted || _updatePromptOpen) {
    return release;
  }

  _updatePromptOpen = true;
  try {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => InAppUpdateDialog(
        release: release,
        service: service,
        isArabic: Localizations.localeOf(dialogContext).languageCode == 'ar',
      ),
    );
  } finally {
    _updatePromptOpen = false;
  }
  return release;
}

class InAppUpdateDialog extends StatefulWidget {
  const InAppUpdateDialog({
    required this.release,
    required this.service,
    required this.isArabic,
    super.key,
  });

  final InAppUpdateRelease release;
  final InAppUpdateService service;
  final bool isArabic;

  @override
  State<InAppUpdateDialog> createState() => _InAppUpdateDialogState();
}

class _InAppUpdateDialogState extends State<InAppUpdateDialog> {
  bool _downloading = false;
  double? _progress;
  String? _error;

  String _text(String english, String arabic) =>
      widget.isArabic ? arabic : english;

  Future<void> _update() async {
    setState(() {
      _downloading = true;
      _progress = 0;
      _error = null;
    });
    try {
      final path = await widget.service.downloadAndVerify(
        widget.release,
        onProgress: (received, total) {
          if (!mounted) return;
          setState(() {
            _progress = total > 0 ? (received / total).clamp(0.0, 1.0) : null;
          });
        },
      );
      if (!mounted) return;
      await widget.service.install(path);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _downloading = false;
        _progress = null;
        _error = error.toString();
      });
    }
  }

  void _cancelDownload() {
    widget.service.cancelDownload();
  }

  String _downloadSize() {
    final mb = widget.release.sizeBytes / (1024 * 1024);
    final digits = math.max(1, mb >= 10 ? 1 : 2);
    return '${mb.toStringAsFixed(digits)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final release = widget.release;
    return PopScope(
      canPop: !_downloading,
      child: AlertDialog(
        title: Text(_text('Update available', 'يتوفر تحديث جديد')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_text('Version', 'الإصدار')} ${release.versionName} (${release.versionCode})',
              ),
              const SizedBox(height: 6),
              Text(
                '${_text('Download size', 'حجم التنزيل')}: ${_downloadSize()}',
              ),
              const SizedBox(height: 16),
              Text(
                _text('What’s new', 'ما الجديد'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(widget.isArabic ? release.changelogAr : release.changelogEn),
              if (_downloading) ...[
                const SizedBox(height: 20),
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 8),
                Text(
                  _progress == null
                      ? _text('Downloading…', 'جارٍ التنزيل…')
                      : '${(_progress! * 100).round()}%',
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _text(
                    'The update could not be completed. Check your connection and retry.',
                    'تعذر إكمال التحديث. تحقق من الاتصال ثم أعد المحاولة.',
                  ),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _downloading
                ? _cancelDownload
                : () async {
                    try {
                      await widget.service.defer(release);
                    } catch (_) {
                      // A failed preference write should not block using the app.
                    }
                    if (context.mounted) Navigator.of(context).pop();
                  },
            child: Text(
              _downloading
                  ? _text('Cancel download', 'إلغاء التنزيل')
                  : _text('Later', 'لاحقاً'),
            ),
          ),
          FilledButton(
            onPressed: _downloading ? null : _update,
            child: Text(
              _downloading
                  ? _text('Downloading…', 'جارٍ التنزيل…')
                  : _text(
                      _error == null ? 'Update now' : 'Retry',
                      _error == null ? 'حدّث الآن' : 'إعادة المحاولة',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
