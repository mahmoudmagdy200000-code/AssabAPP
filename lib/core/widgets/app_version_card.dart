import 'dart:async';

import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/in_app_update_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/in_app_update_dialog.dart';
import 'package:flutter/material.dart';

enum _VersionCardStatus {
  loading,
  available,
  current,
  managedByStore,
  unavailable,
  failed,
}

class AppVersionCard extends StatefulWidget {
  const AppVersionCard({super.key, this.updateService});

  final InAppUpdateService? updateService;

  @override
  State<AppVersionCard> createState() => _AppVersionCardState();
}

class _AppVersionCardState extends State<AppVersionCard> {
  late final InAppUpdateService _service =
      widget.updateService ?? InAppUpdateService.instance;
  InAppUpdateConfiguration? _configuration;
  _VersionCardStatus _status = _VersionCardStatus.loading;
  bool _checking = false;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  String _text(String english, String arabic) => _isArabic ? arabic : english;

  @override
  void initState() {
    super.initState();
    unawaited(_refreshStatus());
  }

  Future<void> _refreshStatus({bool prompt = false}) async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _status = _VersionCardStatus.loading;
    });
    try {
      final config = await _service.configuration();
      if (!mounted) return;
      _configuration = config;
      if (config.playStoreManaged) {
        setState(() => _status = _VersionCardStatus.managedByStore);
        return;
      }
      if (!config.distributionAllowed || config.manifestUrl.isEmpty) {
        setState(() => _status = _VersionCardStatus.unavailable);
        return;
      }

      final release = await checkForAppUpdates(
        context: context,
        service: _service,
        showPrompt: prompt,
        includeDeferred: true,
      );
      if (!mounted) return;
      setState(
        () => _status = release == null
            ? _VersionCardStatus.current
            : _VersionCardStatus.available,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = _VersionCardStatus.failed);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  String get _statusText => switch (_status) {
    _VersionCardStatus.loading => _text(
      'Checking for updates…',
      'جارٍ التحقق من التحديثات…',
    ),
    _VersionCardStatus.available => _text(
      'Update available',
      'يتوفر تحديث جديد',
    ),
    _VersionCardStatus.current => _text('You’re up to date', 'التطبيق محدّث'),
    _VersionCardStatus.managedByStore => _text(
      'Updates managed by Google Play',
      'التحديثات عبر متجر Google Play',
    ),
    _VersionCardStatus.unavailable => _text(
      'Updates unavailable for this build',
      'التحديث غير مفعّل لهذه النسخة',
    ),
    _VersionCardStatus.failed => _text(
      'Could not check right now',
      'تعذّر التحقق حالياً',
    ),
  };

  Color _statusColor(BuildContext context) => switch (_status) {
    _VersionCardStatus.available => Theme.of(context).colorScheme.primary,
    _VersionCardStatus.current => Colors.green.shade700,
    _VersionCardStatus.managedByStore ||
    _VersionCardStatus.unavailable => Theme.of(context).colorScheme.secondary,
    _VersionCardStatus.failed => Theme.of(context).colorScheme.error,
    _VersionCardStatus.loading => Theme.of(context).colorScheme.primary,
  };

  IconData get _statusIcon => switch (_status) {
    _VersionCardStatus.available => Icons.system_update_alt_rounded,
    _VersionCardStatus.current => Icons.check_circle_outline_rounded,
    _VersionCardStatus.managedByStore => Icons.shop_2_outlined,
    _VersionCardStatus.unavailable => Icons.info_outline_rounded,
    _VersionCardStatus.failed => Icons.cloud_off_outlined,
    _VersionCardStatus.loading => Icons.sync_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBackground = context.customColor.reversedTextColor;
    final logo = theme.brightness == Brightness.dark
        ? AppAssets.darkLogo
        : AppAssets.logo;
    final versionName = _configuration?.versionName;
    final versionCode = _configuration?.versionCode;

    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(16.r, 16.r, 16.r, 24.r),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: .45)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: .06),
            blurRadius: 18.r,
            offset: Offset(0, 6.r),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54.r,
                height: 54.r,
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Image.asset(
                  logo,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.inventory_2_outlined,
                    color: theme.colorScheme.primary,
                    size: 31.r,
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSAB',
                      style: AppStyles.s16W600.copyWith(
                        color: theme.colorScheme.primary,
                        letterSpacing: .7,
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      _text('App version', 'إصدار التطبيق'),
                      style: AppStyles.s13W500.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Wrap(
            spacing: 8.r,
            runSpacing: 8.r,
            children: [
              _VersionTag(
                label: versionName == null
                    ? _text('Version unavailable', 'الإصدار غير متاح')
                    : '${_text('Version', 'الإصدار')} $versionName',
              ),
              _VersionTag(
                label: versionCode == null
                    ? _text('Build unavailable', 'رقم البناء غير متاح')
                    : '${_text('Build', 'رقم البناء')} $versionCode',
              ),
            ],
          ),
          14.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
            decoration: BoxDecoration(
              color: _statusColor(context).withValues(alpha: .08),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Row(
              children: [
                if (_status == _VersionCardStatus.loading)
                  SizedBox.square(
                    dimension: 17.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.r,
                      color: _statusColor(context),
                    ),
                  )
                else
                  Icon(_statusIcon, size: 18.r, color: _statusColor(context)),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    _statusText,
                    style: AppStyles.s12W500.copyWith(
                      color: _statusColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          14.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _checking ? null : () => _refreshStatus(prompt: true),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(_text('Check for updates', 'تحقق من التحديثات')),
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionTag extends StatelessWidget {
  const _VersionTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.r, vertical: 7.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: AppStyles.s12W500.copyWith(color: theme.colorScheme.onSurface),
      ),
    );
  }
}
